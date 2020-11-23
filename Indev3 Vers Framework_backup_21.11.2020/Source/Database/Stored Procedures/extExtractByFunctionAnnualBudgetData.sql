
--Drops the Procedure extExtractByFunctionAnnualBudgetData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractByFunctionAnnualBudgetData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractByFunctionAnnualBudgetData
GO

-- exec extExtractByFunctionAnnualBudgetData 2005,-1,-1,-1,-1,-1,'L'

CREATE PROCEDURE extExtractByFunctionAnnualBudgetData
(
	@Year			INT,
	@IdRegion 		INT,
	@IdCountry 		INT,
	@IdInergyLocation 	INT,
	@IdFunction 		INT,
	@IdDepartment 		INT,
	@WPActiveStatus 	VARCHAR(1),
	@CostTypeCategory	VARCHAR(1),
	@IdCurrencyAssociate	INT
)

AS

-- create temporary table #INCOME_COST_TYPES_CATEGORY to categorize cost types
create table #INCOME_COST_TYPES_CATEGORY(IdCostType int, CostTypeCategory varchar(1))

insert into #INCOME_COST_TYPES_CATEGORY (IdCostType, CostTypeCategory)
select Id, 'O' from BUDGET_COST_TYPES

insert into #INCOME_COST_TYPES_CATEGORY(IdCostType, CostTypeCategory)
select dbo.fnGetHoursCostTypeID(), 'H'

insert into #INCOME_COST_TYPES_CATEGORY(IdCostType, CostTypeCategory)
select dbo.fnGetSalesCostTypeID(), 'S'

DECLARE @tempAnnual table
(
	IdExtract 	INT  IDENTITY (1, 1) NOT NULL,
	IdProject 	INT,
	IdPhase 	INT,
	IdWorkPackage 	INT,
	IdCostCenter 	INT,
	YearMonth 	INT,
	AccountNumber 	varchar(20),
	Quantity 	decimal(12,2),
	Value 		decimal(18,2),
	DateImport	SMALLDATETIME

	PRIMARY KEY (YearMonth, IdProject, IdPhase, IdWorkPackage, IdCostCenter, AccountNumber)
)


--GET ALL HOURS RECORDS FROM ANNUAL BUDGET DATA

INSERT INTO @tempAnnual (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, Quantity, Value, DateImport)

SELECT  ABD.IdProject, ABD.IdPhase, ABD.IdWorkPackage, ABD.IdCostCenter,
	ABD.YearMonth, GLA.Account, SUM(ABD.HoursQty), SUM(ABD.HoursVal), ABD.DateImport
FROM ANNUAL_BUDGET_DATA_DETAILS_HOURS ABD
INNER JOIN ANNUAL_BUDGET AB
	ON AB.IdProject = ABD.IdProject
INNER JOIN COST_CENTERS CC 
	ON ABD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON ABD.IdCountry = GLA.IdCountry AND
	   ABD.IdAccount = GLA.Id
INNER JOIN INERGY_LOCATIONS IL 
	ON CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C 
	ON IL.IdCountry = C.Id
INNER JOIN REGIONS R 
	ON C.IdRegion = R.Id
INNER JOIN DEPARTMENTS d 
	ON CC.IdDepartment = D.Id
INNER JOIN [FUNCTIONS] F 
	ON D.IdFunction = F.Id
INNER JOIN WORK_PACKAGES WP 
	ON ABD.Idproject = WP.IdProject AND
	   ABD.IdPhase = WP.IdPhase AND
	   ABD.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE 	ABD.YearMonth/100 = @Year AND
	R.Id = CASE WHEN @IdRegion = -1 THEN R.Id ELSE @IdRegion END AND
	C.Id = CASE WHEN @IdCountry = -1 THEN C.Id ELSE @IdCountry END AND
	IL.Id = CASE WHEN @IdInergyLocation = -1 THEN IL.Id ELSE @IdInergyLocation END AND
	F.Id = CASE WHEN @IdFunction = -1 THEN F.Id ELSE @IdFunction END AND
	D.Id = CASE WHEN @IdDepartment = -1 THEN D.Id ELSE @IdDepartment END AND	
	WP.IsActive = CASE	
			WHEN @WPActiveStatus = 'A' THEN 1
			WHEN @WPActiveStatus = 'I' THEN 0
			WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
		      END AND
	ictc.CostTypeCategory = CASE 
				  WHEN @CostTypeCategory = 'A' THEN ictc.CostTypeCategory 
				  ELSE @CostTypeCategory 
				END
