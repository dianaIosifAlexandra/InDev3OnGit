--Drops the Procedure bgtGetToCompletionBudgetHoursEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtDeleteCostCenterFromToCompletionBudget]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtDeleteCostCenterFromToCompletionBudget
GO

CREATE  PROCEDURE bgtDeleteCostCenterFromToCompletionBudget
	@IdAssociate		INT,
	@IdProject		INT,
	@IdPhase		INT,
	@IdWP			INT,
	@IdCostCenter		INT
AS
	

	--Get the new generation Id
	DECLARE @NewGeneration		INT
	DECLARE @CurrentGeneration	INT

	SET @NewGeneration = dbo.fnGetToCompletionBudgetGeneration (@IdProject, 'N')
	
	DECLARE @RetVal INT

	IF (@NewGeneration IS NULL)
	BEGIN
		SET @CurrentGeneration = dbo.fnGetToCompletionBudgetGeneration(@IdProject,'C')
		IF (@CurrentGeneration IS NULL)
		BEGIN
			RAISERROR('No released generation found for To Completion budget', 16, 1)
			RETURN -1
		END
		SET @NewGeneration = @CurrentGeneration + 1
		
		EXEC @RetVal = bgtToCompletionBudgetCreateNewFromCurrentAll @IdProject = @IdProject, @NewGeneration = @NewGeneration
		IF (@@ERROR <> 0 OR @RetVal < 0)
			RETURN -2
	END
	
	DELETE FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
	WHERE 	IdProject = @IdProject AND
		IdGeneration = @NewGeneration AND
		IdPhase = @IdPhase AND
		IdWorkPackage = @IdWP AND
		IdCostCenter = @IdCostCenter AND
		IdAssociate = @IdAssociate

	DELETE FROM BUDGET_TOCOMPLETION_DETAIL
	WHERE 	IdProject = @IdProject AND
		IdGeneration = @NewGeneration AND
		IdPhase = @IdPhase AND
		IdWorkPackage = @IdWP AND
		IdCostCenter = @IdCostCenter AND
		IdAssociate = @IdAssociate

	IF NOT EXISTS
	(
		SELECT 	IdProject FROM BUDGET_TOCOMPLETION_DETAIL
		WHERE 	IdProject = @IdProject AND
			IdGeneration = @NewGeneration AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP AND
			IdAssociate = @IdAssociate
	)
	BEGIN
		DELETE 	FROM BUDGET_TOCOMPLETION_PROGRESS
		WHERE 	IdProject = @IdProject AND
			IdGeneration = @NewGeneration AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP AND
			IdAssociate = @IdAssociate
	END
GO

