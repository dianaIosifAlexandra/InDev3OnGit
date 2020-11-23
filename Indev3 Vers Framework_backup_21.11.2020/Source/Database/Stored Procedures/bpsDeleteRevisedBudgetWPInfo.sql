--Drops the Procedure bpsDeleteRevisedBudgetWPInfo if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bpsDeleteRevisedBudgetWPInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bpsDeleteRevisedBudgetWPInfo
GO
CREATE PROCEDURE bpsDeleteRevisedBudgetWPInfo
	@IdProject 		AS INT, 	--The Id of the Project
	@IdPhase		AS INT,		--The Id of the Phase
	@IdWP			AS INT,		--The Id of the WP
	@IdAssociate	AS INT,		--The Id of the associate
	@WPCode			AS VARCHAR(3)
AS
BEGIN

	DECLARE @NewGeneration INT
	DECLARE @CurrentGeneration INT

	DECLARE @ErrorMessage varchar(255)
	DECLARE @retVal	INT
	
	IF NOT EXISTS (
			SELECT [Id]
			FROM WORK_PACKAGES
			WHERE IdProject = @IdProject AND
			      IdPhase	= @IdPhase AND
			      Id = @IdWP
			)
	BEGIN
		SET @ErrorMessage = 'Key information about WP with code '+ @WPCode + ' has been changed by another user. Please refresh your information.'
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN -1
	END

	SET @NewGeneration = dbo.fnGetRevisedBudgetGeneration (@IdProject, 'N')
	SET @CurrentGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,'C')

	IF (@CurrentGeneration IS NULL)
	BEGIN
		RAISERROR('No released version found for revised budget.', 16, 1)
		RETURN -2
	END
	
	
	IF (@NewGeneration IS NULL)
	BEGIN
		SET @NewGeneration = @CurrentGeneration + 1
	
		EXEC @retVal = bgtRevisedBudgetCreateNewFromCurrentAll @IdProject = @IdProject, @NewGeneration = @NewGeneration
		IF (@@ERROR <> 0 OR @retVal	< 0)
			RETURN -3
	END
	
	EXEC @retVal = bgtUpdateRevisedBudgetStates @IdProject = @IdProject, @BudVersion = 'N', @IdAssociate = @IdAssociate, @State = 'O'
	IF (@@ERROR <> 0 OR @retVal	< 0)
		RETURN -4
		
	DECLARE @CurrentHours INT
	DECLARE @CurrentVal DECIMAL(18, 4)  
	DECLARE @CurrentSales DECIMAL(18, 4)
	DECLARE @CurrentCosts DECIMAL(18, 2)


	--isnull works here because the value is used only for checking
	SELECT 	@CurrentHours = SUM(ISNULL(HoursQty, 0)),
			@CurrentVal = SUM(ISNULL(HoursVal, 0)),
			@CurrentSales = SUM(ISNULL(SalesVal, 0))
	FROM 	BUDGET_REVISED_DETAIL
	WHERE 	IdProject = @IdProject AND
		IdPhase = @IdPhase AND
		IdWorkPackage = @IdWP AND
		IdAssociate = @IdAssociate AND
		IdGeneration = @CurrentGeneration

	SELECT 	@CurrentCosts = SUM(ISNULL(CostVal, 0))
	FROM 	BUDGET_REVISED_DETAIL_COSTS
	WHERE 	IdProject = @IdProject AND
		IdPhase = @IdPhase AND
		IdWorkPackage = @IdWP AND
		IdAssociate = @IdAssociate AND
		IdGeneration = @CurrentGeneration

	IF (ISNULL(@CurrentHours, 0) <> 0 OR
		ISNULL(@CurrentVal, 0) <> 0 OR
		ISNULL(@CurrentSales, 0) <> 0 OR
		ISNULL(@CurrentCosts, 0) <> 0)
	BEGIN
		DECLARE @wpName varchar(36)
		DECLARE @err varchar(255)

		SELECT @wpName = WP.[Code] + ' - '+WP.[Name]
		FROM WORK_PACKAGES WP
		WHERE 	WP.IdProject = @IdProject AND
				WP.IdPhase = @IdPhase AND
				WP.Id = @IdWP

		SET @err ='Work Package '+@wpName+' cannot be deleted because it is used in Released version.' 
		RAISERROR(@err, 16, 1)
		RETURN -5
	END		
	
	--delete initial budget detail other costs
	DELETE FROM BUDGET_REVISED_DETAIL_COSTS 
	WHERE IdProject = @IdProject
		AND IdGeneration = @NewGeneration
		AND IdPhase = @IdPhase
		AND IdWorkPackage = @IdWP
		AND IdAssociate = @IdAssociate
	
	--delete initial budget detail
	DELETE FROM BUDGET_REVISED_DETAIL
	WHERE IdProject = @IdProject
		AND IdGeneration = @NewGeneration
		AND IdPhase = @IdPhase
		AND IdWorkPackage = @IdWP
		AND IdAssociate = @IdAssociate
		
	
END
GO