GROUP BY ABD.IdProject, ABD.IdPhase, ABD.IdWorkPackage, ABD.IdCostCenter,
	ABD.YearMonth, GLA.Account, ABD.DateImport

--GET ALL SALES RECORDS FROM ANNUAL BUDGET DATA

INSERT INTO @tempAnnual (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, Quantity, Value, DateImport)

SELECT  ABDS.IdProject, ABDS.IdPhase, ABDS.IdWorkPackage, ABDS.IdCostCenter,
	ABDS.YearMonth, GLA.Account, 0, SUM(ABDS.SalesVal), ABDS.DateImport
FROM ANNUAL_BUDGET_DATA_DETAILS_SALES ABDS
INNER JOIN ANNUAL_BUDGET AB  
	ON AB.IdProject = ABDS.IdProject
INNER JOIN COST_CENTERS CC 
	ON ABDS.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON ABDS.IdCountry = GLA.IdCountry AND
	   ABDS.IdAccount = GLA.Id
INNER JOIN INERGY_LOCATIONS IL 
	ON CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C 
	ON IL.IdCountry = C.Id
INNER JOIN REGIONS R 
	ON C.IdRegion = R.Id
INNER JOIN DEPARTMENTS d 
	ON CC.IdDepartment = D.Id
INNER JOIN FUNCTIONS F 
	ON D.IdFunction = F.Id
INNER JOIN WORK_PACKAGES WP 
	ON ABDS.Idproject = WP.IdProject AND
	   ABDS.IdPhase = WP.IdPhase AND
	   ABDS.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE 	ABDS.YearMonth/100 = @Year AND
	R.Id = CASE WHEN @IdRegion = -1 THEN R.Id ELSE @IdRegion END AND
	C.Id = CASE WHEN @IdCountry = -1 THEN C.Id ELSE @IdCountry END AND
	IL.Id = CASE WHEN @IdInergyLocation = -1 THEN IL.Id ELSE @IdInergyLocation END AND
	F.Id = CASE WHEN @IdFunction = -1 THEN F.Id ELSE @IdFunction END AND
	D.Id = CASE WHEN @IdDepartment = -1 THEN D.Id ELSE @IdDepartment END AND	
	WP.IsActive = CASE	
			WHEN @WPActiveStatus = 'A' THEN 1
			WHEN @WPActiveStatus = 'I' THEN 0
			WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
		      END AND
	ictc.CostTypeCategory = CASE 
				  WHEN @CostTypeCategory = 'A' THEN ictc.CostTypeCategory 
				  ELSE @CostTypeCategory 
				END
GROUP BY ABDS.IdProject, ABDS.IdPhase, ABDS.IdWorkPackage, ABDS.IdCostCenter,
	ABDS.YearMonth, GLA.Account, ABDS.DateImport

--GET ALL OTHER COSTS
INSERT INTO @tempAnnual (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, Quantity, Value, DateImport)
SELECT ABDC.IdProject, ABDC.IdPhase, ABDC.IdWorkPackage, ABDC.IdCostCenter,
	ABDC.YearMonth, GLA.Account, 0, SUM(ABDC.CostVal), ABDC.DateImport
FROM ANNUAL_BUDGET_DATA_DETAILS_COSTS ABDC
INNER JOIN ANNUAL_BUDGET AB  
	ON AB.IdProject = ABDC.IdProject
INNER JOIN COST_CENTERS CC 
	ON ABDC.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON ABDC.IdCountry = GLA.IdCountry AND
	   ABDC.IdAccount = GLA.Id
INNER JOIN INERGY_LOCATIONS IL 
	ON CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C 
	ON IL.IdCountry = C.Id
INNER JOIN REGIONS R 
	ON C.IdRegion = R.Id
INNER JOIN DEPARTMENTS d 
	ON CC.IdDepartment = D.Id
