IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.OLAP_FACTTABLE_FUNCTIONS') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_FACTTABLE_FUNCTIONS
GO

CREATE VIEW OLAP_FACTTABLE_FUNCTIONS
AS

SELECT TOP 100 PERCENT
	ACD.YearMonth as YearMonthKey,
	CAST(1 as int) as UnitKey,
	CAST(1 as int) as ScalingKey,
	ACD.IdProject as ProjectIdKey,
	OCP.IdCurrency as CurrencyIdKey,
	ACD.IdCostCenter as CostCenterIdKey,
	ACD.IdAssociate as AssociateIdKey,
	ACD.CostTypeId as CostTypeIdKey,
	ACD.CategoryId as CategoryIdKey,
	PRJ.IdProjectType as ProjectTypeIdKey,
	ACD.HoursQty As HoursQty,
	CAST(ACD.HoursVal * dbo.fnGetExchangeRate(CURR.ID, OCP.IdCurrency, ACD.YearMonth) as Decimal(18,2)) AS HoursVal,
	CAST(ACD.Cost * dbo.fnGetExchangeRate(CURR.ID, OCP.IdCurrency, ACD.YearMonth) as Decimal(18,2)) AS Cost
FROM OLAP_FUNCTIONS_DATA ACD
INNER JOIN PROJECT_PHASES PH
	on ACD.IdPhase = PH.Id
INNER JOIN COST_CENTERS CC
	ON ACD.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL
	ON CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C
	ON IL.IdCountry = C.Id
INNER JOIN CURRENCIES CURR
	ON C.IdCurrency  =CURR.Id
INNER JOIN DEPARTMENTS D
	ON CC.IdDepartment = D.Id
INNER JOIN FUNCTIONS F
	ON D.IdFunction = F.Id
INNER JOIN OLAP_PERIODS op --filter only the data for the period of interest
	ON ACD.YearMonth = op.YearMonthKey 
INNER JOIN PROJECTS PRJ
	ON PRJ.Id = ACD.IdProject
INNER JOIN PROGRAMS PRG
	ON PRG.Id = PRJ.IdProgram
CROSS JOIN OLAP_CURRENCIES_PROGRAM_FUNCTIONS OCP --on purpose incomplete join - this multiplies the rows so that for each program, all currencies conversions are calculated
WHERE OCP.IdProgram = PRG.Id
ORDER BY PH.Code, CC.Code

GO
