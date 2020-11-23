--Drops the Procedure extExtractByFunctionRevisedData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractByFunctionRevisedData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractByFunctionRevisedData
GO

--exec extExtractByFunctionRevisedData 2008,-1,-1,-1,-1,-1,'L'

CREATE PROCEDURE extExtractByFunctionRevisedData
(
	@Year			INT,
	@IdRegion 		INT,
	@IdCountry 		INT,
	@IdInergyLocation 	INT,
	@IdFunction 		INT,
	@IdDepartment 		INT,
	@WPActiveStatus 	VARCHAR(1),
	@CostTypeCategory 	VARCHAR(1),
	@IdCurrencyAssociate	INT
)

AS

DECLARE @tempRevised table
(
	IdExtract 	INT  IDENTITY (1, 1) NOT NULL,
	IdProject 	INT,
	IdPhase 	INT,
	IdWorkPackage 	INT,
	IdCostCenter	INT,
	YearMonth 	INT,
	AccountNumber 	varchar(20),
	IdAssociate 	INT,
	Quantity 	INT,
	Value 		bigint,
	ValidationDate	SMALLDATETIME

	PRIMARY KEY (YearMonth, IdProject, IdPhase, IdWorkPackage, IdCostCenter, AccountNumber, IdAssociate)
)


-- create temporary table #INCOME_COST_TYPES_CATEGORY to categorize cost types
create table #INCOME_COST_TYPES_CATEGORY(IdCostType int, CostTypeCategory varchar(1))

insert into #INCOME_COST_TYPES_CATEGORY (IdCostType, CostTypeCategory)
select Id, 'O' from BUDGET_COST_TYPES

insert into #INCOME_COST_TYPES_CATEGORY(IdCostType, CostTypeCategory)
select dbo.fnGetHoursCostTypeID(), 'H'

insert into #INCOME_COST_TYPES_CATEGORY(IdCostType, CostTypeCategory)
select dbo.fnGetSalesCostTypeID(), 'S'


--GET ALL HOURS RECORDS
INSERT INTO @tempRevised (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, ValidationDate)

SELECT  BRD.IdProject, BRD.IdPhase, BRD.IdWorkPackage, BRD.IdCostCenter,
	BRD.YearMonth, GLA.Account, BRD.IdAssociate, ROUND(SUM(BRD.HoursQty),0), ROUND(SUM(BRD.HoursVal),0),
	BR.ValidationDate
FROM 	BUDGET_REVISED_DETAIL BRD
INNER JOIN BUDGET_REVISED BR 
	ON BR.IdProject = BRD.IdProject AND
	   BR.IdGeneration = BRD.IdGeneration
INNER JOIN COST_CENTERS CC 
	ON BRD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON BRD.IdCountry = GLA.IdCountry AND
	   BRD.IdAccountHours = GLA.Id
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
	ON BRD.Idproject = WP.IdProject AND
	   BRD.IdPhase = WP.IdPhase AND
	   BRD.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE 	BR.IdGeneration = dbo.fnGetRevisedBudgetGeneration(BR.IdProject,'C') AND
	(BRD.HoursQty IS NOT NULL OR BRD.HoursVal IS NOT NULL) AND
	BRD.YearMonth/100 = @Year AND
	R.Id = CASE WHEN @IdRegion = -1 THEN R.Id ELSE @IdRegion END AND
	C.Id = CASE WHEN @IdCountry = -1 THEN C.Id ELSE @IdCountry END AND
	IL.Id = CASE WHEN @IdInergyLocation = -1 THEN IL.Id ELSE @IdInergyLocation END AND
	F.Id = CASE WHEN @IdFunction = -1 THEN F.Id ELSE @IdFunction END AND
	D.Id = CASE WHEN @IdDepartment = -1 THEN D.Id ELSE @IdDepartment END AND	
	WP.IsActive = CASE	
			WHEN @WPActiveStatus = 'A' THEN 1
			WHEN @WPActiveStatus = 'I' THEN 0
			WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
		      END 
	AND
	ictc.CostTypeCategory = case when @CostTypeCategory = 'A' then ictc.CostTypeCategory else @CostTypeCategory end

GROUP BY BRD.IdProject, BRD.IdPhase, BRD.IdWorkPackage, BRD.IdCostCenter,
	BRD.YearMonth, GLA.Account, BRD.IdAssociate, BR.ValidationDate


--GET ALL SALES RECORD
INSERT INTO @tempRevised (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, ValidationDate)

SELECT  BRD.IdProject, BRD.IdPhase, BRD.IdWorkPackage, BRD.IdCostCenter,
	BRD.YearMonth, GLA.Account, BRD.IdAssociate, 0, ROUND(SUM(BRD.SalesVal),0), BR.ValidationDate
FROM 	BUDGET_REVISED_DETAIL BRD
INNER JOIN BUDGET_REVISED BR 
	ON BR.IdProject = BRD.IdProject AND
	   BR.IdGeneration = BRD.IdGeneration
