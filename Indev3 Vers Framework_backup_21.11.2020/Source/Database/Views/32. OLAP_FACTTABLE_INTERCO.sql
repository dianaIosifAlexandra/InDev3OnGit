IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_FACTTABLE_INTERCO]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_FACTTABLE_INTERCO
GO

CREATE VIEW OLAP_FACTTABLE_INTERCO
AS

SELECT 
	ACD.YearMonth as YearMonthKey,
	CAST(1 as int) as UnitKey,
	CAST(1 as int) as ScalingKey,
	ACD.IdProject as ProjectIdKey,
	OCP.IdCurrency as CurrencyIdKey,
	C.Id as CountryFromIdKey,
	ISNULL(PIN.IdCountry,-1) as CountryToIdKey,
	OPT.PhaseTypeId	as PhaseTypeIdKey,
	ACD.IdWorkPackage as WorkPackageIdKey,
	ACD.CategoryId as CategoryIdKey,
	CAST(ACD.IdWorkPackage + ACD.IdPhase * 10000 + ACD.IdProject * 1000000 AS BIGINT) AS WPFullKey,
	PRJ.IdProjectType as ProjectTypeIdKey,
	ACD.HoursQty * CAST(ISNULL(PIN.PercentAffected,100)/100 as decimal(18,2)) As HoursQty,
	CAST(ACD.HoursVal * dbo.fnGetExchangeRate(C.IdCurrency, OCP.IdCurrency, ACD.YearMonth) as Decimal(18,2)) * CAST(ISNULL(PIN.PercentAffected,100)/100 as decimal(18,2)) AS HoursVal,
	CAST(ACD.Cost * dbo.fnGetExchangeRate(C.IdCurrency, OCP.IdCurrency, ACD.YearMonth) as Decimal(18,2)) * CAST(ISNULL(PIN.PercentAffected,100)/100 as decimal(18,2)) AS Cost,
	CAST(ACD.Sales * dbo.fnGetExchangeRate(C.IdCurrency, OCP.IdCurrency, ACD.YearMonth) as Decimal(18,2)) * CAST(ISNULL(PIN.PercentAffected,100)/100 as decimal(18,2)) AS Sales,
	CAST(ISNULL(PIN.PercentAffected,100)/100 as decimal(18,2)) AS Interco,
	ISNULL(OGA.Rate,0) AS GACountryRate,
	ISNULL(OMA.Rate,0) AS MarkUpRate
FROM OLAP_INTERCO_DATA ACD
INNER JOIN OLAP_PHASE_TYPE OPT
	on ACD.IdPhase = OPT.PhaseId
INNER JOIN COST_CENTERS CC 
	ON ACD.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	ON CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	ON IL.IdCountry = C.Id
LEFT JOIN PROJECTS_INTERCO PIN --on purpose incomplete join - this multiplies the rows, to be check if the multiplied rows are ok.
	on ACD.IdProject = PIN.IdProject and
	   ACD.IdPhase = PIN.IdPhase and
	   ACD.IdWorkPackage = PIN.IdWorkPackage
INNER JOIN DEPARTMENTS D
	ON CC.IdDepartment = D.Id
INNER JOIN FUNCTIONS F
	ON D.IdFunction = F.Id
INNER JOIN OLAP_PERIODS OP --filter only the data for the period of interest
	ON ACD.YearMonth = OP.YearMonthKey 
INNER JOIN PROJECTS PRJ
	ON PRJ.Id = ACD.IdProject
INNER JOIN PROGRAMS PRG
	ON PRG.Id = PRJ.IdProgram
LEFT JOIN OLAP_GA_RATES OGA
	ON C.Id = OGA.IdCountry AND 
	   ACD.YearMonth = OGA.YearMonth
LEFT JOIN OLAP_MARKUP_RATES OMA
	ON OP.Year  = OMA.Year
CROSS JOIN OLAP_CURRENCIES_PROGRAM_INTERCO OCP --on purpose incomplete join - this multiplies the rows so that for each program, all currencies conversions are calculated
WHERE OCP.IdProgram = PRG.Id


GO

