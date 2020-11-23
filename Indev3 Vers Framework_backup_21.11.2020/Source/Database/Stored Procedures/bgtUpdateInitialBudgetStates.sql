--Drops the Procedure bgtUpdateInitialBudgetStates if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateInitialBudgetStates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateInitialBudgetStates
GO


CREATE    PROCEDURE bgtUpdateInitialBudgetStates
	@IdProject 	INT, 	--The Id of the Project
	@IdAssociate 	INT,     -- The Id of Associate
	@State 		CHAR(1)
AS

	IF (@IdProject < 0 )
	BEGIN 
		RAISERROR('No project has been selected',16,1)		
		RETURN -1
	END 

	IF (@IdAssociate < 0 )
	BEGIN 
		RAISERROR('No associate has been selected',16,1)		
		RETURN -1
	END 
	

Declare @ROWCOUNT INT
	IF EXISTS(SELECT * FROM Budget_Initial_States WHERE IdProject = @IdProject
		AND IdAssociate = @IdAssociate)
	BEGIN
		UPDATE
			Budget_Initial_States
		SET 		
			StateDate = GETDATE(),
			State = @State
		
		WHERE 	IdProject = @IdProject
			AND IdAssociate = @IdAssociate
	
		SET @Rowcount = @@ROWCOUNT
		RETURN @Rowcount
	END
	ELSE
	BEGIN
		INSERT INTO [BUDGET_INITIAL_STATES]
			([IdProject], [IdAssociate], [StateDate], [State])
		VALUES(@IdProject, @IdAssociate, GETDATE(), @State)
		RETURN 1
	END
	

	



GO




