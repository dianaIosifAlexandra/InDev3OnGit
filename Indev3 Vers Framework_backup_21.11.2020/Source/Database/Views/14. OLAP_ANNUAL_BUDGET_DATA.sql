IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.OLAP_ANNUAL_BUDGET_DATA') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_ANNUAL_BUDGET_DATA
GO

CREATE VIEW OLAP_ANNUAL_BUDGET_DATA
AS

SELECT ABDH.IdProject,
	ABDH.IdPhase,
	ABDH.IdWorkPackage,
	ABDH.IdCostCenter,
	CAST(-1 AS Int) as IdAssociate, --no associate
	ABDH.YearMonth,
	ABDH.HoursQty As HoursQty,
	ABDH.HoursVal As HoursVal,
	CAST(NULL as decimal (18,2)) as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	CAST(6 as int) AS CostTypeId
FROM ANNUAL_BUDGET_DATA_DETAILS_HOURS ABDH
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ABDH.YearMonth = op.YearMonthKey 
WHERE HoursQty is not null and
      HoursVal is not null
UNION ALL
SELECT 	ABDS.IdProject,
	ABDS.IdPhase,
	ABDS.IdWorkPackage,
	ABDS.IdCostCenter,
	CAST(-1 AS Int) as IdAssociate, --no associate
	ABDS.YearMonth,
	CAST(NULL as decimal (12,2)) as HoursQty,
	CAST(NULL as decimal (18,2)) as HoursVal,
	CAST(NULL as decimal (18,2)) as Cost,
	ABDS.SalesVal AS Sales,
	CAST(7 as int) AS CostTypeId
FROM ANNUAL_BUDGET_DATA_DETAILS_SALES ABDS
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ABDS.YearMonth = op.YearMonthKey 
WHERE SalesVal is not null
UNION ALL
SELECT 	ABTC.IdProject,
	ABTC.IdPhase,
	ABTC.IdWorkPackage,
	ABTC.IdCostCenter,
	CAST(-1 AS Int) as IdAssociate, --no associate
	ABTC.YearMonth,
	CAST(NULL as decimal (12,2)) as HoursQty,
	CAST(NULL as decimal (18,2)) as HoursVal,
	ABTC.CostVal as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	ABTC.IdCostType AS CostTypeId
FROM ANNUAL_BUDGET_DATA_DETAILS_COSTS ABTC
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ABTC.YearMonth = op.YearMonthKey 
WHERE CostVal is not null

GO
