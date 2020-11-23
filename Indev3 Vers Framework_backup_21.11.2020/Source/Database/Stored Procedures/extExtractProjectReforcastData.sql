--Drops the Procedure extExtractProjectReforcastData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractProjectReforcastData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractProjectReforcastData
GO
-- exec extExtractProjectReforcastData 587
CREATE PROCEDURE extExtractProjectReforcastData
(
	@IdProject int,
	@IdGeneration int,
	@WPActiveStatus varchar(1),
	@IdCurrencyAssociate	INT

)

AS

DECLARE @tempReforcast table
(
	IdExtract 		INT  IDENTITY (1, 1) NOT NULL,
	IdProject 		INT,
	IdPhase 		INT,
	IdWorkPackage 		INT,
	IdCostCenter 		INT,
	YearMonth 		INT,
	AccountNumber 		varchar(20),
	IdAssociate 		INT,
	Quantity 		decimal(12,2),
	Value 			decimal(21,2),
	[Date] 			smalldatetime,
	[Percent]		decimal(18,2),
	ExtractCategoty		varchar(15)

	PRIMARY KEY (YearMonth, IdProject, IdPhase, IdWorkPackage, IdCostCenter, AccountNumber, IdAssociate)
)

	----------Create YearMonth for the previous month taking into account the current month
	DECLARE @YearMonthOfPreviousMonth INT
	Set @YearMonthOfPreviousMonth = dbo.fnGetYearMonthOfPreviousMonth(getdate())


--GET ALL HOURS RECORDS
INSERT INTO @tempReforcast (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, [Date], [Percent], ExtractCategoty)

SELECT  BCD.IdProject, BCD.IdPhase, BCD.IdWorkPackage, BCD.IdCostCenter,
	BCD.YearMonth, GLA.Account, BCD.IdAssociate, 
	SUM(ROUND(BCD.HoursQty,0)), 
	case when MAX(cast(BC.IsValidated as int))=1 then SUM(ROUND(BCD.HoursVal,0))
		 else SUM(dbo.fnGetValuedHours(BCD.IdCostCenter, ROUND(BCD.HoursQty,0), BCD.YearMonth)) end, 
	BC.ValidationDate , BP.[Percent], 'to completion'
FROM 	BUDGET_TOCOMPLETION_DETAIL BCD
LEFT JOIN BUDGET_TOCOMPLETION_PROGRESS BP ON
	BCD.Idproject = BP.IdProject AND
	BCD.IdGeneration = BP.IdGeneration AND
	BCD.IdPhase	= BP.IdPhase AND
	BCD.IdWorkPackage = BP.IdWorkPackage and
	BCD.IdAssociate = BP.IdAssociate
INNER JOIN BUDGET_TOCOMPLETION BC ON
	BC.IdProject = BCD.IdProject AND
	BC.IdGeneration = BCD.IdGeneration
INNER JOIN COST_CENTERS CC ON
	BCD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	BCD.IdCountry = GLA.IdCountry AND
	BCD.IdAccountHours = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	BCD.IdProject = WP.IdProject AND
	BCD.IdPhase = WP.IdPhase AND
	BCD.IdWorkPackage = WP.Id
	
WHERE 	BC.IdGeneration = @IdGeneration and
	(BCD.HoursQty IS NOT NULL OR BCD.HoursVal IS NOT NULL) AND
	BC.IdProject = @IdProject and	
	WP.IsActive = CASE WHEN @WPActiveStatus = 'A' THEN 1
					   WHEN @WPActiveStatus = 'I' THEN 0
					   WHEN @WPActiveStatus = 'L' THEN WP.IsActive END AND
	BCD.YearMonth > case when BC.IsValidated = 1 then ISNULL(BC.YearMonthActualData, 190001)
						 else @YearMonthOfPreviousMonth end
GROUP BY BCD.IdProject, BCD.IdPhase, BCD.IdWorkPackage, BCD.IdCostCenter,
	BCD.YearMonth, GLA.Account,BCD.IdAssociate, BC.ValidationDate, BP.[Percent]


--GET ALL SALES RECORD
INSERT INTO @tempReforcast (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, [Date], [Percent], ExtractCategoty)

SELECT  BCD.IdProject, BCD.IdPhase, BCD.IdWorkPackage, BCD.IdCostCenter,
	BCD.YearMonth, GLA.Account, BCD.IdAssociate, 0, SUM(ROUND(BCD.SalesVal,0)), BC.ValidationDate, BP.[Percent], 'to completion'
