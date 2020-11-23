--Drops the Procedure bgtToCompletionBudgetCreateNewVersion if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtToCompletionBudgetCreateNewVersion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtToCompletionBudgetCreateNewVersion
GO

CREATE PROCEDURE bgtToCompletionBudgetCreateNewVersion
	@IdProject int
AS
BEGIN
	declare @CurrentGeneration 	int,
			@NewGeneration 		int

	SET @CurrentGeneration = dbo.fnGetToCompletionBudgetGeneration(@IdProject,'C')
	IF (@CurrentGeneration IS NULL)
	BEGIN
		RAISERROR('No released generation found for To Completion budget', 16, 1)
		RETURN -1
	END
	SET @NewGeneration = @CurrentGeneration + 1

	EXEC bgtToCompletionBudgetCreateNewFromCurrentAll @IdProject, @NewGeneration
	IF @@ERROR <> 0 
	BEGIN
		raiserror ('There was error creating the new generation.',16,1)
		RETURN -2
	END		
END
GO
