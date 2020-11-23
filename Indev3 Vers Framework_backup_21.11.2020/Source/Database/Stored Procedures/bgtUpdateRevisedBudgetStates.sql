--Drops the Procedure bgtUpdateRevisedBudgetStates if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateRevisedBudgetStates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateRevisedBudgetStates
GO

-- bgtUpdateRevisedBudgetStates 14,'N',4,'O'
CREATE PROCEDURE bgtUpdateRevisedBudgetStates
	@IdProject 			INT,
	@BudVersion			CHAR(1),
	@IdAssociate		INT,
	@State				CHAR(1)
AS
BEGIN

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
	SELECT  @IdGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,@BudVersion)

	IF(@IdGeneration is null)
	BEGIN
		RAISERROR('There is no revised budget for this version',16,1)		
		RETURN -4
	END

	IF EXISTS (	SELECT * 
				FROM BUDGET_REVISED_STATES 
				WHERE IdProject = @IdProject AND
			 		  IdGeneration=@IdGeneration AND 
					  IdAssociate=@IdAssociate)
	BEGIN
		UPDATE BUDGET_REVISED_STATES
		SET State=@State, 
			StateDate=GETDATE()
		WHERE 
			IdProject=@IdProject AND
			IdGeneration=@IdGeneration AND  
			IdAssociate=@IdAssociate
	END
	ELSE
	BEGIN
		INSERT INTO BUDGET_REVISED_STATES
			(IdProject, IdGeneration, IdAssociate, State, StateDate)
		VALUES 
			(@IdProject, @IdGeneration, @IdAssociate, @State, GETDATE())
	END
END

GO






