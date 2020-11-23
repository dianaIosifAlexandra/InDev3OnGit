--Drops the Procedure bgtDeleteInitialBudgetDetail if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtDeleteInitialBudgetDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtDeleteInitialBudgetDetail
GO

CREATE  PROCEDURE bgtDeleteInitialBudgetDetail
	@IdProject	INT,		--The Id of the selected Project
	@IdPhase	INT,		--The Id of a phase from project
	@IdWP		INT,		--The Id of workpackage
	@IdCostCenter	INT,		--The Id of cost center
	@IdAssociate	INT,		--The Id of associate
	@YearMonth	INT
	
AS
BEGIN
	--delete initial budget detail other costs
	DELETE FROM BUDGET_INITIAL_DETAIL_COSTS 
	WHERE IdProject = @IdProject
		AND IdPhase = @IdPhase
		AND IdWorkPackage = @IdWP
		AND IdCostCenter = @IdCostCenter
		AND IdAssociate = @IdAssociate
		AND YearMonth = @YearMonth
	
	--delete initial budget detail
	DELETE FROM BUDGET_INITIAL_DETAIL
	WHERE IdProject = @IdProject
		AND IdPhase = @IdPhase
		AND IdWorkPackage = @IdWP
		AND IdCostCenter = @IdCostCenter
		AND IdAssociate = @IdAssociate
		AND YearMonth = @YearMonth
END
GO

