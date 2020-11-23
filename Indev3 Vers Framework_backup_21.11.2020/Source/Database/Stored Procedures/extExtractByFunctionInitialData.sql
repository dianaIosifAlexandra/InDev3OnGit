
--Drops the Procedure extExtractByFunctionInitialData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractByFunctionInitialData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractByFunctionInitialData
GO

-- exec extExtractByFunctionInitialData 2008,-1,-1,-1,-1,-1,'L'

CREATE PROCEDURE extExtractByFunctionInitialData
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

DECLARE @tempInitial table
(
	IdExtract 	INT  IDENTITY (1, 1) NOT NULL,
	IdProject 	INT,
	IdPhase 	INT,
	IdWorkPackage 	INT,
	IdCostCenter 	INT,
	YearMonth 	INT,
	AccountNumber 	varchar(20),
	IdAssociate 	int,
	Quantity 	INT,
	Value 		bigint

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
INSERT INTO @tempInitial (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value)
SELECT  BID.IdProject, BID.IdPhase, BID.IdWorkPackage, BID.IdCostCenter,
	BID.YearMonth, GLA.Account, BID.IdAssociate, ROUND(SUM(BID.HoursQty),0), ROUND(SUM(BID.HoursVal),0)
FROM BUDGET_INITIAL_DETAIL BID
INNER JOIN BUDGET_INITIAL BI
	ON BI.IdProject = BID.IdProject
INNER JOIN COST_CENTERS CC 
	ON BID.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON BID.IdCountry = GLA.IdCountry AND
  	   BID.IdAccountHours = GLA.Id
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
	ON BID.Idproject = WP.IdProject AND
	   BID.IdPhase = WP.IdPhase AND
	   BID.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE 	(BID.HoursQty IS NOT NULL OR BID.HoursVal IS NOT NULL) AND
	BID.YearMonth/100 = @Year AND
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

GROUP BY BID.IdProject, BID.IdPhase, BID.IdWorkPackage, BID.IdCostCenter,
	BID.YearMonth, GLA.Account, BID.IdAssociate


--GET ALL SALES RECORD
INSERT INTO @tempInitial (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate,Quantity, Value)

SELECT  BID.IdProject, BID.IdPhase, BID.IdWorkPackage, BID.IdCostCenter,
	BID.YearMonth, GLA.Account, BID.IdAssociate, 0, ROUND(SUM(BID.SalesVal),0)
FROM 	BUDGET_INITIAL_DETAIL BID
INNER JOIN BUDGET_INITIAL BI
	ON BI.IdProject = BID.IdProject
INNER JOIN COST_CENTERS CC 
	ON BID.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON BID.IdCountry = GLA.IdCountry AND
	   BID.IdAccountSales = GLA.Id
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
	ON BID.Idproject = WP.IdProject AND
	   BID.IdPhase = WP.IdPhase AND
	   BID.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE	BID.SalesVal IS NOT NULL AND
	BID.YearMonth/100 = @Year AND
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

GROUP BY BID.IdProject, BID.IdPhase, BID.IdWorkPackage, BID.IdCostCenter,
	BID.YearMonth, GLA.Account, BID.IdAssociate


--GET ALL OTHER COSTS
INSERT INTO @tempInitial (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value)

SELECT 	BIDC.IdProject, BIDC.IdPhase, BIDC.IdWorkPackage, BIDC.IdCostCenter,
	BIDC.YearMonth, GLA.Account, BIDC.IdAssociate,0, ROUND(SUM(BIDC.CostVal),0)

FROM 	BUDGET_INITIAL_DETAIL_COSTS BIDC
INNER JOIN BUDGET_INITIAL BI
	ON BI.IdProject = BIDC.IdProject
INNER JOIN COST_CENTERS CC 
	ON BIDC.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON BIDC.IdCountry = GLA.IdCountry AND
	   BIDC.IdAccount = GLA.Id
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
	ON BIDC.Idproject = WP.IdProject AND
	   BIDC.IdPhase = WP.IdPhase AND
	   BIDC.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE   BIDC.CostVal IS NOT NULL AND
	BIDC.YearMonth/100 = @Year AND
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

GROUP BY BIDC.IdProject, BIDC.IdPhase, BIDC.IdWorkPackage, BIDC.IdCostCenter,
	BIDC.YearMonth, GLA.Account, BIDC.IdAssociate


SELECT 	P.Code as 					[Project Code],
	P.Name as					[Project Name],
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
	CAST('initial' AS VARCHAR(15)) as		[Extract Category],
	t.YearMonth/100 as 				[Year],
	t.YearMonth%100 as 				[Month],
	t.Quantity as					[Quantity],
	t.Value as 					[Value],
	CUR.Code as 					[Currency],
	CAST(dbo.fnGetExchangeRate(@IdCurrencyAssociate,CUR.Id,t.YearMonth) AS DECIMAL(18,4)) AS [Exchange Rate],
	dbo.fnDate2String(BI.ValidationDate) as		[Validation Date]
	
FROM @tempInitial t
INNER JOIN BUDGET_INITIAL BI
	ON BI.IdProject = T.IdProject
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
INNER JOIN ASSOCIATES A
	ON t.IdAssociate = A.Id
WHERE COALESCE(NULLIF(t.Quantity,0),NULLIF(t.Value,0)) IS NOT NULL
ORDER BY P.Code,  PH.Code, WP.Rank, CC.Code, CIT.Rank, t.YearMonth


GO


