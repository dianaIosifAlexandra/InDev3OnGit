--Drops the Procedure bgtGetInitialBudgetStateForEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetInitialBudgetStateForEvidence]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetInitialBudgetStateForEvidence
GO



CREATE      PROCEDURE bgtGetInitialBudgetStateForEvidence

	@IdProject 		AS INT,
	@IdAssociate		AS INT
AS
	
	IF (@IdProject < 0 )
	BEGIN 
		RAISERROR('No project has been selected',16,1)		
		RETURN -1
	END 

	IF(@IdAssociate<0)
	BEGIN 
		RAISERROR('No associate has been selected',16,1)		
		RETURN -2
	END 
	--Get the state for Budget Initial Evidence


-- 	--the Role of BA or TA has special access rights - they may see all the projects
	IF NOT EXISTS 
	(
		SELECT 	ISNULL(BIS.State,'N') AS 'StateCode',
			BS.Description as 'Description'			
		FROM Project_Core_Teams CTM
			LEFT JOIN  Budget_Initial_States BIS
				ON 	CTM.IdProject = BIS.IdProject AND
					CTM.IdAssociate = BIS.IdAssociate			
			LEFT JOIN BUDGET_STATES BS 
				ON BIS.STATE = BS.StateCode	
		WHERE CTM.IdProject = @IdProject AND CTM.IdAssociate = @IdAssociate
	)
	BEGIN

		-- THIS IS FOR EXCEPTION CASE WHEN THERE ARE DATA IN BUDGET_INITIAL_DETAIL BUT
		--FEATURE FOR INSERTING BUDGET_STATE WAS NOT IMPLEMENTED
		IF EXISTS(SELECT * FROM BUDGET_INITIAL_DETAIL WHERE IdProject = @IdProject 
				AND IdAssociate = @IdAssociate)
		BEGIN
			SELECT TOP 1 'O' as 'StateCode', 'Open' as 'Description' FROM BUDGET_STATES
		END
		ELSE
		BEGIN
			SELECT TOP 1 'N' AS 'StateCode', 'None' as 'Description' FROM BUDGET_STATES
		END

	END
	ELSE
	BEGIN
		SELECT 	ISNULL(BIS.State,'N') AS 'StateCode',
			BS.Description as 'Description'			
		FROM Project_Core_Teams CTM
			LEFT JOIN  Budget_Initial_States BIS
				ON 	CTM.IdProject = BIS.IdProject AND
					CTM.IdAssociate = BIS.IdAssociate			
			LEFT JOIN BUDGET_STATES BS 
				ON BIS.STATE = BS.StateCode	
		WHERE CTM.IdProject = @IdProject AND CTM.IdAssociate = @IdAssociate
	END






GO



