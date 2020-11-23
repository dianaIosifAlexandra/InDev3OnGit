--Drops the Procedure bgtMoveRevisedBudget if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtMoveRevisedBudget]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtMoveRevisedBudget
GO

CREATE  PROCEDURE [dbo].[bgtMoveRevisedBudget]
	@IdProject			INT,
	@IdAssociateLM			INT, -- LM: member that leaves the project
	@IdAssociateNM			INT,  -- NM: new member, that takes over the budget from LM
	@IdAssociateMovingBudget		INT  -- the member that moves the budget from LM (leaving member) to NM (new member)
AS


CREATE TABLE #RevisedVersionNo (BudgetVersion int, IsVersionActual int)
INSERT INTO #RevisedVersionNo
	EXEC bgtGetRevisedVersionNo @IdProject, @Version = N'N'

DECLARE @IdGeneration int
SELECT @IdGeneration = BudgetVersion
FROM #RevisedVersionNo

declare @NewAssociateReturns bit
set @NewAssociateReturns = 0

if exists(select Id from BUDGET_REVISED_MOVE_OPERATIONS
				where IdProject = @IdProject 
				and IdAssociateFrom = @IdAssociateNM
	   )
begin
 set @NewAssociateReturns = 1
end

-- commented on November 2017. The customer wanted to delete data that belongs to new member
--IF EXISTS
--(
--	SELECT * 
--	FROM
--	(
--		SELECT *
--		FROM BUDGET_REVISED_DETAIL
--		WHERE IdProject = @IdProject
--		AND IdGeneration = @IdGeneration
--		AND IdAssociate = @IdAssociateLM
--	) t
--	INNER JOIN
--	(
--		SELECT *
--		FROM BUDGET_REVISED_DETAIL
--		WHERE IdProject = @IdProject
--		AND IdGeneration = @IdGeneration
--		AND IdAssociate = @IdAssociateNM
--	) t1
--	ON  t.IdProject = t1.IdProject
--	AND t.IdGeneration = t1.IdGeneration
--	AND t.IdPhase = t1.IdPhase
--	AND t.IdWorkPackage = t1.IdWorkPackage
--	AND t.IdCostCenter = t1.IdCostCenter
--	AND t.YearMonth = t1.YearMonth
--	AND case when @NewAssociateReturns = 1 then t1.HoursQty else 1 end <> 0
--	  -- In case New Associate returns ignore the fact that he/she has data with 0 values
--	  -- which have been set when he/she left team
--)
--OR EXISTS
--(
--	SELECT * 
--	FROM
--	(
--		SELECT *
--		FROM BUDGET_REVISED_DETAIL_COSTS
--		WHERE IdProject = @IdProject
--		AND IdGeneration = @IdGeneration
--		AND IdAssociate = @IdAssociateLM
--	) t
--	INNER JOIN
--	(
--		SELECT *
--		FROM BUDGET_REVISED_DETAIL_COSTS
--		WHERE IdProject = @IdProject
--		AND IdGeneration = @IdGeneration
--		AND IdAssociate = @IdAssociateNM
--	) t1
--	ON  t.IdProject = t1.IdProject
--	AND t.IdGeneration = t1.IdGeneration
--	AND t.IdPhase = t1.IdPhase
--	AND t.IdWorkPackage = t1.IdWorkPackage
--	AND t.IdCostCenter = t1.IdCostCenter
--	AND t.YearMonth = t1.YearMonth
--	AND t.IdCostType = t1.IdCostType
--	AND case when @NewAssociateReturns = 1 then t1.CostVal else 1 end <> 0
--	  -- In case New Associate returns ignore the fact that he/she has data with 0 values
--	  -- which have been set when he/she left team

--)
--BEGIN
--	RAISERROR('Error: Duplicated items found in source and destination', 16, 1)
--	RETURN -1
--END

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



	delete BUDGET_REVISED_DETAIL_COSTS
	where IdProject = @IdProject
	and IdGeneration = @IdGeneration
	and IdAssociate = @IdAssociateNM


	delete BUDGET_REVISED_DETAIL
	where IdProject = @IdProject
	and IdGeneration = @IdGeneration
	and IdAssociate = @IdAssociateNM

/*
-- commented on November 2017
if @NewAssociateReturns = 1
   begin
-- in this case delete data with IdGeneration = @IdGeneration if ALL records have value = 0
-- because these records have been inserted when NewAssociate left the team
	if 0 = ALL (
			select HoursQty
			from BUDGET_REVISED_DETAIL
			where IdProject = @IdProject
			and IdGeneration = @IdGeneration
			and IdAssociate = @IdAssociateNM
			)
	AND
	  0 = ALL (
			select CostVal
			from BUDGET_REVISED_DETAIL_COSTS
			where IdProject = @IdProject
			and IdGeneration = @IdGeneration
			and IdAssociate = @IdAssociateNM
			)
	   begin
			delete BUDGET_REVISED_DETAIL_COSTS
			where IdProject = @IdProject
			and IdGeneration = @IdGeneration
			and IdAssociate = @IdAssociateNM

			delete BUDGET_REVISED_DETAIL
			where IdProject = @IdProject
			and IdGeneration = @IdGeneration
			and IdAssociate = @IdAssociateNM
	   end
   end
*/

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

declare @State_AssociateLM varchar(1)

select @State_AssociateLM = [State] from BUDGET_REVISED_STATES
	WHERE IdProject = @IdProject 
		AND IdGeneration = @IdGeneration 
		AND IdAssociate = @IdAssociateLM 

select @State_AssociateLM = isnull(@State_AssociateLM,'N')
  
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
	set [State] = @State_AssociateLM
	WHERE IdProject = @IdProject 
	AND IdGeneration = @IdGeneration 
	AND IdAssociate = @IdAssociateNM
else
	insert into  BUDGET_REVISED_STATES
	(IdProject, IdGeneration, IdAssociate, [State], StateDate)
	select @IdProject, @IdGeneration, @IdAssociateNM, @State_AssociateLM, getdate()

go

