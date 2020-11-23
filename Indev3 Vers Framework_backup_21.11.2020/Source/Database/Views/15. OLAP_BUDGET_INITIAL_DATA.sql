IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.OLAP_BUDGET_INITIAL_DATA') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_BUDGET_INITIAL_DATA
GO

CREATE VIEW OLAP_BUDGET_INITIAL_DATA
AS

SELECT BID.IdProject,
	BID.IdPhase,
	BID.IdWorkPackage,
	BID.IdCostCenter,
	BID.IdAssociate,
	BID.YearMonth,
	BID.HoursQty As HoursQty,
	BID.HoursVal As HoursVal,
	CAST(NULL as decimal (18,2)) as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	CAST(6 as int) AS CostTypeId
FROM BUDGET_INITIAL_DETAIL BID
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BID.YearMonth = op.YearMonthKey 
WHERE HoursQty is not null and
      HoursVal is not null
UNION ALL
SELECT 	BID.IdProject,
	BID.IdPhase,
	BID.IdWorkPackage,
	BID.IdCostCenter,
	BID.IdAssociate,
	BID.YearMonth,
	CAST(NULL as decimal (12,2)) as HoursQty,
	CAST(NULL as decimal (18,2)) as HoursVal,
	CAST(NULL as decimal (18,2)) as Cost,
	BID.SalesVal AS Sales,
	CAST(7 as int) AS CostTypeId
FROM BUDGET_INITIAL_DETAIL BID
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BID.YearMonth = op.YearMonthKey 
WHERE SalesVal is not null
UNION ALL
SELECT 	BIDC.IdProject,
	BIDC.IdPhase,
	BIDC.IdWorkPackage,
	BIDC.IdCostCenter,
	BIDC.IdAssociate,
	BIDC.YearMonth,
	CAST(NULL as decimal (12,2)) as HoursQty,
	CAST(NULL as decimal (18,2)) as HoursVal,
	BIDC.CostVal as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	BIDC.IdCostType AS CostTypeId
FROM BUDGET_INITIAL_DETAIL_COSTS BIDC
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON BIDC.YearMonth = op.YearMonthKey 
WHERE CostVal is not null


GO

