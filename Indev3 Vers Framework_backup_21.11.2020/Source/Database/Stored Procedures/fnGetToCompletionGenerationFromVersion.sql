IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnGetToCompletionGenerationFromVersion]'))
	DROP FUNCTION fnGetToCompletionGenerationFromVersion
GO

CREATE  FUNCTION fnGetToCompletionGenerationFromVersion
(	
	@IdProject		INT,
	@Version		CHAR(1), -- Version of budget
	@IdAssociate		INT
)
RETURNS @GenerationTable TABLE
(	
	ToCompletionPreviousGenerationNo INT NULL,
	ToCompletionCurrentGenerationNo INT NULL,
	ToCompletionNewGenerationNo INT NOT NULL,
	ErrorState			INT NOT NULL,
	ErrorMessage			varchar(255)
) 
AS
BEGIN
-- VERSION MUST BE ONE OF THE FOLLOWING: N, C, P
	IF(ISNULL(CHARINDEX(@Version,'NCP'),0)=0)
	BEGIN
		INSERT INTO @GenerationTable(ToCompletionPreviousGenerationNo,	ToCompletionCurrentGenerationNo,
						ToCompletionNewGenerationNo, ErrorState,ErrorMessage )
		VALUES (-1, -1, -1, -1,'Parameter @Version must be: N, C or P ') 		
		RETURN
	END

	DECLARE @ToCompletionPreviousGenerationNo INT
	DECLARE @ToCompletionCurrentGenerationNo INT
	DECLARE @ToCompletionNewGenerationNo INT

	IF (@Version = 'N')
	BEGIN
		SET @ToCompletionNewGenerationNo = dbo.fnGetToCompletionBudgetGeneration(@IdProject, @Version)
		SET @ToCompletionCurrentGenerationNo = dbo.fnGetToCompletionBudgetGeneration(@IdProject, 'C')
		SET @ToCompletionPreviousGenerationNo = dbo.fnGetToCompletionBudgetGeneration(@IdProject, 'P')
	
		IF (@ToCompletionCurrentGenerationNo IS NULL AND @IdProject IS NOT NULL)
		BEGIN
			INSERT INTO @GenerationTable(ToCompletionPreviousGenerationNo,	ToCompletionCurrentGenerationNo,
						ToCompletionNewGenerationNo, ErrorState,ErrorMessage )
			VALUES (-1, -1, -1, -1,'Could not find any instance of To Completion Budget') 		
			RETURN
			
		END
	
		IF (@ToCompletionNewGenerationNo IS NULL)
		BEGIN
			SET @ToCompletionNewGenerationNo = @ToCompletionCurrentGenerationNo
		END
	
		DECLARE @MaxGeneration INT
		SELECT 	@MaxGeneration = MAX(IdGeneration)
		FROM	BUDGET_TOCOMPLETION_DETAIL BTD
		WHERE 	BTD.IdProject = @IdProject AND
			BTD.IdAssociate = @IdAssociate
		
		IF (@ToCompletionNewGenerationNo <> @MaxGeneration)
		BEGIN
			SET @ToCompletionNewGenerationNo = @ToCompletionCurrentGenerationNo
		END
	END
	
	IF (@Version = 'C')
	BEGIN
		SET @ToCompletionNewGenerationNo = dbo.fnGetToCompletionBudgetGeneration(@IdProject, @Version)
	
		IF (@ToCompletionNewGenerationNo IS NULL AND @IdProject IS NOT NULL)
		BEGIN
			INSERT INTO @GenerationTable(ToCompletionPreviousGenerationNo,	ToCompletionCurrentGenerationNo,
						ToCompletionNewGenerationNo, ErrorState,ErrorMessage )
			VALUES (-1, -1, -1, -1,'Could not find Released version of To Completion Budget')
			RETURN
		END
		
		SET @ToCompletionCurrentGenerationNo = dbo.fnGetToCompletionBudgetGeneration(@IdProject, 'P')
		SET @ToCompletionPreviousGenerationNo = CASE WHEN ISNULL(@ToCompletionCurrentGenerationNo, 0) > 1 THEN @ToCompletionCurrentGenerationNo - 1 ELSE NULL END
	END
	
	IF (@Version = 'P')
	BEGIN
		SET @ToCompletionNewGenerationNo = dbo.fnGetToCompletionBudgetGeneration(@IdProject, @Version)
	
		IF (@ToCompletionNewGenerationNo IS NULL AND @IdProject IS NOT NULL)
		BEGIN
			INSERT INTO @GenerationTable(ToCompletionPreviousGenerationNo,	ToCompletionCurrentGenerationNo,
						ToCompletionNewGenerationNo, ErrorState,ErrorMessage )
			VALUES (-1, -1, -1, -1,'Could not find previous version of To Completion Budget')			
			RETURN
		END
		
		SET @ToCompletionCurrentGenerationNo = CASE WHEN ISNULL(@ToCompletionNewGenerationNo, 0) > 1 THEN @ToCompletionNewGenerationNo - 1 ELSE NULL END
		SET @ToCompletionPreviousGenerationNo = CASE WHEN ISNULL(@ToCompletionCurrentGenerationNo, 0) > 1 THEN @ToCompletionCurrentGenerationNo - 1 ELSE NULL END
	END

	INSERT INTO @GenerationTable   (
					ToCompletionPreviousGenerationNo,	
					ToCompletionCurrentGenerationNo,
					ToCompletionNewGenerationNo,
					ErrorState
					)
	VALUES                          (
					 @ToCompletionPreviousGenerationNo,
					 @ToCompletionCurrentGenerationNo,
					 @ToCompletionNewGenerationNo,
					 1
					)

	RETURN

END

GO