INNER JOIN COST_CENTERS CC 
	ON BRD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON BRD.IdCountry = GLA.IdCountry AND
	   BRD.IdAccountSales = GLA.Id
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
	ON BRD.Idproject = WP.IdProject AND
	   BRD.IdPhase = WP.IdPhase AND
	   BRD.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE 	BR.IdGeneration = dbo.fnGetRevisedBudgetGeneration(BR.IdProject,'C') AND	
	BRD.SalesVal IS NOT NULL AND
	BRD.YearMonth/100 = @Year AND
	R.Id = CASE WHEN @IdRegion = -1 THEN R.Id ELSE @IdRegion END AND
	C.Id = CASE WHEN @IdCountry = -1 THEN C.Id ELSE @IdCountry END AND
	IL.Id = CASE WHEN @IdInergyLocation = -1 THEN IL.Id ELSE @IdInergyLocation END AND
	F.Id = CASE WHEN @IdFunction = -1 THEN F.Id ELSE @IdFunction END AND
	D.Id = CASE WHEN @IdDepartment = -1 THEN D.Id ELSE @IdDepartment END AND	
	WP.IsActive = CASE	
			WHEN @WPActiveStatus = 'A' THEN 1
			WHEN @WPActiveStatus = 'I' THEN 0
			WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
		      END 
	AND
	ictc.CostTypeCategory = case when @CostTypeCategory = 'A' then ictc.CostTypeCategory else @CostTypeCategory end

GROUP BY BRD.IdProject, BRD.IdPhase, BRD.IdWorkPackage, BRD.IdCostCenter,
	BRD.YearMonth, GLA.Account, BRD.IdAssociate,BR.ValidationDate


--GET ALL OTHER COSTS
INSERT INTO @tempRevised (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, ValidationDate)

SELECT 	BRDC.IdProject, BRDC.IdPhase, BRDC.IdWorkPackage, BRDC.IdCostCenter,
	BRDC.YearMonth, GLA.Account, BRDC.IdAssociate, 0, ROUND(SUM(BRDC.CostVal),0), BR.ValidationDate

FROM 	BUDGET_REVISED_DETAIL_COSTS BRDC
INNER JOIN BUDGET_REVISED BR 
	ON BR.IdProject = BRDC.IdProject AND
	   BR.IdGeneration = BRDC.IdGeneration
INNER JOIN COST_CENTERS CC 
	ON BRDC.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON BRDC.IdCountry = GLA.IdCountry AND
	   BRDC.IdAccount = GLA.Id
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
	ON BRDC.Idproject = WP.IdProject AND
	   BRDC.IdPhase = WP.IdPhase AND
	   BRDC.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE 	BRDC.IdGeneration = dbo.fnGetRevisedBudgetGeneration(BR.IdProject,'C') AND
	BRDC.CostVal IS NOT NULL AND
	BRDC.YearMonth/100 = @Year AND
	R.Id = CASE WHEN @IdRegion = -1 THEN R.Id ELSE @IdRegion END AND
	C.Id = CASE WHEN @IdCountry = -1 THEN C.Id ELSE @IdCountry END AND
	IL.Id = CASE WHEN @IdInergyLocation = -1 THEN IL.Id ELSE @IdInergyLocation END AND
	F.Id = CASE WHEN @IdFunction = -1 THEN F.Id ELSE @IdFunction END AND
	D.Id = CASE WHEN @IdDepartment = -1 THEN D.Id ELSE @IdDepartment END AND	
	WP.IsActive = CASE	
			WHEN @WPActiveStatus = 'A' THEN 1
			WHEN @WPActiveStatus = 'I' THEN 0
			WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
		      END 
	AND
	ictc.CostTypeCategory = case when @CostTypeCategory = 'A' then ictc.CostTypeCategory else @CostTypeCategory end

GROUP BY BRDC.IdProject, BRDC.IdPhase, BRDC.IdWorkPackage, BRDC.IdCostCenter,
	BRDC.YearMonth, GLA.Account, BRDC.IdAssociate, BR.ValidationDate



SELECT 	P.Code as 					[Project Code],
	P.Name as 					[Project Name],
	PH.Code as 					[Phase Code],
	WP.Code as 					[WP Code],
	WP.Name as					[WP Name],
	WP.Rank as					[WP Rank],
	C.Name as 					[Country Name],
	IL.Name as 					[Inergy Location Name],
	CC.Code as 					[Cost Center Code],
	CC.Name as 					[Cost Center Name],
	D.Name as 					[Department Name],
	F.Name as 					[Function Name],
	A.Name as 					[Employee Name],
	A.EmployeeNumber as 				[Employee Number],
	CIT.Name as 					[Cost Type Name],
	t.AccountNumber as 				[GL Account Number],
	GL.Name as 					[GL Account Description],
	CAST('revised' AS VARCHAR(15)) as		[Extract Category],
	t.YearMonth/100 as				[Year],
	t.YearMonth%100 as 				[Month],
	t.Quantity as					[Quantity],
	t.Value as 					[Value],
	CUR.Code as 					[Currency],
	CAST(dbo.fnGetExchangeRate(@IdCurrencyAssociate,CUR.Id,t.YearMonth) AS DECIMAL(18,4)) AS [Exchange Rate],
	dbo.fnDate2String(t.[ValidationDate]) as	[Date Validation]
	
FROM @tempRevised t
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
INNER JOIN Associates A
	ON t.IdAssociate = A.[Id]
WHERE COALESCE(NULLIF(t.Quantity,0),NULLIF(t.Value,0)) IS NOT NULL
ORDER BY P.Code,  PH.Code, WP.Rank, CC.Code, CIT.Rank, t.YearMonth


GO

