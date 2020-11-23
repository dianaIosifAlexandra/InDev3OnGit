--Drops the Procedure bgtMoveToCompletionBudgetReleasedVersion if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtMoveToCompletionBudgetReleasedVersion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtMoveToCompletionBudgetReleasedVersion
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[bgtMoveToCompletionBudgetReleasedVersion]
	@IdProject		INT,
	@IdAssociateLM		INT, -- LM: member that leaves the project
	@IdAssociateNM		INT,  -- NM: new member, that takes over the budget from LM
	@IdAssociateMovingBudget		INT,  -- the member that moves the budget from LM (leaving member) to NM (new member)
	@ExecuteMoveRevisedBudget int = 1 -- if =1, RevisedBudget is moved too
AS

DECLARE @IdGeneration int

SELECT @IdGeneration = MAX(IdGeneration) 
FROM BUDGET_TOCOMPLETION TABLOCKX
WHERE 	IdProject = @IdProject AND IsValidated = 1


if(
	(SELECT count(*)
	 FROM BUDGET_TOCOMPLETION_DETAIL
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociateLM)
	
	+
	(SELECT count(*)
	 FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociateLM) = 0)
BEGIN	
	RAISERROR('There is no data to transfer', 16, 1)
	RETURN -2
END

-- delete any existing reforecast data for this generation
	delete BUDGET_TOCOMPLETION_DETAIL_COSTS
	where IdProject = @IdProject
	and IdGeneration = @IdGeneration
	and IdAssociate = @IdAssociateNM


	delete BUDGET_TOCOMPLETION_DETAIL
	where IdProject = @IdProject
	and IdGeneration = @IdGeneration
	and IdAssociate = @IdAssociateNM

	delete BUDGET_TOCOMPLETION_PROGRESS
	WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociateNM

-- insert data for the new member

INSERT INTO BUDGET_TOCOMPLETION_PROGRESS 
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdAssociate, [Percent])
SELECT IdProject, IdGeneration, IdPhase, IdWorkPackage, @IdAssociateNM, [Percent]
FROM BUDGET_TOCOMPLETION_PROGRESS
WHERE IdProject = @IdProject
	AND IdGeneration = @IdGeneration
	AND IdAssociate = @IdAssociateLM

update BUDGET_TOCOMPLETION_PROGRESS
set [Percent] = 0
WHERE IdProject = @IdProject
	AND IdGeneration = @IdGeneration
	AND IdAssociate = @IdAssociateLM  

INSERT INTO BUDGET_TOCOMPLETION_DETAIL
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales)
SELECT IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, @IdAssociateNM, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales
FROM BUDGET_TOCOMPLETION_DETAIL
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM


INSERT INTO BUDGET_TOCOMPLETION_DETAIL_COSTS
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount)
SELECT IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, @IdAssociateNM, YearMonth, IdCostType, CostVal, IdCountry, IdAccount
FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM

-- set 0 to the values for the old member
update BUDGET_TOCOMPLETION_DETAIL
set HoursQty = 0, HoursVal = 0, SalesVal = 0
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM


update BUDGET_TOCOMPLETION_DETAIL_COSTS
set CostVal = 0
FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM


--insert data into the logs table
INSERT INTO BUDGET_TOCOMPLETION_MOVE_OPERATIONS
VALUES(@IdProject, @IdGeneration, GETDATE(), @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget)

declare @State_AssociateLM varchar(1)

select @State_AssociateLM = [State] from BUDGET_TOCOMPLETION_STATES
	WHERE IdProject = @IdProject 
		AND IdGeneration = @IdGeneration 
		AND IdAssociate = @IdAssociateLM 

select @State_AssociateLM = isnull(@State_AssociateLM,'N')

update BUDGET_TOCOMPLETION_STATES
set [State] = 'N'
WHERE IdProject = @IdProject 
  AND IdGeneration = @IdGeneration 
  AND IdAssociate = @IdAssociateLM	


if exists(select * from BUDGET_TOCOMPLETION_STATES
						WHERE IdProject = @IdProject 
						AND IdGeneration = @IdGeneration 
						AND IdAssociate = @IdAssociateNM)
   
   update BUDGET_TOCOMPLETION_STATES
	set [State] = 'V'
	WHERE IdProject = @IdProject 
	AND IdGeneration = @IdGeneration 
	AND IdAssociate = @IdAssociateNM
else
	insert into  BUDGET_TOCOMPLETION_STATES
	(IdProject, IdGeneration, IdAssociate, [State], StateDate)
	select @IdProject, @IdGeneration, @IdAssociateNM, @State_AssociateLM, getdate()


if @ExecuteMoveRevisedBudget = 1 
   begin
		declare @RevisedIsReleasedTable table (RevisedIsReleased int)

		insert into @RevisedIsReleasedTable
		exec [bgtGetLastValidatedRevisedVersion]  @IdProject

		if (select RevisedIsReleased from  @RevisedIsReleasedTable) > 0
		  begin
			-- Revised has Released version
			exec [bgtMoveRevisedBudgetReleasedVersion] @IdProject, @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget, 0
		  end
		else
		   begin
			 declare @IdVersionProgress int
			-- check if status is in Progress
				select @IdVersionProgress = dbo.fnGetRevisedBudgetGeneration(@IdProject,'N')
				if @IdVersionProgress is not null
				  -- it exists an InProgressVersion, we call "normal" move budget
				    begin
						exec bgtMoveRevisedBudget @IdProject, @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget
					end
		   end
   end

GO


