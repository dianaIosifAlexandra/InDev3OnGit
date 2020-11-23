--Drops the Procedure bgtGetCopyTeamTargetProjectsForPM if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetCopyTeamTargetProjectsForPM]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetCopyTeamTargetProjectsForPM
GO

CREATE  PROCEDURE bgtGetCopyTeamTargetProjectsForPM
	@IdProject		INT,
	@IdAssociate		INT
AS

DECLARE @IdFunction INT --Project Manager
SET @IdFunction = 1

SELECT
	P.Id		AS 'IdProject',
	P.Code		AS 'ProjectCode',
	P.Name		AS 'ProjectName',
	T.TeamMembers 	AS 'TeamMembers'
FROM PROJECTS P
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = P.Id
INNER JOIN (SELECT IdProject, COUNT(IdAssociate) AS 'TeamMembers' FROM PROJECT_CORE_TEAMS GROUP BY IdProject) T
	ON T.IdProject = P.Id
LEFT JOIN BUDGET_INITIAL_DETAIL BID
	ON BID.IdProject = P.Id
LEFT JOIN BUDGET_INITIAL_DETAIL_COSTS BIDC
	ON BIDC.IdProject = P.Id
LEFT JOIN BUDGET_INITIAL_STATES BIS
	ON BIS.IdProject = P.Id
LEFT JOIN BUDGET_REVISED_DETAIL BRD
	ON BRD.IdProject = P.Id
LEFT JOIN BUDGET_REVISED_DETAIL_COSTS BRDC
	ON BRDC.IdProject = P.Id
LEFT JOIN BUDGET_REVISED_STATES BRS
	ON BRS.IdProject = P.Id
LEFT JOIN BUDGET_TOCOMPLETION_DETAIL BCD
	ON BCD.IdProject = P.Id
LEFT JOIN BUDGET_TOCOMPLETION_DETAIL_COSTS BCDC
	ON BCDC.IdProject = P.Id
LEFT JOIN BUDGET_TOCOMPLETION_STATES BCS
	ON BCS.IdProject = P.Id
LEFT JOIN BUDGET_TOCOMPLETION_PROGRESS BCP
	ON BCP.IdProject = P.Id
WHERE 	P.Id <> @IdProject AND
	PCT.IdAssociate = @IdAssociate AND
	PCT.IsActive = 1 AND
	PCT.IdFunction = @IdFunction AND
	(BID.IdProject IS NULL AND BIDC.IdProject IS NULL AND BIS.IdProject IS NULL) AND
	(BRD.IdProject IS NULL AND BRDC.IdProject IS NULL AND BRS.IdProject IS NULL) AND
	(BCD.IdProject IS NULL AND BCDC.IdProject IS NULL AND BCS.IdProject IS NULL AND BCP.IdProject IS NULL)

GO

