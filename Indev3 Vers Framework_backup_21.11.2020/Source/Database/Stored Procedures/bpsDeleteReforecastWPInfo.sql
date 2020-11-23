--Drops the Procedure bpsDeleteReforecastWPInfo if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bpsDeleteReforecastWPInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bpsDeleteReforecastWPInfo
GO
CREATE PROCEDURE bpsDeleteReforecastWPInfo
	@IdProject 			AS INT, 	--The Id of the Project
	@IdPhase			AS INT,		--The Id of the Phase
	@IdWP				AS INT,		--The Id of the WP
	@IdAssociate		AS INT,		--The Id of the associate
	@WPCode				AS VARCHAR(3)
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
		RETURN -4
	END

	SET @NewGeneration = dbo.fnGetToCompletionBudgetGeneration (@IdProject, 'N')
	SET @CurrentGeneration = dbo.fnGetToCompletionBudgetGeneration(@IdProject,'C')
	
	IF (@CurrentGeneration IS NULL)
	BEGIN
		RAISERROR('No released version found for reforecast budget.', 16, 1)
		RETURN -5
	END

	IF (@NewGeneration IS NULL)		
	BEGIN
		SET @NewGeneration = @CurrentGeneration + 1

		EXEC @retVal = bgtToCompletionBudgetCreateNewFromCurrentAll @IdProject = @IdProject, @NewGeneration = @NewGeneration
		IF (@@ERROR <> 0 OR @retVal	< 0)
			RETURN -6
	END
	
	EXEC @retVal = bgtUpdateCompletionBudgetStates @IdProject = @IdProject, @BudVersion = 'N', @IdAssociate = @IdAssociate, @State = 'O'
	IF (@@ERROR <> 0 OR @retVal	< 0)
		RETURN -7

	DELETE FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
	WHERE 	IdProject = @IdProject AND
		IdGeneration = @NewGeneration AND
		IdPhase = @IdPhase AND
		IdWorkPackage = @IdWP AND
		IdAssociate = @IdAssociate

	DELETE FROM BUDGET_TOCOMPLETION_DETAIL
	WHERE 	IdProject = @IdProject AND
		IdGeneration = @NewGeneration AND
		IdPhase = @IdPhase AND
		IdWorkPackage = @IdWP AND
		IdAssociate = @IdAssociate
	
	DELETE 	FROM BUDGET_TOCOMPLETION_PROGRESS
	WHERE 	IdProject = @IdProject AND
		IdGeneration = @NewGeneration AND
		IdPhase = @IdPhase AND
		IdWorkPackage = @IdWP AND
		IdAssociate = @IdAssociate

END
GO

