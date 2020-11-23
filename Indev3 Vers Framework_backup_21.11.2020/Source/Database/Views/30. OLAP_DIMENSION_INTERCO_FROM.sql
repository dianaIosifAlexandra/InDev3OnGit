IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_INTERCO_FROM]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_INTERCO_FROM
GO

CREATE VIEW OLAP_DIMENSION_INTERCO_FROM
AS

SELECT TOP 100 PERCENT
       CWPF.CountryName,
       CWPF.CountryId as CountryFromIdKey,
       CWPF.CountryRank	AS CountryRank,
       P.Code + ' - ' + P.Name as ProjectName,
       P.Code as ProjectCode,
       CWPF.IdProject as ProjectIdKey,
       PT.PhaseTypeName as PhaseTypeName,
       PT.PhaseTypeId as PhaseTypeIdKey,
       WP.Code + ' - ' + WP.Name as WorkPackageName,
       -- CWPF.IdWorkPackage as WorkPackageIdKey,
       CAST(CWPF.IdWorkPackage + CWPF.IdPhase * 10000 + CWPF.IdProject * 1000000 AS BIGINT) AS WPFullKey,
	WP.Rank AS WorkPackageRank
FROM OLAP_COUNTRIES_WP_FROM CWPF
INNER JOIN OLAP_PHASE_TYPE PT
	on CWPF.IdPhase = PT.PhaseId
INNER JOIN PROJECTS P
	on CWPF.IdProject = P.Id
INNER JOIN WORK_PACKAGES WP
	on CWPF.IdProject = WP.IdProject and
	   CWPF.IdPhase = WP.IdPhase and
	   CWPF.IdWorkPackage = WP.Id
ORDER BY CountryName, PhaseCode, ProjectCode, WP.Rank


GO



