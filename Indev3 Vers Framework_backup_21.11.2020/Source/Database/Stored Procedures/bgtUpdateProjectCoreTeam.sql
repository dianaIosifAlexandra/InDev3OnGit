--Drops the Procedure bgtUpdateProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateProjectCoreTeam]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateProjectCoreTeam
GO
CREATE PROCEDURE bgtUpdateProjectCoreTeam
	@IdProject		INT,		--The Id of the Project that is connected to the Project Core Team you want to insert
	@IdAssociate		INT,		--The Id of the Associate that is connected to the Project Core Team you want to insert
	@IdFunction		INT,		--The Id of the Function that is connected to the Project Core Team you want to insert
	@IsActive		BIT
AS
DECLARE @ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20),
	@RowCount 		INT
	
	IF(@IdProject IS NULL OR 
	   @IdAssociate IS NULL OR 
	   @IdFunction IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	DECLARE @OldIsActive BIT
	SELECT  @OldIsActive = IsActive
	FROM	PROJECT_CORE_TEAMS
	WHERE	IdProject = @IdProject AND 
		IdAssociate = @IdAssociate

	DECLARE @BudgetState CHAR(1)
	DECLARE @IdGeneration INT

	--If we are making a core team member from active to inactive, delete all his budget information
	IF (@OldIsActive = 1 AND @IsActive = 0)
	BEGIN
		SELECT 	@BudgetState = State
		FROM	BUDGET_INITIAL_STATES
		WHERE 	IdProject = @IdProject AND
			IdAssociate = @IdAssociate AND
			State <> 'V' AND State <> 'N' AND State <> 'U'

		IF (@BudgetState IS NOT NULL)
		BEGIN
			DELETE FROM BUDGET_INITIAL_DETAIL_COSTS
			WHERE	IdProject = @IdProject AND
				IdAssociate = @IdAssociate
			DELETE FROM BUDGET_INITIAL_DETAIL
			WHERE	IdProject = @IdProject AND
				IdAssociate = @IdAssociate
		END

		SELECT 	@BudgetState = State,
			@IdGeneration = IdGeneration
		FROM	BUDGET_REVISED_STATES
		WHERE 	IdProject = @IdProject AND
			IdAssociate = @IdAssociate AND
			State <> 'V' AND State <> 'N'

		IF (@BudgetState IS NOT NULL AND @IdGeneration IS NOT NULL)
		BEGIN
			DELETE FROM BUDGET_REVISED_DETAIL_COSTS
			WHERE	IdProject = @IdProject AND
				IdAssociate = @IdAssociate AND
				IdGeneration = @IdGeneration
			DELETE FROM BUDGET_REVISED_DETAIL
			WHERE	IdProject = @IdProject AND
				IdAssociate = @IdAssociate AND
				IdGeneration = @IdGeneration
		END

		SELECT 	@BudgetState = State,
			@IdGeneration = IdGeneration
		FROM	BUDGET_TOCOMPLETION_STATES
		WHERE 	IdProject = @IdProject AND
			IdAssociate = @IdAssociate AND
			State <> 'V' AND State <> 'N'

		IF (@BudgetState IS NOT NULL AND @IdGeneration IS NOT NULL)
		BEGIN
			DELETE FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
			WHERE	IdProject = @IdProject AND
				IdAssociate = @IdAssociate AND
				IdGeneration = @IdGeneration
			DELETE FROM BUDGET_TOCOMPLETION_DETAIL
			WHERE	IdProject = @IdProject AND
				IdAssociate = @IdAssociate AND
				IdGeneration = @IdGeneration
			DELETE FROM BUDGET_TOCOMPLETION_PROGRESS
			WHERE	IdProject = @IdProject AND
				IdAssociate = @IdAssociate AND
				IdGeneration = @IdGeneration
		END
	END


	UPDATE PROJECT_CORE_TEAMS
	SET	IdFunction = @IdFunction,
		IsActive = @IsActive,
		LastUpdate = GETDATE()	
	WHERE  	IdProject = @IdProject AND 
		IdAssociate = @IdAssociate

	SET @RowCount = @@ROWCOUNT
	RETURN @RowCount
GO



