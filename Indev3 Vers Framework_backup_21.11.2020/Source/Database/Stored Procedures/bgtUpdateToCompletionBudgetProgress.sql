--Drops the Procedure bgtUpdateToCompletionBudgetProgress if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateToCompletionBudgetProgress]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateToCompletionBudgetProgress
GO

CREATE  PROCEDURE bgtUpdateToCompletionBudgetProgress
	@IdAssociate		INT,
	@IdProject		INT,
	@IdPhase		INT,
	@IdWP			INT,
	@Percentage		DECIMAL(18, 2)
AS
	--Get the new generation Id
	DECLARE @NewGeneration		INT
	DECLARE @CurrentGeneration	INT

	DECLARE @RetVal INT

	SET @NewGeneration = dbo.fnGetToCompletionBudgetGeneration (@IdProject, 'N')
	
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

	IF NOT EXISTS (
		SELECT 	IdProject
		FROM 	BUDGET_TOCOMPLETION_PROGRESS
		WHERE	IdProject = @IdProject
		AND	IdGeneration = @NewGeneration
		AND	IdPhase = @IdPhase
		AND	IdAssociate = @IdAssociate
		AND 	IdWorkPackage = @IdWP
	)
	BEGIN
		INSERT INTO BUDGET_TOCOMPLETION_PROGRESS 
			(IdProject,   IdGeneration,   IdPhase,  IdWorkPackage, IdAssociate,  [Percent])
		VALUES (@IdProject,   @NewGeneration, @IdPhase, @IdWP,  @IdAssociate, @Percentage)
	END
	ELSE
	BEGIN
		UPDATE	BUDGET_TOCOMPLETION_PROGRESS
		SET 	[Percent] = @Percentage
		WHERE	IdProject = @IdProject
		AND	IdGeneration = @NewGeneration
		AND	IdPhase = @IdPhase
		AND	IdAssociate = @IdAssociate
		AND 	IdWorkPackage = @IdWP
	END
GO