FROM 	BUDGET_TOCOMPLETION_DETAIL BCD
LEFT JOIN BUDGET_TOCOMPLETION_PROGRESS BP ON
	BCD.Idproject = BP.IdProject AND
	BCD.IdGeneration = BP.IdGeneration AND
	BCD.IdPhase	= BP.IdPhase AND
	BCD.IdWorkPackage = BP.IdWorkPackage and
	BCD.IdAssociate = BP.IdAssociate
INNER JOIN BUDGET_TOCOMPLETION BC  ON
	BC.IdProject = BCD.IdProject AND
	BC.IdGeneration = BCD.IdGeneration
INNER JOIN COST_CENTERS CC ON
	BCD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	BCD.IdCountry = GLA.IdCountry AND
	BCD.IdAccountSales = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	BCD.IdProject = WP.IdProject AND
	BCD.IdPhase = WP.IdPhase AND
	BCD.IdWorkPackage = WP.Id
WHERE 	BC.IdGeneration = @IdGeneration and 
	BCD.SalesVal IS NOT NULL AND
	BC.IdProject = @IdProject and	
	WP.IsActive = CASE WHEN @WPActiveStatus = 'A' THEN 1
					   WHEN @WPActiveStatus = 'I' THEN 0
					   WHEN @WPActiveStatus = 'L' THEN WP.IsActive END AND
	BCD.YearMonth > case when BC.IsValidated = 1 then ISNULL(BC.YearMonthActualData, 190001)
						 else @YearMonthOfPreviousMonth end
GROUP BY BCD.IdProject, BCD.IdPhase, BCD.IdWorkPackage, BCD.IdCostCenter,
	BCD.YearMonth, GLA.Account, BCD.IdAssociate, BC.ValidationDate, BP.[Percent]


--GET ALL OTHER COSTS
INSERT INTO @tempReforcast (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, [Date], [Percent], ExtractCategoty)
SELECT 	BCDC.IdProject, BCDC.IdPhase, BCDC.IdWorkPackage, BCDC.IdCostCenter,
	BCDC.YearMonth, GLA.Account, BCDC.IdAssociate, 0, SUM(ROUND(BCDC.CostVal,0)), BC.ValidationDate, BP.[Percent], 'to completion'
FROM 	BUDGET_TOCOMPLETION_DETAIL_COSTS BCDC
LEFT JOIN BUDGET_TOCOMPLETION_PROGRESS BP ON
	BCDC.Idproject = BP.IdProject AND
	BCDC.IdGeneration = BP.IdGeneration AND
	BCDC.IdPhase	= BP.IdPhase AND
	BCDC.IdWorkPackage = BP.IdWorkPackage and
	BCDC.IdAssociate = BP.IdAssociate
INNER JOIN  BUDGET_TOCOMPLETION BC ON
	BC.IdProject = BCDC.IdProject AND
	BC.IdGeneration = BCDC.IdGeneration
INNER JOIN COST_CENTERS CC ON
	BCDC.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	BCDC.IdCountry = GLA.IdCountry AND
	BCDC.IdAccount = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	BCDC.IdProject = WP.IdProject AND
	BCDC.IdPhase = WP.IdPhase AND
	BCDC.IdWorkPackage = WP.Id
WHERE 	BCDC.IdGeneration = @IdGeneration and 
	BCDC.CostVal IS NOT NULL AND
	BC.IdProject = @IdProject and	
	WP.IsActive = CASE WHEN @WPActiveStatus = 'A' THEN 1
					   WHEN @WPActiveStatus = 'I' THEN 0
					   WHEN @WPActiveStatus = 'L' THEN WP.IsActive END AND
	BCDC.YearMonth > case when BC.IsValidated = 1 then ISNULL(BC.YearMonthActualData, 190001)
						  else @YearMonthOfPreviousMonth end

GROUP BY BCDC.IdProject, BCDC.IdPhase, BCDC.IdWorkPackage, BCDC.IdCostCenter,
	BCDC.YearMonth, GLA.Account, BCDC.IdAssociate, BC.ValidationDate, BP.[Percent]


DECLARE @actualTemp table
(
	IdExtract 		INT  IDENTITY (1, 1) NOT NULL,
	IdProject 		INT,
	IdPhase 		INT,
	IdWorkPackage 		INT,
	IdCostCenter 		INT,
	YearMonth 		INT,
	AccountNumber 		varchar(20),
	IdAssociate 		INT,
	Quantity 		decimal (12,2),
	Value 			decimal (21,2),
	[Date] 			smalldatetime,
	ExtractCategoty		varchar(15)
 	PRIMARY KEY (YearMonth, IdProject,IdPhase, IdWorkPackage, IdCostCenter, AccountNumber, IdAssociate, ExtractCategoty)
)

