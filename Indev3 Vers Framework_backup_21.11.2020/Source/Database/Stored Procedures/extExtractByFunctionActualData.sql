--Drops the Procedure extExtractByFunctionActualData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractByFunctionActualData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractByFunctionActualData
GO

-- exec extExtractByFunctionActualData 2008,-1,-1,-1,-1,-1,'L'

CREATE PROCEDURE extExtractByFunctionActualData
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


CREATE TABLE #tempActual
(
	IdProject 	INT NOT NULL,
	IdPhase 	INT NOT NULL,
	IdWorkPackage 	INT NOT NULL,
	IdCostCenter 	INT NOT NULL,
	IdAssociate 	INT NOT NULL,
	YearMonth 	INT NOT NULL,
	AccountNumber 	varchar(20) NOT NULL,
	Quantity 	decimal(12,2) NULL,
	Value 		decimal(18,2) NULL

	PRIMARY KEY (IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, AccountNumber) 
)


--GET ALL HOURS RECORDS FROM ACTUAL DATA
INSERT INTO #tempActual (IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate,
		YearMonth, AccountNumber, Quantity, Value)

SELECT  AD.IdProject, AD.IdPhase, AD.IdWorkPackage, Ad.IdCostCenter, AD.IdAssociate,
	AD.YearMonth, GLA.Account,  SUM(AD.HoursQty), SUM(AD.HoursVal)
FROM ACTUAL_DATA_DETAILS_HOURS AD
INNER JOIN ACTUAL_DATA A 
	ON A.IdProject = AD.IdProject
INNER JOIN COST_CENTERS CC 
	ON AD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON AD.IdCountry = GLA.IdCountry AND
	AD.IdAccount = GLA.Id
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
INNER JOIN WORK_PACKAGES WP ON
	AD.Idproject = WP.IdProject AND
	AD.IdPhase = WP.IdPhase AND
	AD.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE 	AD.YearMonth/100 = @Year AND
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

GROUP BY AD.IdProject, AD.IdPhase, AD.IdWorkPackage, Ad.IdCostCenter, AD.IdAssociate,
	AD.YearMonth, GLA.Account

--GET ALL SALES RECORDS FROM ACTUAL DATA

INSERT INTO #tempActual (IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate,
		YearMonth, AccountNumber, Quantity, Value)

SELECT  AD.IdProject, AD.IdPhase, AD.IdWorkPackage, AD.IdCostCenter, AD.IdAssociate,
	AD.YearMonth, GLA.Account, null, SUM(AD.SalesVal)
FROM ACTUAL_DATA_DETAILS_SALES AD
INNER JOIN ACTUAL_DATA A  
	ON A.IdProject = AD.IdProject
INNER JOIN COST_CENTERS CC 
	ON AD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON AD.IdCountry = GLA.IdCountry AND
	   AD.IdAccount = GLA.Id
INNER JOIN INERGY_LOCATIONS IL 
	ON CC.IdInergyLocation = IL.Id
INNER JOIN COUNTRIES C 
	ON IL.IdCountry = C.Id
INNER JOIN REGIONS R 
	ON C.IdRegion = R.Id
INNER JOIN DEPARTMENTS D 
	ON CC.IdDepartment = D.Id
INNER JOIN [FUNCTIONS] F 
	ON D.IdFunction = F.Id
INNER JOIN WORK_PACKAGES WP ON
	AD.Idproject = WP.IdProject AND
	AD.IdPhase = WP.IdPhase AND
	AD.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE 	AD.YearMonth/100 = @Year AND
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
GROUP BY AD.IdProject, AD.IdPhase, AD.IdWorkPackage, AD.IdCostCenter, AD.IdAssociate,
	AD.YearMonth, GLA.Account 

--GET ALL OTHER COSTS
INSERT INTO #tempActual (IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate,
		YearMonth, AccountNumber, Quantity, Value)
SELECT ADDC.IdProject, ADDC.IdPhase, ADDC.IdWorkPackage, ADDC.IdCostCenter, ADDC.IdAssociate,
	ADDC.YearMonth, GLA.Account,  null, SUM(ADDC.CostVal)
FROM ACTUAL_DATA_DETAILS_COSTS ADDC
INNER JOIN ACTUAL_DATA A  
	ON A.IdProject = ADDC.IdProject
INNER JOIN COST_CENTERS CC 
	ON ADDC.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON ADDC.IdCountry = GLA.IdCountry AND
	   ADDC.IdAccount = GLA.Id
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
INNER JOIN WORK_PACKAGES WP ON
	ADDC.Idproject = WP.IdProject AND
	ADDC.IdPhase = WP.IdPhase AND
	ADDC.IdWorkPackage = WP.Id
INNER JOIN #INCOME_COST_TYPES_CATEGORY ictc
	ON GLA.IdCostType = ictc.IdCostType
WHERE   ADDC.YearMonth/100 = @Year AND
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
GROUP BY ADDC.IdProject, ADDC.IdPhase, ADDC.IdWorkPackage, ADDC.IdCostCenter, ADDC.IdAssociate,
	ADDC.YearMonth, GLA.Account

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
	A.Name as 				[Employee Name],
	A.EmployeeNumber as 			[Employee Number],
	CIT.Name as 				[Cost Type Name],
	t.AccountNumber as 			[GL Account Number],
	GL.Name as 				[GL Account Description],
	CAST('actual' AS VARCHAR(15)) as	[Extract Category],
	t.YearMonth/100 as 			[Year],
	t.YearMonth%100 as 			[Month],
	t.Quantity as 				[Quantity],
	t.Value as			 	[Value],
	CUR.Code as 				[Currency],
	--CAST(dbo.fnGetExchangeRate(dbo.fnGetEuroId(),CUR.Id,t.YearMonth)AS DECIMAL(18,2)) AS [Exchange Rate]
	CAST(dbo.fnGetExchangeRate(@IdCurrencyAssociate,CUR.Id,t.YearMonth)AS DECIMAL(18,4)) AS [Exchange Rate]

FROM #tempActual t
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


