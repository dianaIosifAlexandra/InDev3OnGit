IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnGetToCompletionBudgetGeneration]'))
	DROP FUNCTION fnGetToCompletionBudgetGeneration
GO

CREATE FUNCTION fnGetToCompletionBudgetGeneration
	(@IdProject	INT,
	@Type		CHAR(1))	--The YearMonth to validate
RETURNS INT
AS
BEGIN
	DECLARE @IdGeneration	INT
	--InProgress version of budget
	If (@Type = 'N')
	BEGIN
		SELECT @IdGeneration = MAX(IdGeneration)
		FROM BUDGET_TOCOMPLETION
		WHERE 	IdProject = @IdProject
		AND 	IsValidated=0
	END
	--Released or previous budget
	IF (@Type = 'C' OR @Type = 'P')
	BEGIN
		--Get Released budget generation
		SELECT @IdGeneration = MAX(IdGeneration)
		FROM BUDGET_TOCOMPLETION
		WHERE 	IdProject = @IdProject
		AND 	IsValidated = 1
		--If previous budget is needed and if the Released generation exists
		IF (@Type = 'P' AND @IdGeneration IS NOT NULL)
		BEGIN
			--If Released generation is strictly positive, previous generation is the Released one minus one
			IF (@IdGeneration > 1)
			BEGIN
				SET @IdGeneration = @IdGeneration - 1
			END
			--Else, no previous generation exists
			ELSE
			BEGIN
				SET @IdGeneration = NULL
			END
		END
	END
	RETURN @IdGeneration
END
GO

