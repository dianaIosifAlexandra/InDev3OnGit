IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_COUNTRIES_WP_FROM]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_COUNTRIES_WP_FROM
GO

CREATE VIEW OLAP_COUNTRIES_WP_FROM
AS

SELECT DISTINCT
       C.Name as CountryName,
       C.Id as CountryId,
       C.Rank as CountryRank,
       BID.IdProject,
       BID.IdPhase,
       BID.IdWorkPackage
FROM BUDGET_INITIAL_DETAIL BID
INNER JOIN COST_CENTERS CC
	on BID.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	on CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	on IL.IdCountry = C.Id
UNION -- we do not put union all as we want to elimnate dupplicates
SELECT DISTINCT
       C.Name as CountryName,
       C.Id as CountryId,
       C.Rank as CountryRank,
       BRD.IdProject,
       BRD.IdPhase,
       BRD.IdWorkPackage
FROM BUDGET_REVISED_DETAIL BRD
INNER JOIN COST_CENTERS CC
	on BRD.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	on CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	on IL.IdCountry = C.Id
WHERE IdGeneration = dbo.fnGetRevisedBudgetGeneration(BRD.IdProject, 'C')
UNION -- we do not put union all as we want to elimnate dupplicates
SELECT DISTINCT
       C.Name as CountryName,
       C.Id as CountryId,
       C.Rank as CountryRank,
       BTD.IdProject,
       BTD.IdPhase,
       BTD.IdWorkPackage
FROM BUDGET_TOCOMPLETION_DETAIL BTD
INNER JOIN COST_CENTERS CC
	on BTD.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	on CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	on IL.IdCountry = C.Id
WHERE IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BTD.IdProject, 'C')
UNION -- we do not put union all as we want to elimnate dupplicates
SELECT DISTINCT
       C.Name as CountryName,
       C.Id as CountryId,
       C.Rank as CountryRank,
       ATD.IdProject,
       ATD.IdPhase,
       ATD.IdWorkPackage
FROM ACTUAL_DATA_DETAILS_HOURS ATD
INNER JOIN COST_CENTERS CC
	on ATD.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	on CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	on IL.IdCountry = C.Id
UNION -- we do not put union all as we want to elimnate dupplicates
SELECT DISTINCT
       C.Name as CountryName,
       C.Id as CountryId,
       C.Rank as CountryRank,
       ATD.IdProject,
       ATD.IdPhase,
       ATD.IdWorkPackage
FROM ACTUAL_DATA_DETAILS_SALES ATD
INNER JOIN COST_CENTERS CC
	on ATD.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	on CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	on IL.IdCountry = C.Id
UNION -- we do not put union all as we want to elimnate dupplicates
SELECT DISTINCT
       C.Name as CountryName,
       C.Id as CountryId,
       C.Rank as CountryRank,
       ATD.IdProject,
       ATD.IdPhase,
       ATD.IdWorkPackage
FROM ACTUAL_DATA_DETAILS_COSTS ATD
INNER JOIN COST_CENTERS CC
	on ATD.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	on CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	on IL.IdCountry = C.Id
UNION -- we do not put union all as we want to elimnate dupplicates
SELECT DISTINCT
       C.Name as CountryName,
       C.Id as CountryId,
       C.Rank as CountryRank,
       ABD.IdProject,
       ABD.IdPhase,
       ABD.IdWorkPackage
FROM ANNUAL_BUDGET_DATA_DETAILS_HOURS ABD
INNER JOIN COST_CENTERS CC
	on ABD.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	on CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	on IL.IdCountry = C.Id
UNION -- we do not put union all as we want to elimnate dupplicates
SELECT DISTINCT
       C.Name as CountryName,
       C.Id as CountryId,
       C.Rank as CountryRank,
       ABD.IdProject,
       ABD.IdPhase,
       ABD.IdWorkPackage
FROM ANNUAL_BUDGET_DATA_DETAILS_SALES ABD
INNER JOIN COST_CENTERS CC
	on ABD.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	on CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	on IL.IdCountry = C.Id
UNION -- we do not put union all as we want to elimnate dupplicates
SELECT DISTINCT
       C.Name as CountryName,
       C.Id as CountryId,
       C.Rank as CountryRank,
       ABD.IdProject,
       ABD.IdPhase,
       ABD.IdWorkPackage
FROM ANNUAL_BUDGET_DATA_DETAILS_COSTS ABD
INNER JOIN COST_CENTERS CC
	on ABD.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	on CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	on IL.IdCountry = C.Id


GO