--GET ALL HOURS RECORDS FROM ACTUAL DATA

INSERT INTO @actualTemp (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, [Date], ExtractCategoty)

SELECT  AD.IdProject, AD.IdPhase, AD.IdWorkPackage, Ad.IdCostCenter,
	AD.YearMonth, GLA.Account, AD.IdAssociate, SUM(AD.HoursQty), SUM(AD.HoursVal), MAX(IMP.ImportDate), 'actual'
FROM ACTUAL_DATA A
INNER JOIN ACTUAL_DATA_DETAILS_HOURS AD 
	ON	A.IdProject = AD.IdProject
INNER JOIN IMPORTS IMP
	ON  AD.IdImport = IMP.IdImport
INNER JOIN COST_CENTERS CC 
	ON	AD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON	AD.IdCountry = GLA.IdCountry AND
		AD.IdAccount = GLA.Id
INNER JOIN BUDGET_TOCOMPLETION BC 
	ON	A.IdProject = BC.IdProject AND
		@IdGeneration = BC.IdGeneration
INNER JOIN WORK_PACKAGES WP 
	ON	AD.IdProject = WP.IdProject AND
		AD.IdPhase = WP.IdPhase AND
		AD.IdWorkPackage = WP.id
WHERE 	AD.YearMonth <= case when BC.IsValidated = 1 then ISNULL(BC.YearMonthActualData, 190001)
							 else @YearMonthOfPreviousMonth end	AND
	BC.IdProject = @IdProject and	
	WP.IsActive = CASE	WHEN @WPActiveStatus = 'A' THEN 1
					    WHEN @WPActiveStatus = 'I' THEN 0
					    WHEN @WPActiveStatus = 'L' THEN WP.IsActive END 
GROUP BY AD.IdProject, AD.IdPhase, AD.IdWorkPackage, Ad.IdCostCenter,
	AD.YearMonth, GLA.Account, AD.IdAssociate, A.[Date] 

--GET ALL SALES RECORDS FROM ACTUAL DATA

INSERT INTO @actualTemp (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, [Date], ExtractCategoty)

SELECT  AD.IdProject, AD.IdPhase, AD.IdWorkPackage, AD.IdCostCenter,
	AD.YearMonth, GLA.Account, AD.IdAssociate, 0, SUM(AD.SalesVal), MAX(IMP.ImportDate) , 'actual'
FROM ACTUAL_DATA A 
INNER JOIN ACTUAL_DATA_DETAILS_SALES AD 
	ON	A.IdProject = AD.IdProject
INNER JOIN IMPORTS IMP
	ON  AD.IdImport = IMP.IdImport
INNER JOIN COST_CENTERS CC 
	ON	AD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON	AD.IdCountry = GLA.IdCountry AND
		AD.IdAccount = GLA.Id
INNER JOIN BUDGET_TOCOMPLETION BC 
	ON	A.IdProject = BC.IdProject AND
		@IdGeneration = BC.IdGeneration
INNER JOIN WORK_PACKAGES WP 
	ON	AD.IdProject = WP.IdProject AND
		AD.IdPhase = WP.IdPhase AND
		AD.IdWorkPackage = WP.Id
WHERE 	AD.YearMonth <= case when BC.IsValidated = 1 then ISNULL(BC.YearMonthActualData, 190001)
							 else @YearMonthOfPreviousMonth end	AND
	BC.IdProject = @IdProject and	
	WP.IsActive = CASE WHEN @WPActiveStatus = 'A' THEN 1
						WHEN @WPActiveStatus = 'I' THEN 0
						WHEN @WPActiveStatus = 'L' THEN WP.IsActive END 
GROUP BY AD.IdProject, AD.IdPhase, AD.IdWorkPackage, AD.IdCostCenter,
	AD.YearMonth, GLA.Account, AD.IdAssociate, A.[Date]

--GET ALL OTHER COSTS
INSERT INTO @actualTemp (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, [Date], ExtractCategoty)
SELECT ADDC.IdProject, ADDC.IdPhase, ADDC.IdWorkPackage, ADDC.IdCostCenter,
	ADDC.YearMonth, GLA.Account, ADDC.IdAssociate, 0, SUM(ADDC.CostVal), MAX(IMP.ImportDate), 'actual'