INNER JOIN FUNCTIONS F 
	ON D.IdFunction = F.Id
INNER JOIN WORK_PACKAGES WP 
	ON ABDC.Idproject = WP.IdProject AND
	   ABDC.IdPhase = WP.IdPhase AND
	   ABDC.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE   ABDC.YearMonth/100 = @Year AND
	R.Id = CASE WHEN @IdRegion = -1 THEN R.Id ELSE @IdRegion END AND
	C.Id = CASE WHEN @IdCountry = -1 THEN C.Id ELSE @IdCountry END AND
	IL.Id = CASE WHEN @IdInergyLocation = -1 THEN IL.Id ELSE @IdInergyLocation END AND
	F.Id = CASE WHEN @IdFunction = -1 THEN F.Id ELSE @IdFunction END AND
	D.Id = CASE WHEN @IdDepartment = -1 THEN D.Id ELSE @IdDepartment END AND	
	WP.IsActive = CASE	
			WHEN @WPActiveStatus = 'A' THEN 1
			WHEN @WPActiveStatus = 'I' THEN 0
			WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
		      END AND
	ictc.CostTypeCategory = CASE 
				  WHEN @CostTypeCategory = 'A' THEN ictc.CostTypeCategory 
				  ELSE @CostTypeCategory 
				END
GROUP BY ABDC.IdProject, ABDC.IdPhase, ABDC.IdWorkPackage, ABDC.IdCostCenter,
	ABDC.YearMonth, GLA.Account, ABDC.DateImport



SELECT 	P.Code as 				[Project Code],
	P.Name as 				[Project Name],
	PH.Code as 				[Phase Code],
	WP.Code as 				[WP Code],
	WP.Name as				[WP Name],
	WP.Rank as				[WP Rank],
	C.Name as 				[Country Name],
	IL.Name as 				[Inergy Location Name],
	CC.Code as 				[Cost Center Code],
	CC.Name as 				[Cost Center Name],
	D.Name as 				[Department Name],
	F.Name as 				[Function Name],
	CIT.Name as 				[Cost Type Name],
	t.AccountNumber as 			[GL Account Number],
	GL.Name as 				[GL Account Description],
	CAST('annual budget' AS VARCHAR(15)) as	[Extract Category],
	t.YearMonth/100 as 			[Year],
	t.YearMonth%100 as 			[Month],
	t.Quantity as 				[Quantity],
	t.Value as			 	[Value],
	CUR.Code as 				[Currency],
	CAST(dbo.fnGetAnnualExchangeRate(@IdCurrencyAssociate,CUR.Id,t.YearMonth)AS DECIMAL(18,4)) AS [Exchange Rate],
	dbo.fnDate2String(t.DateImport) as	[Import Date]
	
FROM @tempAnnual t
INNER JOIN PROJECTS P
	ON P.Id = t.IdProject
INNER JOIN WORK_PACKAGES WP
	ON WP.IdProject = t.IdProject AND
	   WP.IdPhase = t.IdPhase AND
	   WP.Id = t.IdWorkPackage
INNER JOIN PROJECT_PHASES PH
	ON PH.Id = t.IdPhase
INNER JOIN COST_CENTERS CC
	ON CC.Id = t.IdCostCenter
INNER JOIN INERGY_LOCATIONS IL
	ON IL.Id = CC.IdInergyLocation
INNER JOIN COUNTRIES C
	ON C.Id = IL.IdCountry
INNER JOIN DEPARTMENTS D
	ON D.Id = CC.IdDepartment
INNER JOIN FUNCTIONS F
	ON F.Id = D.IdFunction
INNER JOIN GL_ACCOUNTS GL
	ON GL.IdCountry = IL.IdCountry AND
	   GL.Account = AccountNumber
INNER JOIN COST_INCOME_TYPES CIT
	ON CIT.Id = GL.IdCostType
INNER JOIN CURRENCIES CUR
	ON CUR.Id = C.IdCurrency
WHERE COALESCE(NULLIF(t.Quantity,0),NULLIF(t.Value,0)) IS NOT NULL
ORDER BY P.Code,  PH.Code, WP.Rank, CC.Code, CIT.Rank, t.YearMonth

GO

