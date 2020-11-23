--Drops the Procedure bgtMoveRevisedBudgetReleasedVersion if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtMoveRevisedBudgetReleasedVersion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtMoveRevisedBudgetReleasedVersion
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[bgtMoveRevisedBudgetReleasedVersion]
	@IdProject			INT,
	@IdAssociateLM			INT, -- LM: member that leaves the project
	@IdAssociateNM			INT,  -- NM: new member, that takes over the budget from LM
	@IdAssociateMovingBudget		INT,  -- the member that moves the budget from LM (leaving member) to NM (new member)
	@ExecuteMoveReforecastBudget int = 1 -- if = 1 Reforecast budget will be moved too
AS


DECLARE @IdGeneration int

SELECT @IdGeneration = MAX(IdGeneration) 
FROM BUDGET_REVISED TABLOCKX
WHERE 	IdProject = @IdProject AND IsValidated = 1

if(
	(SELECT count(*)
	 FROM BUDGET_REVISED_DETAIL
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociateLM)
	
	+
	(SELECT count(*)
	 FROM BUDGET_REVISED_DETAIL_COSTS
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociateLM) = 0)
BEGIN	
	RAISERROR('There is no data to transfer', 16, 1)
	RETURN -2
END

-- delete any existing revised data for this generation

	delete BUDGET_REVISED_DETAIL_COSTS
	where IdProject = @IdProject
	and IdGeneration = @IdGeneration
	and IdAssociate = @IdAssociateNM


	delete BUDGET_REVISED_DETAIL
	where IdProject = @IdProject
	and IdGeneration = @IdGeneration
	and IdAssociate = @IdAssociateNM


-- insert data for the new member
INSERT INTO BUDGET_REVISED_DETAIL
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales)
SELECT IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, @IdAssociateNM, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales
FROM BUDGET_REVISED_DETAIL
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM

INSERT INTO BUDGET_REVISED_DETAIL_COSTS
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount)
SELECT IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, @IdAssociateNM, YearMonth, IdCostType, CostVal, IdCountry, IdAccount
FROM BUDGET_REVISED_DETAIL_COSTS
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM
  
-- insert data into the logs table
INSERT INTO BUDGET_REVISED_MOVE_OPERATIONS
	VALUES(@IdProject, @IdGeneration, GETDATE(), @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget)

	-- set to 0 old member data
update BUDGET_REVISED_DETAIL_COSTS
set CostVal = 0
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM

update BUDGET_REVISED_DETAIL
set HoursQty = 0, HoursVal = 0, SalesVal = 0
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM

  
update BUDGET_REVISED_STATES
set [State] = 'N'
WHERE IdProject = @IdProject 
  AND IdGeneration = @IdGeneration 
  AND IdAssociate = @IdAssociateLM  



if exists(select * from BUDGET_REVISED_STATES
						WHERE IdProject = @IdProject 
						AND IdGeneration = @IdGeneration 
						AND IdAssociate = @IdAssociateNM)
   
   update BUDGET_REVISED_STATES
	set [State] = 'V'
	WHERE IdProject = @IdProject 
	AND IdGeneration = @IdGeneration 
	AND IdAssociate = @IdAssociateNM
else
	insert into  BUDGET_REVISED_STATES
	(IdProject, IdGeneration, IdAssociate, [State], StateDate)
	select @IdProject, @IdGeneration, @IdAssociateNM, 'V', getdate()

if @ExecuteMoveReforecastBudget = 1 
   begin
		declare @ReforecastIsReleasedTable table (ReforecastReleased int)

		insert into @ReforecastIsReleasedTable
		exec [bgtGetLastValidatedReforecastVersion] @IdProject

		if (select ReforecastReleased from @ReforecastIsReleasedTable)  > 0
		  begin
			-- Reforecast has Released version
			exec [bgtMoveToCompletionBudgetReleasedVersion] @IdProject, @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget, 0
		  end
		else
		   begin
			 declare @IdVersionProgress int
			-- check if status is in Progress
				select @IdVersionProgress = dbo.fnGetToCompletionBudgetGeneration(@IdProject,'N')
				if @IdVersionProgress is not null
				  -- it exists an InProgressVersion, we call "normal" move budget
				    begin
						exec bgtMoveToCompletionBudget @IdProject, @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget
					end
		   end

   end

go