FROM ACTUAL_DATA A 
INNER JOIN ACTUAL_DATA_DETAILS_COSTS ADDC ON
	A.IdProject = ADDC.IdProject
INNER JOIN IMPORTS IMP
	ON  ADDC.IdImport = IMP.IdImport
INNER JOIN COST_CENTERS CC 
	ON  ADDC.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON	ADDC.IdCountry = GLA.IdCountry AND
		ADDC.IdAccount = GLA.Id
INNER JOIN BUDGET_TOCOMPLETION BC 
	ON	A.IdProject = BC.IdProject AND
		@IdGeneration = BC.IdGeneration
INNER JOIN WORK_PACKAGES WP 
	ON	ADDC.IdProject = WP.IdProject AND
		ADDC.IdPhase = WP.IdPhase AND
		ADDC.IdWorkPackage = WP.Id
WHERE 	ADDC.YearMonth <= case when BC.IsValidated = 1 then ISNULL(BC.YearMonthActualData, 190001)
							 else @YearMonthOfPreviousMonth end	AND
	BC.IdProject = @IdProject	and	
	WP.IsActive = CASE	WHEN @WPActiveStatus = 'A' THEN 1
						WHEN @WPActiveStatus = 'I' THEN 0
						WHEN @WPActiveStatus = 'L' THEN WP.IsActive END 

GROUP BY ADDC.IdProject, ADDC.IdPhase, ADDC.IdWorkPackage, ADDC.IdCostCenter,
	ADDC.YearMonth, GLA.Account, ADDC.IdAssociate, A.[Date]

--all the records before the yearmonth actual data are comming from actual
--to_completion records are deleted from the extract
DELETE t
FROM @tempReforcast t
INNER JOIN BUDGET_TOCOMPLETION BT ON
	t.IdProject = BT.IdProject AND
	@IdGeneration = BT.IdGeneration
WHERE t.YearMonth <= BT.YearMonthActualData

--------------------------------------------------------------------------------------------------------------------------------------------
-- delete all multiple keys from reforcast if any and overwrite with data from actual

DELETE t
FROM @tempReforcast t 
INNER JOIN @actualTemp a 
ON	t.YearMonth 	= a.YearMonth AND
	t.IdProject 	= a.IdProject AND
	t.IdPhase 		= a.IdPhase AND
	t.IdWorkPackage = a.IdWorkPackage AND
	t.IdCostCenter 	= a.IdCostCenter



INSERT INTO @tempReforcast (IdProject, IdPhase,IdWorkPackage,
		   IdCostCenter, YearMonth, AccountNumber, IdAssociate,
		   Quantity, Value, [Date], ExtractCategoty)

SELECT 	IdProject, IdPhase,IdWorkPackage,
		IdCostCenter, YearMonth, AccountNumber, IdAssociate,
		Quantity, Value, [Date], ExtractCategoty
FROM @actualTemp



SELECT 	P.Code as 			[Project Code],
	P.Name as 			[Project Name],	
	PH.Code as 			[Phase Code],
	WP.Code as 			[WP Code],
	WP.Name as			[WP Name],
	WP.Rank as			[WP Rank],
	C.Name 	as 			[Country Name],
	IL.Name as 			[Inergy Location Name],
	CC.Code as 			[Cost Center Code],
	CC.Name as			[Cost Center Name],
	D.Name as 			[Department Name],
	F.Name as 			[Function Name],
	A.Name as 			[Employee Name],
	A.EmployeeNumber as 		[Employee Number],
	CIT.Name as 			[Cost Type Name],
	t.AccountNumber as 		[GL Account Number],
	GL.Name as 			[GL Account Description],
	ExtractCategoty	as		[Extract Category],
	t.YearMonth/100 as 		[Year],
	t.YearMonth%100 as 		[Month],
	t.Quantity as 			[Quantity],
	t.Value as			[Value],
	CUR.Code as 			[Currency],
	CAST(dbo.fnGetExchangeRate(@IdCurrencyAssociate,CUR.Id,t.YearMonth)AS DECIMAL(18,4)) AS [Exchange Rate],
	dbo.fnDate2String(t.[Date]) as	[Validation Date],
	t.[Percent] as [Percent]
FROM @tempReforcast t
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
ORDER BY t.ExtractCategoty, P.Code,  PH.Code, WP.Rank, CC.Code, CIT.Rank, t.YearMonth

GO

