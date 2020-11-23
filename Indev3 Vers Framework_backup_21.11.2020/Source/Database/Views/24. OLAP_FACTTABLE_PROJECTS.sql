IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.OLAP_FACTTABLE_PROJECTS') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_FACTTABLE_PROJECTS
GO

CREATE VIEW OLAP_FACTTABLE_PROJECTS
AS

SELECT TOP 100 PERCENT
	ACD.YearMonth as YearMonthKey,
	CAST(1 as int) as UnitKey,
	CAST(1 as int) as ScalingKey,
	ACD.IdProject as ProjectIdKey,
	OCP.IdCurrency as CurrencyIdKey,
	ACD.IdPhase as PhaseIdKey,
	CAST(ACD.IdWorkPackage + ACD.IdPhase * 10000 + ACD.IdProject * 1000000 AS BIGINT) AS WPFullKey,
	ACD.IdCostCenter as CostCenterIdKey,
	ACD.IdAssociate as AssociateIdKey,
	ACD.CostTypeId as CostTypeIdKey,
	ACD.CategoryId as CategoryIdKey,
	PRJ.IdProjectType as ProjectTypeIdKey,
	ACD.HoursQty As HoursQty,
	CAST(ACD.HoursVal * dbo.fnGetExchangeRate(dbo.fnGetCurrencyFromCC(ACD.IdCostCenter), OCP.IdCurrency, ACD.YearMonth) as Decimal(18,2)) AS HoursVal,
	CAST(ACD.Cost * dbo.fnGetExchangeRate(dbo.fnGetCurrencyFromCC(ACD.IdCostCenter), OCP.IdCurrency, ACD.YearMonth) as Decimal(18,2)) AS Cost,
	CAST(ACD.Sales * dbo.fnGetExchangeRate(dbo.fnGetCurrencyFromCC(ACD.IdCostCenter), OCP.IdCurrency, ACD.YearMonth) as Decimal(18,2)) AS Sales,
	ACD.Progress as Progress
FROM OLAP_ALLCATEGORIES_DATA ACD
INNER JOIN PROJECT_PHASES PH
	on ACD.IdPhase = PH.Id
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ACD.YearMonth = op.YearMonthKey 
INNER JOIN PROJECTS PRJ
	ON ACD.IdProject = PRJ.Id
INNER JOIN PROGRAMS PRG
	ON PRG.Id = PRJ.IdProgram
CROSS JOIN OLAP_CURRENCIES_PROGRAM_ALLCATEGORIES OCP --on purpose incomplete join - this multiplies the rows so that for each program, all currencies conversions are calculated
WHERE OCP.IdProgram = PRG.Id
ORDER BY PH.Code

GO
