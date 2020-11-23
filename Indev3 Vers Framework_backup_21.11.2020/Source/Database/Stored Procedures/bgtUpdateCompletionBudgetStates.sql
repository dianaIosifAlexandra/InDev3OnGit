--Drops the Procedure bgtUpdateCompletionBudgetStates if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateCompletionBudgetStates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateCompletionBudgetStates
GO



-- bgtUpdateCompletionBudgetStates 14,'N',4,'O'

CREATE        PROCEDURE bgtUpdateCompletionBudgetStates
	@IdProject 		AS INT,
	@BudVersion		AS CHAR(1),
	@IdAssociate		AS INT,
	@State			AS CHAR(1)
AS
	
	IF (@IdProject < 0 )
	BEGIN 
		RAISERROR('No project has been selected',16,1)		
		RETURN -1
	END 
	IF (@IdAssociate < 0 )
	BEGIN 
		RAISERROR('No associate has been selected',16,1)		
		RETURN -2
	END 
	IF (@BudVersion IS NULL )
	BEGIN 
		RAISERROR('No budget version has been selected',16,1)		
		RETURN -3
	END 

DECLARE @IdGeneration INT
	SELECT  @IdGeneration = dbo.fnGetToCompletionBudgetGeneration(@IdProject,@BudVersion)

	IF(@IdGeneration is null)
	BEGIN
		RAISERROR('There is no reforecast for this version',16,1)		
		RETURN -4
	END

IF EXISTS (
		SELECT * FROM BUDGET_TOCOMPLETION_STATES WHERE [IdProject]=@IdProject AND
			 [IdGeneration]=@IdGeneration AND 
			[IdAssociate]=@IdAssociate
	  )
	BEGIN
		UPDATE [BUDGET_TOCOMPLETION_STATES]
		SET 
			[State]=@State, 
			[StateDate]=GETDATE()
		WHERE 
			[IdProject]=@IdProject AND
			[IdGeneration]=@IdGeneration AND  
			[IdAssociate]=@IdAssociate
	END
	ELSE
	BEGIN
		INSERT INTO [BUDGET_TOCOMPLETION_STATES]
			(IdProject, IdGeneration, IdAssociate, State, StateDate)
		VALUES 
			(@IdProject, @IdGeneration, @IdAssociate, @State, GETDATE())
	END



GO






