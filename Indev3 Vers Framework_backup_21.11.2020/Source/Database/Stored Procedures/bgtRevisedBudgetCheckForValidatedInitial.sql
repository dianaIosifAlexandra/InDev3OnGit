--Drops the Procedure bgtGetRevisedBudgetHours if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtRevisedBudgetCheckForValidatedInitial]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtRevisedBudgetCheckForValidatedInitial
GO

CREATE  PROCEDURE bgtRevisedBudgetCheckForValidatedInitial
	@IdProject		INT		--The Id of associate
AS
BEGIN
	IF EXISTS 
	(
		SELECT 	*
		FROM 	BUDGET_INITIAL
		WHERE 	IsValidated = 1
		AND 	IdProject = @IdProject
	)
		RETURN 1
	ELSE
		RETURN 0
END
GO

