--Drops the Procedure bgtToCompletionBudgetCreateNewFromCurrentAll if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtToCompletionBudgetCreateNewFromCurrentAll]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtToCompletionBudgetCreateNewFromCurrentAll
GO

-- exec bgtToCompletionBudgetCreateNewFromCurrentAll 25,2

CREATE  PROCEDURE bgtToCompletionBudgetCreateNewFromCurrentAll
	@IdProject		INT,
	@NewGeneration		INT
AS

--create the new version information in the master table
DECLARE @YearMonthActualDataCurrent INT,
		@retVal						INT

SELECT 	@YearMonthActualDataCurrent = YearMonthActualData
FROM 	BUDGET_TOCOMPLETION
WHERE	IdProject = @IdProject AND
		IdGeneration = @NewGeneration - 1

INSERT INTO BUDGET_TOCOMPLETION
	(IdProject,  IdGeneration,  IsValidated, ValidationDate, YearMonthActualData)
VALUES	(@IdProject, @NewGeneration, 0,		 NULL, 		 @YearMonthActualDataCurrent)
	

DECLARE AssociatesCursor CURSOR FAST_FORWARD FOR
SELECT 	IdAssociate
FROM	PROJECT_CORE_TEAMS
WHERE IdProject = @IdProject and 
	  IsActive = 1

open AssociatesCursor
declare @IdAsociate int

FETCH NEXT FROM AssociatesCursor INTO @IdAsociate
WHILE @@FETCH_STATUS = 0
BEGIN
	
	EXEC @retVal = bgtToCompletionBudgetCreateNewFromCurrent @IdProject, @NewGeneration, @IdAsociate
	IF (@@ERROR <> 0 OR @retVal < 0)
	BEGIN
		CLOSE AssociatesCursor
		DEALLOCATE AssociatesCursor
		RAISERROR ('There was error creating the budget for one active associate.', 16, 1)
		RETURN -1
	END		

	FETCH NEXT FROM AssociatesCursor INTO @IdAsociate
END

CLOSE AssociatesCursor
DEALLOCATE AssociatesCursor


GO

