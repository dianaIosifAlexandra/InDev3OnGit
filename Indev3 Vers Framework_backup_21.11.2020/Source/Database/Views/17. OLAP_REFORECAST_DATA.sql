IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.OLAP_REFORECAST_DATA') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_REFORECAST_DATA
GO

CREATE VIEW OLAP_REFORECAST_DATA
AS

--1. HOURS
SELECT  ADDH.IdProject,
	ADDH.IdPhase,
	ADDH.IdWorkPackage,
	ADDH.IdCostCenter,
	ADDH.IdAssociate,
	ADDH.YearMonth,
	ROUND(ADDH.HoursQty,0) As HoursQty,
	ADDH.HoursVal As HoursVal,
	CAST(NULL as decimal (18,2)) as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	CAST(6 as int) AS CostTypeId
FROM ACTUAL_DATA_DETAILS_HOURS ADDH
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ADDH.YearMonth = op.YearMonthKey 
LEFT JOIN BUDGET_TOCOMPLETION BC
	ON BC.IdProject = ADDH.IdProject AND
	   BC.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(ADDH.IdProject, 'C')
WHERE ADDH.YearMonth <= CASE WHEN BC.YearMonthActualData IS NULL THEN ADDH.YearMonth ELSE BC.YearMonthActualData END


UNION ALL

SELECT BTD.IdProject,
	BTD.IdPhase,
	BTD.IdWorkPackage,
	BTD.IdCostCenter,
	BTD.IdAssociate,
	BTD.YearMonth,
	BTD.HoursQty As HoursQty,
	BTD.HoursVal As HoursVal,
	CAST(NULL as decimal (18,2)) as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	CAST(6 as int) AS CostTypeId
FROM BUDGET_TOCOMPLETION_DETAIL BTD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BTD.YearMonth = op.YearMonthKey 
INNER JOIN BUDGET_TOCOMPLETION BC
	ON BC.IdProject = BTD.IdProject AND
	   BC.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BTD.IdProject, 'C')
WHERE BTD.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BTD.IdProject, 'C') and
      HoursQty is not null and
      HoursVal is not null and
      BTD.YearMonth > CASE WHEN BC.YearMonthActualData IS NULL THEN 190001 ELSE BC.YearMonthActualData END

UNION ALL
--2. SALES
SELECT  ADDS.IdProject,
	ADDS.IdPhase,
	ADDS.IdWorkPackage,
	ADDS.IdCostCenter,
	ADDS.IdAssociate,
	ADDS.YearMonth,
	CAST(NULL as decimal (12,2)) as HoursQty,
	CAST(NULL as decimal (18,2)) as HoursVal,
	CAST(NULL as decimal (18,2)) as Cost,
	ADDS.SalesVal AS Sales,
	CAST(7 as int) AS CostTypeId
FROM ACTUAL_DATA_DETAILS_SALES ADDS
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ADDS.YearMonth = op.YearMonthKey 
INNER JOIN BUDGET_TOCOMPLETION BC
	ON BC.IdProject = ADDS.IdProject AND
	   BC.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(ADDS.IdProject, 'C')
WHERE 	ADDS.YearMonth <= CASE WHEN BC.YearMonthActualData IS NULL THEN ADDS.YearMonth ELSE BC.YearMonthActualData END

UNION ALL

SELECT 	BTD.IdProject,
	BTD.IdPhase,
	BTD.IdWorkPackage,
	BTD.IdCostCenter,
	BTD.IdAssociate,
	BTD.YearMonth,
	CAST(NULL as decimal (12,2)) as HoursQty,
	CAST(NULL as decimal (18,2)) as HoursVal,
	CAST(NULL as decimal (18,2)) as Cost,
	BTD.SalesVal AS Sales,
	CAST(7 as int) AS CostTypeId
FROM BUDGET_TOCOMPLETION_DETAIL BTD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BTD.YearMonth = op.YearMonthKey 
INNER JOIN BUDGET_TOCOMPLETION BC
	ON BC.IdProject = BTD.IdProject AND
	   BC.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BTD.IdProject, 'C')
WHERE BTD.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BTD.IdProject, 'C') and
      SalesVal is not null and
      BTD.YearMonth > CASE WHEN BC.YearMonthActualData IS NULL THEN 190001 ELSE BC.YearMonthActualData END

UNION ALL
--3. COSTS
SELECT  ADDC.IdProject,
	ADDC.IdPhase,
	ADDC.IdWorkPackage,
	ADDC.IdCostCenter,
	ADDC.IdAssociate,
	ADDC.YearMonth,
	CAST(NULL as decimal (12,2)) as HoursQty,
	CAST(NULL as decimal (18,2)) as HoursVal,
	ADDC.CostVal as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	ADDC.IdCostType AS CostTypeId
FROM ACTUAL_DATA_DETAILS_COSTS ADDC
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ADDC.YearMonth = op.YearMonthKey 
INNER JOIN BUDGET_TOCOMPLETION BC
	ON BC.IdProject = ADDC.IdProject AND
	   BC.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(ADDC.IdProject, 'C')
WHERE 	ADDC.YearMonth <= CASE WHEN BC.YearMonthActualData IS NULL THEN ADDC.YearMonth ELSE BC.YearMonthActualData END


UNION ALL

SELECT 	BTDC.IdProject,
	BTDC.IdPhase,
	BTDC.IdWorkPackage,
	BTDC.IdCostCenter,
	BTDC.IdAssociate,
	BTDC.YearMonth,
	CAST(NULL as decimal (12,2)) as HoursQty,
	CAST(NULL as decimal (18,2)) as HoursVal,
	BTDC.CostVal as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	BTDC.IdCostType AS CostTypeId
FROM BUDGET_TOCOMPLETION_DETAIL_COSTS BTDC
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BTDC.YearMonth = op.YearMonthKey 
INNER JOIN BUDGET_TOCOMPLETION BC
	ON BC.IdProject = BTDC.IdProject AND
	   BC.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BTDC.IdProject, 'C')
WHERE BTDC.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BTDC.IdProject, 'C') and
      CostVal is not null and
      BTDC.YearMonth > CASE WHEN BC.YearMonthActualData IS NULL THEN 190001 ELSE BC.YearMonthActualData END

UNION ALL -- we take the data separately about the progress because it have different keys than tocompletiondata( no cost center, yearmonth, cost type)

SELECT 	BTDC.IdProject,
	BTDC.IdPhase,
	BTDC.IdWorkPackage,
	CAST(-1 AS INT) AS IdCostCenter,
	BTDC.IdAssociate,
	CAST(200501 as INT) AS YearMonth,
	CAST(NULL as decimal (12,2)) as HoursQty,
	CAST(NULL as decimal (18,2)) as HoursVal,
	CAST(NULL AS decimal (18,2)) as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	CAST(-1 as INT) AS CostTypeId
FROM BUDGET_TOCOMPLETION_PROGRESS BTDC
WHERE 	BTDC.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BTDC.IdProject, 'C') and
	BTDC.[Percent] is not null

GO
