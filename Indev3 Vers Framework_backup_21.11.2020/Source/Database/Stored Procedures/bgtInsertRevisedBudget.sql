--Drops the Procedure bgtInsertRevisedBudget if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtInsertRevisedBudget]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtInsertRevisedBudget
GO

CREATE  PROCEDURE bgtInsertRevisedBudget
	@IdProject	INT,		--The Id of the selected Project
	@IdAssociate	INT		--The Id of the associate
	
AS
BEGIN
	DECLARE @CurrentGeneration INT
	DECLARE @NewGeneration INT
	--Find Released and InProgress generations of revised budget for the current project
	SELECT @CurrentGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,'C')
	SELECT @NewGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,'N')

	IF (@NewGeneration is null)
	BEGIN
		set @NewGeneration = @CurrentGeneration + 1

		DECLARE @RetVal INT
		
		EXEC @RetVal = bgtRevisedBudgetCreateNewFromCurrentAll @IdProject = @IdProject, @NewGeneration = @NewGeneration
		IF (@@ERROR <> 0 OR @RetVal < 0)
			RETURN -1
	END

END
GO

