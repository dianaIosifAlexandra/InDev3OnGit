--Drops the Procedure bgtGetRevisedBudgetStateForEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetRevisedBudgetStateForEvidence]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetRevisedBudgetStateForEvidence
GO



-- bgtGetRevisedBudgetStateForEvidence 7,'P',4

CREATE        PROCEDURE bgtGetRevisedBudgetStateForEvidence
	@IdProject 		AS INT,
	@BudVersion		AS CHAR(1), 
	@IdAssociate		AS INT 			
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

	IF(@IdAssociate<0)
	BEGIN 
		RAISERROR('No associate has been selected',16,1)		
		RETURN -3
	END 

	DECLARE @IdGeneration INT
	SELECT  @IdGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,@BudVersion)

	
	SELECT 	
		ISNULL(State,'N') AS 'StateCode'

	FROM BUDGET_REVISED_STATES 
 	WHERE IdProject = @IdProject AND IdGeneration = @IdGeneration AND IdAssociate = @IdAssociate 




GO






