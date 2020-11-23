--Drops the Procedure bgtDeleteRevisedBudgetDetail if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtDeleteRevisedBudgetDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtDeleteRevisedBudgetDetail
GO

CREATE  PROCEDURE bgtDeleteRevisedBudgetDetail
	@IdProject	INT,		--The Id of the selected Project
	@IdPhase	INT,		--The Id of a phase from project
	@IdWP		INT,		--The Id of workpackage
	@IdCostCenter	INT,		--The Id of cost center
	@IdAssociate	INT,		--The Id of associate
	@YearMonth	INT
	
AS
BEGIN
	DECLARE @CurrentGeneration INT
	DECLARE @CurrentHours INT
	DECLARE @CurrentVal DECIMAL(18, 4)  
	DECLARE @CurrentSales DECIMAL(18, 4)
	DECLARE @CurrentCosts DECIMAL(18, 2)

	SELECT @CurrentGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,'C')
	IF (@CurrentGeneration IS NULL)
	BEGIN
		RAISERROR('No released generation found for Revised Budget', 16, 1)
		RETURN -1
	END
	
	--isnull works here because the value is used only for checking
	SELECT 	@CurrentHours = SUM(ISNULL(HoursQty, 0)),
		@CurrentVal = SUM(ISNULL(HoursVal, 0)),
		@CurrentSales = SUM(ISNULL(SalesVal, 0))
	FROM 	BUDGET_REVISED_DETAIL
	WHERE 	IdProject = @IdProject AND
		IdPhase = @IdPhase AND
		IdWorkPackage = @IdWP AND
		IdCostCenter = @IdCostCenter AND
		IdAssociate = @IdAssociate AND
		IdGeneration = @CurrentGeneration

	SELECT 	@CurrentCosts = SUM(ISNULL(CostVal, 0))
	FROM 	BUDGET_REVISED_DETAIL_COSTS
	WHERE 	IdProject = @IdProject AND
		IdPhase = @IdPhase AND
		IdWorkPackage = @IdWP AND
		IdCostCenter = @IdCostCenter AND
		IdAssociate = @IdAssociate AND
		IdGeneration = @CurrentGeneration

	IF (	ISNULL(@CurrentHours, 0) <> 0 OR
		ISNULL(@CurrentVal, 0) <> 0 OR
		ISNULL(@CurrentSales, 0) <> 0 OR
		ISNULL(@CurrentCosts, 0) <> 0)
	BEGIN
		DECLARE @ccName varchar(70)
		DECLARE @err varchar(255)

		SELECT @ccName = DP.[Name]+'-'+IL.Code+'-'+CC.[Code]
		FROM COST_CENTERS CC
		INNER JOIN DEPARTMENTS DP
			ON DP.[Id] = CC.IdDepartment
		INNER JOIN INERGY_LOCATIONS AS IL
			ON IL.[Id] = CC.IdInergyLocation
		WHERE CC.Id = @IdCostCenter

		SEt @err ='Cost Center '+@ccName+' cannot be deleted because it is used in Released version.' 
		RAISERROR(@err, 16, 1)
		RETURN -2
	END
	
	
	DECLARE @IdGeneration INT
	SELECT @IdGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,'N')

	IF (@IdGeneration IS NULL)
	BEGIN
		RAISERROR('No new generation found for Revised Budget', 16, 1)
		RETURN -3
	END		

	--delete initial budget detail other costs
	DELETE FROM BUDGET_REVISED_DETAIL_COSTS 
	WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdPhase = @IdPhase
		AND IdWorkPackage = @IdWP
		AND IdCostCenter = @IdCostCenter
		AND IdAssociate = @IdAssociate
		AND YearMonth = @YearMonth
	
	--delete initial budget detail
	DELETE FROM BUDGET_REVISED_DETAIL
	WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdPhase = @IdPhase
		AND IdWorkPackage = @IdWP
		AND IdCostCenter = @IdCostCenter
		AND IdAssociate = @IdAssociate
		AND YearMonth = @YearMonth
END
GO

