--Drops the Procedure bgtRevisedBudgetCreateNewFromCurrentAll if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtRevisedBudgetCreateNewFromCurrentAll]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtRevisedBudgetCreateNewFromCurrentAll
GO

-- exec bgtRevisedBudgetCreateNewFromCurrentAll 25,2

CREATE  PROCEDURE bgtRevisedBudgetCreateNewFromCurrentAll
	@IdProject 			INT,
	@NewGeneration		INT
AS
BEGIN
	DECLARE @retVal 	INT

	--Creates a copy of the released version budget, increasing the IdGeneration (InProgress budget <- Released budget)
	INSERT INTO BUDGET_REVISED 
		(IdProject,  IdGeneration, 		IsValidated, 	ValidationDate)
	VALUES	(@IdProject, @NewGeneration, 		0, 		GETDATE())
	
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
		
		EXEC @retVal = bgtRevisedBudgetCreateNewFromCurrent @IdProject, @NewGeneration, @IdAsociate
	
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
	

END
GO

