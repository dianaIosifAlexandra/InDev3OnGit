IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_PROG_CC]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_PROG_CC
GO

CREATE VIEW OLAP_DIMENSION_PROG_CC
AS


SELECT
	P.Code + '-' + P.Name AS PhaseName,
	P.Id as PhaseIdKey,
	CASE WHEN P.Code = '0' then '8'
		 WHEN P.Code = 'NA' then '9'
		 else P.Code end as PhaseRank,
	WP.Code + '-' + WP.Name + ' (' + PRJ.Name + '-' + PRJ.Code + ')'  AS WorkPackageName,
	CAST(OCWF.IdWorkPackage + OCWF.IdPhase * 10000 + OCWF.IdProject * 1000000 AS BIGINT) AS WPFullKey,
	D.Name + '-' + IL.Code + '-' + CC.Code as CostCenterCode,
	CC.Id as CostCenterIdKey,
	WP.Rank as WorkPackageRank
FROM OLAP_CC_WP_FROM OCWF
INNER JOIN PROJECTS PRJ
	ON OCWF.IdProject = PRJ.Id
INNER JOIN PROJECT_PHASES P
	ON OCWF.IdPhase = P.Id
INNER JOIN WORK_PACKAGES WP
	ON OCWF.IdProject = WP.IdProject AND
	   OCWF.IdPhase = WP.IdPhase AND
	   OCWF.IdWorkPackage = WP.Id
INNER JOIN COST_CENTERS CC
	ON OCWF.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	ON CC.IdInergyLocation = IL.Id
INNER JOIN DEPARTMENTS D
	ON CC.IdDepartment = D.Id
UNION ALL -- we put an artificial no cost center under all wps that has a nonnull percentage of progress
SELECT DISTINCT TOP 100 PERCENT 
	P.Code + '-' + P.Name AS PhaseName,
	P.Id as PhaseIdKey,
	CASE WHEN P.Code = '0' then '8'
		 WHEN P.Code = 'NA' then '9'
		 else P.Code end as PhaseRank,
	WP.Code + '-' + WP.Name + ' (' + PRJ.Name + '-' + PRJ.Code + ')'  AS WorkPackageName,
	CAST(BTP.IdWorkPackage + BTP.IdPhase * 10000 + BTP.IdProject * 1000000 AS BIGINT) AS WPFullKey,
	'' as CostCenterCode,
	CAST(-1 AS INT) as CostCenterIdKey,
	WP.Rank as WorkPackageRank
FROM BUDGET_TOCOMPLETION_PROGRESS BTP
INNER JOIN PROJECTS PRJ
	ON BTP.IdProject = PRJ.Id
INNER JOIN PROJECT_PHASES P
	ON BTP.IdPhase = P.Id
INNER JOIN WORK_PACKAGES WP
	ON BTP.IdProject = WP.IdProject AND
	   BTP.IdPhase = WP.IdPhase AND
	   BTP.IdWorkPackage = WP.Id
WHERE dbo.fnGetToCompletionBudgetGeneration(BTP.IdProject, 'C') = BTP.IdGeneration and 
      [Percent] is not null

GO

	