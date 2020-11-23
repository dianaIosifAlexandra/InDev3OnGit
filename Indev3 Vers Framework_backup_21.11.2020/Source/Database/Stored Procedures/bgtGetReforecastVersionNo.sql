--Drops the Procedure bgtGetReforecastVersionNo if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetReforecastVersionNo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetReforecastVersionNo
GO
CREATE  PROCEDURE bgtGetReforecastVersionNo
	@IdProject INT,
	@Version CHAR(1)
AS
	DECLARE @BudgetVersion INT
	--Specifies whether the version returned is the actual requested version (it happens when the new version 
	--is requested and it does not exist, the released one will be returned and @ActualVersionNumber will be 0)
	DECLARE @ActualVersionNumber BIT
	SET @ActualVersionNumber = 1

	IF (@Version = 'N')
	BEGIN
		SELECT @BudgetVersion = MAX(IdGeneration) 
		FROM BUDGET_TOCOMPLETION TABLOCKX
		WHERE 	IdProject = @IdProject AND
			IsValidated = 0
		--If no new version of the budget exists, the released version will be selected so get the
		--released version number
		IF (@BudgetVersion IS NULL)
		BEGIN
			SELECT @BudgetVersion = MAX(IdGeneration) 
			FROM BUDGET_TOCOMPLETION TABLOCKX
			WHERE 	IdProject = @IdProject AND
				IsValidated = 1
			SET @ActualVersionNumber = 0
		END
	END
	IF (@Version = 'C' OR @Version = 'P')
	BEGIN
		SELECT @BudgetVersion = MAX(IdGeneration) 
		FROM BUDGET_TOCOMPLETION TABLOCKX
		WHERE 	IdProject = @IdProject AND
			IsValidated = 1
		IF (@Version = 'P')
		BEGIN
			IF (@BudgetVersion IS NOT NULL)
			BEGIN
				SET @BudgetVersion = @BudgetVersion - 1
				IF (@BudgetVersion <= 0)
				BEGIN
					SET @BudgetVersion = NULL
				END
			END
		END
	END
	
	
	SELECT 	@BudgetVersion AS 'BudgetVersion',
		@ActualVersionNumber AS 'IsVersionActual'
GO

