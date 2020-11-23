--Drops the Procedure bgtGetCompletionScalarValidState if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetCompletionScalarValidState]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetCompletionScalarValidState
GO



-- bgtGetCompletionScalarValidState 7,'C'

CREATE        PROCEDURE bgtGetCompletionScalarValidState
	@IdProject 		AS INT,
	@BudVersion		AS CHAR(1)		
AS
	
	IF (@IdProject < 0 )
	BEGIN 
		RAISERROR('No project has been selected',16,1)		
		RETURN -1
	END 
	IF (@BudVersion IS NULL )
	BEGIN 
		RAISERROR('No budget version has been selected',16,1)		
		RETURN -2
	END 

	DECLARE @IdGeneration INT
	SELECT  @IdGeneration = dbo.fnGetToCompletionBudgetGeneration(@IdProject,@BudVersion)

	
	SELECT 	
		ISNULL(IsValidated,0) AS 'IsValidated'

	FROM BUDGET_TOCOMPLETION 
	WHERE IdProject = @IdProject AND IdGeneration = @IdGeneration 



GO


