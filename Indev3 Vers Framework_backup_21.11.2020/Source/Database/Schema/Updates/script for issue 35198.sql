
DECLARE @IdProject INT
DECLARE @NewGeneration INT
DECLARE @IdAssociate INT


BEGIN TRANSACTION

-- BUDGET_TOCOMPLETION

DECLARE ProjectsCursor CURSOR FAST_FORWARD FOR
select distinct IdProject,dbo.fnGetToCompletionBudgetGeneration(IdProject,'N') as NewGeneration
from BUDGET_TOCOMPLETION
where dbo.fnGetToCompletionBudgetGeneration(IdProject,'N') is not null

OPEN ProjectsCursor

	
FETCH NEXT FROM ProjectsCursor INTO @IdProject,@NewGeneration
WHILE @@FETCH_STATUS = 0
BEGIN
	
	DECLARE AssociatesCursor CURSOR FAST_FORWARD FOR
	SELECT 	IdAssociate
	FROM	PROJECT_CORE_TEAMS
	WHERE IdProject = @IdProject and 
		  IsActive = 1
	
	OPEN AssociatesCursor
	
	FETCH NEXT FROM AssociatesCursor INTO @IdAssociate
	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- BUDGET_TOCOMPLETION_PROGRESS
		
		IF NOT EXISTS
		(
			SELECT IdProject,IdAssociate
			FROM BUDGET_TOCOMPLETION_PROGRESS
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration
		)
		BEGIN
			INSERT INTO BUDGET_TOCOMPLETION_PROGRESS 
				(IdProject,   IdGeneration,   IdPhase,  IdWorkPackage,   IdAssociate,  [Percent])
			select IdProject,   @NewGeneration,   IdPhase,  IdWorkPackage,   IdAssociate,  [Percent]
			FROM BUDGET_TOCOMPLETION_PROGRESS
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration - 1

		END

		-- BUDGET_TOCOMPLETION_DETAIL

		IF NOT EXISTS
		(
			SELECT IdProject,IdAssociate
			FROM BUDGET_TOCOMPLETION_DETAIL
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration
		)
		BEGIN
			INSERT INTO BUDGET_TOCOMPLETION_DETAIL
			(IdProject, IdGeneration,   IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth, HoursQty,  HoursVal, SalesVal, IdCountry,  IdAccountHours,  IdAccountSales)
			SELECT IdProject, @NewGeneration,   IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth, HoursQty,  HoursVal, SalesVal, IdCountry,  IdAccountHours,  IdAccountSales 
			FROM BUDGET_TOCOMPLETION_DETAIL
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration - 1		

		END

-- 		BUDGET_TOCOMPLETION_STATES

		IF NOT EXISTS
		(
			SELECT IdProject,IdAssociate
			FROM BUDGET_TOCOMPLETION_STATES
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration
		)
		BEGIN
			INSERT INTO BUDGET_TOCOMPLETION_STATES
				(IdProject, IdGeneration, IdAssociate, State, StateDate)
			VALUES 
				(@IdProject, @NewGeneration, @IdAssociate, 'N', GETDATE())
		END

		--BUDGET_TOCOMPLETION_DETAIL_COSTS

		IF NOT EXISTS
		(
			SELECT IdProject,IdAssociate
			FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration
		)
		BEGIN
			INSERT INTO BUDGET_TOCOMPLETION_DETAIL_COSTS
				(IdProject,  IdGeneration,   IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth,   IdCostType, CostVal, IdCountry,  IdAccount)
			SELECT IdProject, @NewGeneration,   IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth,   IdCostType, CostVal, IdCountry,  IdAccount
			FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration - 1
		END



		FETCH NEXT FROM AssociatesCursor INTO @IdAssociate
	END
	
	CLOSE AssociatesCursor
	DEALLOCATE AssociatesCursor

	FETCH NEXT FROM ProjectsCursor INTO @IdProject,@NewGeneration
END

CLOSE ProjectsCursor
DEALLOCATE ProjectsCursor

-- BUDGET_REVISED


DECLARE ProjectsCursorRevised CURSOR FAST_FORWARD FOR
select distinct IdProject,dbo.fnGetRevisedBudgetGeneration(IdProject,'N') as NewGeneration
from BUDGET_REVISED
where dbo.fnGetRevisedBudgetGeneration(IdProject,'N') is not null

OPEN ProjectsCursorRevised


FETCH NEXT FROM ProjectsCursorRevised INTO @IdProject,@NewGeneration
WHILE @@FETCH_STATUS = 0
BEGIN
	
	DECLARE AssociatesCursorRevised CURSOR FAST_FORWARD FOR
	SELECT 	IdAssociate
	FROM	PROJECT_CORE_TEAMS
	WHERE IdProject = @IdProject and 
		  IsActive = 1
	
	OPEN AssociatesCursorRevised
	
	FETCH NEXT FROM AssociatesCursorRevised INTO @IdAssociate
	WHILE @@FETCH_STATUS = 0
	BEGIN

		--BUDGET_REVISED_DETAIL
		
		IF NOT EXISTS
		(
			SELECT IdProject,IdAssociate
			FROM BUDGET_REVISED_DETAIL
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration
		)
		BEGIN
			INSERT INTO BUDGET_REVISED_DETAIL
				(IdProject, IdGeneration,  IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth,  HoursQty,  HoursVal, SalesVal, IdCountry,  IdAccountHours,  IdAccountSales)
			SELECT IdProject, @NewGeneration,  IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth,  HoursQty,  HoursVal, SalesVal, IdCountry,  IdAccountHours,  IdAccountSales
			FROM BUDGET_REVISED_DETAIL
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration - 1			

		END
		
		--BUDGET_REVISED_STATES

		IF NOT EXISTS
		(
			SELECT IdProject,IdAssociate
			FROM BUDGET_REVISED_STATES
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration
		)
		BEGIN

			INSERT INTO BUDGET_REVISED_STATES
				(IdProject, IdGeneration, IdAssociate, State, StateDate)
			VALUES 
				(@IdProject, @NewGeneration, @IdAssociate, 'N', GETDATE())
		END

		--BUDGET_REVISED_DETAIL_COSTS

		IF NOT EXISTS
		(
			SELECT IdProject,IdAssociate
			FROM BUDGET_REVISED_DETAIL_COSTS
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration
		)
		BEGIN
			INSERT INTO BUDGET_REVISED_DETAIL_COSTS
				(IdProject,  IdGeneration,  IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth,  IdCostType,  CostVal, IdCountry,  IdAccount)
			SELECT IdProject, @NewGeneration,  IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth,  IdCostType,  CostVal, IdCountry,  IdAccount
			FROM BUDGET_REVISED_DETAIL_COSTS
			WHERE 	IdProject = @IdProject and
				IdAssociate = @IdAssociate and
				IdGeneration = @NewGeneration - 1
		END



		FETCH NEXT FROM AssociatesCursorRevised INTO @IdAssociate
	END
	
	CLOSE AssociatesCursorRevised
	DEALLOCATE AssociatesCursorRevised

	FETCH NEXT FROM ProjectsCursorRevised INTO @IdProject,@NewGeneration
END

CLOSE ProjectsCursorRevised
DEALLOCATE ProjectsCursorRevised



COMMIT TRANSACTION


