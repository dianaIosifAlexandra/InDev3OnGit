IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_INTERCO_TO]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_INTERCO_TO
GO

CREATE VIEW OLAP_DIMENSION_INTERCO_TO
AS

SELECT TOP 100 PERCENT
	ISNULL(C.Name, 'Not Allocated') as CountryName,
	ISNULL(C.Rank, -1) as CountryRank,
	ISNULL(PIN.IdCountry,-1) as CountryToIdKey,
	P.Code + ' - ' + P.Name as ProjectName,
	P.Code as ProjectCode,
	WP.IdProject as ProjectIdKey,
	WP.Code + ' - ' + WP.Name as WorkPackageName,
	CAST(WP.Id + WP.IdPhase * 10000 + WP.IdProject * 1000000 AS BIGINT) AS WPFullKey,
	WP.Rank as WorkPackageRank
FROM WORK_PACKAGES WP
INNER JOIN PROJECTS P
	on WP.IdProject = P.Id
LEFT JOIN PROJECTS_INTERCO PIN
	on PIN.IdProject = WP.IdProject and
	   PIN.IdPhase = WP.IdPhase and
	   PIN.IdWorkPackage = WP.Id
LEFT JOIN COUNTRIES C
	on PIN.IdCountry = C.Id
ORDER BY CountryName, ProjectCode, WP.Rank

GO





