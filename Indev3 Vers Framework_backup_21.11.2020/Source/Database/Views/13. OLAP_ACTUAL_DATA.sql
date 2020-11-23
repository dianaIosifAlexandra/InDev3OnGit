IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.OLAP_ACTUAL_DATA') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_ACTUAL_DATA
GO

CREATE VIEW OLAP_ACTUAL_DATA
AS

SELECT ADDH.IdProject,
	ADDH.IdPhase,
	ADDH.IdWorkPackage,
	ADDH.IdCostCenter,
	ADDH.IdAssociate,
	ADDH.YearMonth,
	ROUND(ADDH.HoursQty, 0) As HoursQty,
	ADDH.HoursVal As HoursVal,
	CAST(NULL as decimal (18,2)) as Cost,
	CAST(NULL as decimal (18,2)) as Sales,
	CAST(6 as int) AS CostTypeId
FROM ACTUAL_DATA_DETAILS_HOURS ADDH
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ADDH.YearMonth = op.YearMonthKey 
WHERE HoursQty is not null and
      HoursVal is not null
UNION ALL
SELECT 	ADDS.IdProject,
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
WHERE SalesVal is not null
UNION ALL
SELECT 	ADDC.IdProject,
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
WHERE CostVal is not null

GO
