IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_CC_WP_FROM]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_CC_WP_FROM
GO

CREATE VIEW OLAP_CC_WP_FROM
AS

SELECT DISTINCT
       BID.IdProject,
       BID.IdPhase,
       BID.IdWorkPackage,
       BID.IdCostCenter
FROM BUDGET_INITIAL_DETAIL BID
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BID.YearMonth = op.YearMonthKey 
UNION -- we do not put union all as we want to eliminate dupplicates
SELECT DISTINCT
       BRD.IdProject,
       BRD.IdPhase,
       BRD.IdWorkPackage,
       BRD.IdCostCenter
FROM BUDGET_REVISED_DETAIL BRD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BRD.YearMonth = op.YearMonthKey
WHERE IdGeneration = dbo.fnGetRevisedBudgetGeneration(BRD.IdProject, 'C')
UNION -- we do not put union all as we want to eliminate dupplicates
SELECT DISTINCT
       BTD.IdProject,
       BTD.IdPhase,
       BTD.IdWorkPackage,
       BTD.IdCostCenter
FROM BUDGET_TOCOMPLETION_DETAIL BTD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BTD.YearMonth = op.YearMonthKey
WHERE IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BTD.IdProject, 'C')
UNION -- we do not put union all as we want to eliminate dupplicates
SELECT DISTINCT
       ATD.IdProject,
       ATD.IdPhase,
       ATD.IdWorkPackage,
       ATD.IdCostCenter
FROM ACTUAL_DATA_DETAILS_HOURS ATD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ATD.YearMonth = op.YearMonthKey
UNION -- we do not put union all as we want to eliminate dupplicates
SELECT DISTINCT
       ATD.IdProject,
       ATD.IdPhase,
       ATD.IdWorkPackage,
       ATD.IdCostCenter
FROM ACTUAL_DATA_DETAILS_SALES ATD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ATD.YearMonth = op.YearMonthKey
UNION -- we do not put union all as we want to eliminate dupplicates
SELECT DISTINCT
       ATD.IdProject,
       ATD.IdPhase,
       ATD.IdWorkPackage,
       ATD.IdCostCenter
FROM ACTUAL_DATA_DETAILS_COSTS ATD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ATD.YearMonth = op.YearMonthKey
UNION -- we do not put union all as we want to eliminate dupplicates
SELECT DISTINCT
       ABD.IdProject,
       ABD.IdPhase,
       ABD.IdWorkPackage,
       ABD.IdCostCenter
FROM ANNUAL_BUDGET_DATA_DETAILS_HOURS ABD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ABD.YearMonth = op.YearMonthKey
UNION -- we do not put union all as we want to eliminate dupplicates
SELECT DISTINCT
       ABD.IdProject,
       ABD.IdPhase,
       ABD.IdWorkPackage,
       ABD.IdCostCenter
FROM ANNUAL_BUDGET_DATA_DETAILS_SALES ABD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ABD.YearMonth = op.YearMonthKey
UNION -- we do not put union all as we want to eliminate dupplicates
SELECT DISTINCT
       ABD.IdProject,
       ABD.IdPhase,
       ABD.IdWorkPackage,
       ABD.IdCostCenter
FROM ANNUAL_BUDGET_DATA_DETAILS_COSTS ABD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ABD.YearMonth = op.YearMonthKey

GO

