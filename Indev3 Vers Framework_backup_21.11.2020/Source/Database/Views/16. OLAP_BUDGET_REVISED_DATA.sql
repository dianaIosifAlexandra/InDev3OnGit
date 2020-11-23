IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.OLAP_BUDGET_REVISED_DATA') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_BUDGET_REVISED_DATA
GO

CREATE VIEW OLAP_BUDGET_REVISED_DATA
AS

SELECT BRD.IdProject,
	BRD.IdPhase,
	BRD.IdWorkPackage,
	BRD.IdCostCenter,
	BRD.IdAssociate,
	BRD.YearMonth,
	BRD.HoursQty As HoursQty,
	BRD.HoursVal As HoursVal,
	CAST(NULL as decimal (18,2)) as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	CAST(6 as int) AS CostTypeId
FROM BUDGET_REVISED_DETAIL BRD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BRD.YearMonth = op.YearMonthKey 
WHERE IdGeneration = dbo.fnGetRevisedBudgetGeneration(BRD.IdProject, 'C') and
      HoursQty is not null and
      HoursVal is not null
UNION ALL
SELECT 	BRD.IdProject,
	BRD.IdPhase,
	BRD.IdWorkPackage,
	BRD.IdCostCenter,
	BRD.IdAssociate,
	BRD.YearMonth,
	CAST(NULL as decimal (12,2)) as HoursQty,
	CAST(NULL as decimal (18,2)) as HoursVal,
	CAST(NULL as decimal (18,2)) as Cost,
	BRD.SalesVal AS Sales,
	CAST(7 as int) AS CostTypeId
FROM BUDGET_REVISED_DETAIL BRD
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BRD.YearMonth = op.YearMonthKey 
WHERE IdGeneration = dbo.fnGetRevisedBudgetGeneration(BRD.IdProject, 'C') and
      SalesVal is not null
UNION ALL
SELECT 	BRDC.IdProject,
	BRDC.IdPhase,
	BRDC.IdWorkPackage,
	BRDC.IdCostCenter,
	BRDC.IdAssociate,
	BRDC.YearMonth,
	CAST(NULL as decimal (12,2)) as HoursQty,
	CAST(NULL as decimal (18,2)) as HoursVal,
	BRDC.CostVal as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	BRDC.IdCostType AS CostTypeId
FROM BUDGET_REVISED_DETAIL_COSTS BRDC
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BRDC.YearMonth = op.YearMonthKey 
WHERE IdGeneration = dbo.fnGetRevisedBudgetGeneration(BRDC.IdProject, 'C') and
      CostVal is not null

GO
