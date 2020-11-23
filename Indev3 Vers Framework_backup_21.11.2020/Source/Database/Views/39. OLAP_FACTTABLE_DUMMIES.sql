IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.OLAP_FACTTABLE_DUMMIES') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_FACTTABLE_DUMMIES
GO

CREATE VIEW OLAP_FACTTABLE_DUMMIES
AS

SELECT TOP 100 PERCENT
	ACD.YearMonth as YearMonthKey,
	CAST(1 as int) as UnitKey,
	CAST(1 as int) as ScalingKey,
	OPT.PhaseTypeId as PhaseTypeIdKey,
	ACD.IdProject as ProjectIdKey,
	PRJ.IdProgram as ProgramIdKey,
	OCP.IdCurrency as CurrencyIdKey,
	ACD.IdCostCenter as CostCenterIdKey,
	ACD.CategoryId as CategoryIdKey,
	IL.Id AS InergyLocationIdKey,
	D.Id AS DepartmentIdKey,
	PRJ.IdProjectType as ProjectTypeIdKey,
	CAST(ACD.HoursQty as INT) As HoursQty,
	CAST(ACD.HoursVal * dbo.fnGetExchangeRate(CURR.ID, OCP.IdCurrency, ACD.YearMonth) as bigint) AS HoursVal,
	CAST(ACD.Cost * dbo.fnGetExchangeRate(CURR.ID, OCP.IdCurrency, ACD.YearMonth) as bigint) AS Cost,
	CAST(ACD.Sales * dbo.fnGetExchangeRate(CURR.ID, OCP.IdCurrency, ACD.YearMonth) as bigint) AS Sales
FROM OLAP_FUNCTIONS_DATA ACD
INNER JOIN OLAP_PHASE_TYPE OPT
	on ACD.IdPhase = OPT.PhaseId
INNER JOIN COST_CENTERS CC
	ON ACD.IdCostCenter = CC.Id
INNER JOIN DEPARTMENTS D
	ON D.Id = CC.IdDepartment
INNER JOIN PROJECTS PRJ
	ON ACD.IdProject = PRJ.Id
INNER JOIN INERGY_LOCATIONS IL
	ON CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	ON IL.IdCountry = C.Id
INNER JOIN CURRENCIES CURR
	ON C.IdCurrency  =CURR.Id
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ACD.YearMonth = op.YearMonthKey 
INNER JOIN PROGRAMS PRG
	ON PRG.Id = PRJ.IdProgram
CROSS JOIN OLAP_CURRENCIES_PROGRAM_FUNCTIONS OCP --on purpose incomplete join - this multiplies the rows so that for each program, all currencies conversions are calculated
WHERE OCP.IdProgram = PRG.Id
ORDER BY OPT.PhaseCode, CC.Code

GO
