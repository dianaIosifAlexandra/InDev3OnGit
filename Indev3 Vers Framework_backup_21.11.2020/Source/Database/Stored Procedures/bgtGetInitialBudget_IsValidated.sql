--Drops the Procedure bgtGetInitialBudget_IsValidated if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetInitialBudget_IsValidated]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetInitialBudget_IsValidated
GO


CREATE        PROCEDURE bgtGetInitialBudget_IsValidated
	@IdProject 		AS INT
AS
	
	IF (@IdProject < 0 )
	BEGIN 
		RAISERROR('No project has been selected',16,1)		
		RETURN -1
	END 
	

	
		SELECT IsValidated FROM BUDGET_INITIAL
			WHERE IdProject = @IdProject


		





GO



