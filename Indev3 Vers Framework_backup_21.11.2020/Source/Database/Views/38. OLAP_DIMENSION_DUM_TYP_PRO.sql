IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_DUM_TYP_PRO]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_DUM_TYP_PRO
GO

CREATE VIEW OLAP_DIMENSION_DUM_TYP_PRO
AS

SELECT DISTINCT TOP 100 PERCENT
	PT.Type AS ProjectTypeName,
	PT.Id AS ProjectTypeIdKey,
	OPT.PhaseTypeName AS PhaseType,
	OPT.PhaseTypeId AS PhaseTypeIdKey,
	PRG.Code + ' - ' + PRG.Name as ProgramName,
	PRG.Id as ProgramIdKey,
	PT.Rank AS ProjectTypeRank,-- appear in the select list because when using DISTINCT with ORDER BY, all columns
	PRG.Rank AS ProgramRank -- in the ORDER BY must appear in the SELECT list
FROM OLAP_COUNTRIES_WP_FROM CWF
INNER JOIN PROJECTS PRJ
	ON CWF.IdProject = PRJ.Id
INNER JOIN PROJECT_TYPES PT
	ON PRJ.IdProjectType = PT.Id
INNER JOIN PROGRAMS PRG
	ON PRJ.IdProgram = PRG.Id
INNER JOIN OLAP_PHASE_TYPE OPT
	ON CWF.IdPhase = OPT.PhaseId
ORDER BY PT.Rank, PhaseTypeIdKey, PRG.Rank

GO

