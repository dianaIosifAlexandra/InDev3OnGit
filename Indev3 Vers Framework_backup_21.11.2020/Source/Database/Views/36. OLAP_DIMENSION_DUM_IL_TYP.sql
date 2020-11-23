IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_DUM_IL_TYP]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_DUM_IL_TYP
GO

CREATE VIEW OLAP_DIMENSION_DUM_IL_TYP

AS

SELECT DISTINCT TOP 100 PERCENT
	IL.Name 			AS InergyLocationName,
	IL.Id	 			AS InergyLocationIdKey,
	IL.Rank		 		AS InergyLocationRank,
	PT.Type				AS ProjectTypeName,
	PT.Id				AS ProjectTypeIdKey,
	OPT.PhaseTypeName 		AS PhaseType,
	OPT.PhaseTypeId 		AS PhaseTypeIdKey,
	PRJ.Code + ' - ' + PRJ.Name 	AS ProjectName,
	PRJ.Id 				AS ProjectIdKey,
	PRJ.Code			AS ProjectCode,
	PT.Rank
FROM OLAP_CC_WP_FROM OCW
INNER JOIN PROJECTS PRJ
	ON OCW.IdProject = PRJ.Id
INNER JOIN OLAP_PHASE_TYPE OPT
	ON OCW.IdPhase = OPT.PhaseId
INNER JOIN PROJECT_TYPES PT
	ON PRJ.IdProjectType = PT.Id
INNER JOIN COST_CENTERS CC
	ON OCW.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL	
	ON CC.IdInergyLocation = IL.Id
ORDER BY IL.Id, PT.Rank, PhaseTypeIdKey, ProjectCode
GO

