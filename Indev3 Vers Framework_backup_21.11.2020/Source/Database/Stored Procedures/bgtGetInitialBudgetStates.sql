--Drops the Procedure bgtGetInitialBudgetStates if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetInitialBudgetStates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetInitialBudgetStates
GO



-- bgtGetInitialBudgetStates 1

CREATE        PROCEDURE bgtGetInitialBudgetStates
	@IdProject 		AS INT
AS
	
	IF (@IdProject < 0 )
	BEGIN 
		RAISERROR('No project has been selected',16,1)		
		RETURN -1
	END 
	--Get's the table for Initial FollowUp Budget (from GUI). 

	DECLARE @IsValidated BIT
	
	SELECT 	@IsValidated = IsValidated
	FROM	BUDGET_INITIAL
	WHERE 	IdProject = @IdProject

	IF (@IsValidated = 0)
	BEGIN
		SELECT 	
			BIS.StateDate	AS	'StateDate',		
			CTM.IdAssociate AS	'IdAssociate',
			Associates.Name as	'Associate',
			PF.Name			AS	'Project Function',
			ISNULL(BS.Description,'None') AS 'State',
			ISNULL(BS.StateCode,'N') AS 'StateCode',
			CTM.IDProject,
			case when BIS.State is null then 0 else 1 end	AS 'HasData'
		FROM PROJECT_CORE_TEAMS AS CTM 							
		LEFT JOIN Budget_Initial_States BIS
			ON CTM.IdProject = BIS.IdProject AND
			CTM.IdAssociate = BIS.IdAssociate
		LEFT JOIN BUDGET_STATES BS 
			ON BIS.STATE = BS.StateCode				
		LEFT JOIN Associates 
			ON CTM.IdAssociate = Associates.ID
		LEFT JOIN PROJECT_FUNCTIONS PF
			ON PF.ID = CTM.IDFunction
		WHERE 	CTM.IdProject = @IdProject AND
			ISNULL(CTM.IsActive,0) = 1
		ORDER BY PF.Rank
	END
	ELSE
	BEGIN
		SELECT
			BIS.StateDate	AS	'StateDate',		
			CTM.IdAssociate AS	'IdAssociate',
			Associates.Name as	'Associate',
			PF.Name			AS	'Project Function',
			ISNULL(BS.Description,'None') AS 'State',
			ISNULL(BS.StateCode,'N') AS 'StateCode',
			CTM.IDProject,
			case when BIS.State is null then 0 else 1 end	AS 'HasData'
		FROM PROJECT_CORE_TEAMS AS CTM 							
		LEFT JOIN BUDGET_INITIAL_STATES BIS
			ON CTM.IdProject = BIS.IdProject AND
			CTM.IdAssociate = BIS.IdAssociate
		LEFT JOIN BUDGET_STATES BS 
			ON BIS.STATE = BS.StateCode				
		LEFT JOIN ASSOCIATES
			ON CTM.IdAssociate = Associates.ID
		LEFT JOIN PROJECT_FUNCTIONS PF
			ON PF.ID = CTM.IDFunction
		WHERE CTM.IdProject = @IdProject AND
			  StateCode <> 'N' -- filter only team members that have data in the initial budget
		ORDER BY PF.Rank
	END
GO



