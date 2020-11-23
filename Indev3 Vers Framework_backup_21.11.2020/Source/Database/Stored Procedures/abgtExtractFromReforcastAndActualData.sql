--Drops the Procedure abgtExtractFromReforcastAndActualData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[abgtExtractFromReforcastAndActualData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE abgtExtractFromReforcastAndActualData
GO
--exec abgtExtractFromReforcastAndActualData -1,-1,2008
CREATE PROCEDURE abgtExtractFromReforcastAndActualData
	@IdCountry INT,
	@IdInergyLocation INT,
	@Year DATETIME
AS



DECLARE @temp table
(
	IdExtract INT  IDENTITY (1, 1) NOT NULL,
	IdProject INT,
	IdPhase INT,
	IdWorkPackage INT,
	IdCostCenter INT,
	YearMonth INT,
	AccountNumber varchar(20),
	Quantity decimal (12,2),
	Value decimal(18,2),
	[Date] smalldatetime,
	IdCountry INT
	PRIMARY KEY (IdCountry, YearMonth, IdProject, IdPhase, IdWorkPackage, IdCostCenter, AccountNumber)
)


--GET ALL HOURS RECORDS
INSERT INTO @temp (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, Quantity, Value, [Date], IdCountry)

SELECT  BCD.IdProject, BCD.IdPhase, BCD.IdWorkPackage, BCD.IdCostCenter,
	BCD.YearMonth, GLA.Account, ISNULL(SUM(BCD.HoursQty),0), SUM(BCD.HoursVal), BC.ValidationDate, IL.IdCountry 
FROM 	BUDGET_TOCOMPLETION BC
INNER JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON
	BC.IdProject = BCD.IdProject AND
	BC.IdGeneration = BCD.IdGeneration
INNER JOIN COST_CENTERS CC ON
	BCD.IdCostCenter = CC.Id
INNER JOIN Inergy_Locations IL ON
	IL.Id = CC.IdInergyLocation
INNER JOIN GL_ACCOUNTS GLA ON
	BCD.IdCountry = GLA.IdCountry AND
	BCD.IdAccountHours = GLA.Id
WHERE 	BC.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BC.IdProject,'C') AND
	(BCD.YearMonth/100) = @Year AND
	(BCD.HoursQty IS NOT NULL OR BCD.HoursVal IS NOT NULL) AND
	IL.IdCountry = CASE @IdCountry WHEN -1 THEN IL.IdCountry ELSE @IdCountry END AND
	IL.Id = CASE @IdInergyLocation WHEN -1 THEN IL.Id ELSE @IdInergyLocation END	
GROUP BY BCD.IdProject, BCD.IdPhase, BCD.IdWorkPackage, BCD.IdCostCenter,
	BCD.YearMonth, GLA.Account, BC.ValidationDate, IL.IdCountry


--GET ALL SALES RECORD
INSERT INTO @temp (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, Quantity, Value, [Date], IdCountry)

SELECT  BCD.IdProject, BCD.IdPhase, BCD.IdWorkPackage, BCD.IdCostCenter,
	BCD.YearMonth, GLA.Account, 0, SUM(BCD.SalesVal), BC.ValidationDate, IL.IdCountry 
FROM 	BUDGET_TOCOMPLETION BC 
INNER JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON
	BC.IdProject = BCD.IdProject AND
	BC.IdGeneration = BCD.IdGeneration
INNER JOIN COST_CENTERS CC ON
	BCD.IdCostCenter = CC.Id
INNER JOIN Inergy_Locations IL ON
	IL.Id = CC.IdInergyLocation
INNER JOIN GL_ACCOUNTS GLA ON
	BCD.IdCountry = GLA.IdCountry AND
	BCD.IdAccountSales = GLA.Id
WHERE 	BC.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BC.IdProject,'C') AND
	(BCD.YearMonth / 100) = @Year AND
	BCD.SalesVal IS NOT NULL AND
	IL.IdCountry = CASE @IdCountry WHEN -1 THEN IL.IdCountry ELSE @IdCountry END AND
	IL.Id = CASE @IdInergyLocation WHEN -1 THEN IL.Id ELSE @IdInergyLocation END
GROUP BY BCD.IdProject, BCD.IdPhase, BCD.IdWorkPackage, BCD.IdCostCenter,
	BCD.YearMonth, GLA.Account, BC.ValidationDate, IL.IdCountry


--GET ALL OTHER COSTS
INSERT INTO @temp (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, Quantity, Value, [Date], IdCountry)
SELECT 	BCDC.IdProject, BCDC.IdPhase, BCDC.IdWorkPackage, BCDC.IdCostCenter,
	BCDC.YearMonth, GLA.Account, 0, SUM(BCDC.CostVal), BC.ValidationDate, IL.IdCountry
FROM 	BUDGET_TOCOMPLETION BC
INNER JOIN BUDGET_TOCOMPLETION_DETAIL_COSTS BCDC ON
	BC.IdProject = BCDC.IdProject AND
	BC.IdGeneration = BCDC.IdGeneration
INNER JOIN COST_CENTERS CC ON
	BCDC.IdCostCenter = CC.Id
INNER JOIN Inergy_Locations IL ON
	IL.Id = CC.IdInergyLocation
INNER JOIN GL_ACCOUNTS GLA ON
	BCDC.IdCountry = GLA.IdCountry AND
	BCDC.IdAccount = GLA.Id
WHERE 	BCDC.IdGeneration = dbo.fnGetToCompletionBudgetGeneration(BC.IdProject,'C') AND
	(BCDC.YearMonth / 100) = @Year AND
	BCDC.CostVal IS NOT NULL AND
	IL.IdCountry = CASE @IdCountry WHEN -1 THEN IL.IdCountry ELSE @IdCountry END AND
	IL.Id = CASE @IdInergyLocation WHEN -1 THEN IL.Id ELSE @IdInergyLocation END
GROUP BY BCDC.IdProject, BCDC.IdPhase, BCDC.IdWorkPackage, BCDC.IdCostCenter,
	BCDC.YearMonth, GLA.Account, BC.ValidationDate, IL.IdCountry


DECLARE @actualTemp table
(
	IdExtract INT  IDENTITY (1, 1) NOT NULL,
	IdProject INT,
	IdPhase INT,
	IdWorkPackage INT,
	IdCostCenter INT,
	YearMonth INT,
	AccountNumber varchar(20),
	Quantity decimal(12,2) ,
	Value decimal(18,2),
	[Date] smalldatetime,
	IdCountry INT
 	PRIMARY KEY (IdCountry, YearMonth, IdProject,IdPhase, IdWorkPackage, IdCostCenter, AccountNumber)
)

--GET ALL HOURS RECORDS FROM ACTUAL DATA

INSERT INTO @actualTemp (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, Quantity, Value, [Date], IdCountry)

SELECT  AD.IdProject, AD.IdPhase, AD.IdWorkPackage, Ad.IdCostCenter,
	AD.YearMonth, GLA.Account, ISNULL(SUM(ROUND(AD.HoursQty,0)),0), SUM(AD.HoursVal), A.[Date], IL.IdCountry 
FROM ACTUAL_DATA A
INNER JOIN ACTUAL_DATA_DETAILS_HOURS AD ON
	A.IdProject = AD.IdProject
INNER JOIN COST_CENTERS CC ON
	AD.IdCostCenter = CC.Id
INNER JOIN Inergy_Locations IL ON
	IL.Id = CC.IdInergyLocation
INNER JOIN GL_ACCOUNTS GLA ON
	AD.IdCountry = GLA.IdCountry AND
	AD.IdAccount = GLA.Id
LEFT JOIN BUDGET_TOCOMPLETION BC ON
	A.IdProject = BC.IdProject AND
	dbo.fnGetToCompletionBudgetGeneration(A.IdProject, 'C') = BC.IdGeneration
WHERE 	(AD.YearMonth / 100) = @Year AND
	IL.IdCountry = CASE @IdCountry WHEN -1 THEN IL.IdCountry ELSE @IdCountry END AND
	IL.Id = CASE @IdInergyLocation WHEN -1 THEN IL.Id ELSE @IdInergyLocation END AND
	AD.YearMonth <= ISNULL(BC.YearMonthActualData, 207901)
GROUP BY AD.IdProject, AD.IdPhase, AD.IdWorkPackage, Ad.IdCostCenter,
	AD.YearMonth, GLA.Account, A.[Date], IL.IdCountry 

--GET ALL SALES RECORDS FROM ACTUAL DATA

INSERT INTO @actualTemp (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, Quantity, Value, [Date], IdCountry)

SELECT  AD.IdProject, AD.IdPhase, AD.IdWorkPackage, AD.IdCostCenter,
	AD.YearMonth, GLA.Account, 0, SUM(AD.SalesVal), A.[Date], IL.IdCountry 
FROM ACTUAL_DATA A 
INNER JOIN ACTUAL_DATA_DETAILS_SALES AD ON
	A.IdProject = AD.IdProject
INNER JOIN COST_CENTERS CC ON
	AD.IdCostCenter = CC.Id
INNER JOIN Inergy_Locations IL ON
	IL.Id = CC.IdInergyLocation
INNER JOIN GL_ACCOUNTS GLA ON
	AD.IdCountry = GLA.IdCountry AND
	AD.IdAccount = GLA.Id
LEFT JOIN BUDGET_TOCOMPLETION BC ON
	A.IdProject = BC.IdProject AND
	dbo.fnGetToCompletionBudgetGeneration(A.IdProject, 'C') = BC.IdGeneration
WHERE 	(AD.YearMonth / 100) = @Year AND
	IL.IdCountry = CASE @IdCountry WHEN -1 THEN IL.IdCountry ELSE @IdCountry END AND
	IL.Id = CASE @IdInergyLocation WHEN -1 THEN IL.Id ELSE @IdInergyLocation END AND
	AD.YearMonth <= ISNULL(BC.YearMonthActualData, 207901)
GROUP BY AD.IdProject, AD.IdPhase, AD.IdWorkPackage, AD.IdCostCenter,
	AD.YearMonth, GLA.Account, A.[Date], IL.IdCountry 

--GET ALL OTHER COSTS
INSERT INTO @actualTemp (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, Quantity, Value, [Date], IdCountry)
SELECT ADDC.IdProject, ADDC.IdPhase, ADDC.IdWorkPackage, ADDC.IdCostCenter,
	ADDC.YearMonth, GLA.Account, 0,	SUM(ADDC.CostVal), A.[Date],IL.IdCountry
FROM ACTUAL_DATA A 
INNER JOIN ACTUAL_DATA_DETAILS_COSTS ADDC ON
	A.IdProject = ADDC.IdProject
INNER JOIN COST_CENTERS CC ON
	ADDC.IdCostCenter = CC.Id
INNER JOIN Inergy_Locations IL ON
	IL.Id = CC.IdInergyLocation
INNER JOIN GL_ACCOUNTS GLA ON
	ADDC.IdCountry = GLA.IdCountry AND
	ADDC.IdAccount = GLA.Id
LEFT JOIN BUDGET_TOCOMPLETION BC ON
	A.IdProject = BC.IdProject AND
	dbo.fnGetToCompletionBudgetGeneration(A.IdProject, 'C') = BC.IdGeneration
WHERE 	(ADDC.YearMonth / 100) = @Year AND
	IL.IdCountry = CASE @IdCountry WHEN -1 THEN IL.IdCountry ELSE @IdCountry END AND
	IL.Id = CASE @IdInergyLocation WHEN -1 THEN IL.Id ELSE @IdInergyLocation END AND
	ADDC.YearMonth <= ISNULL(BC.YearMonthActualData, 207901)
GROUP BY ADDC.IdProject, ADDC.IdPhase, ADDC.IdWorkPackage, ADDC.IdCostCenter,
	ADDC.YearMonth, GLA.Account, A.[Date],IL.IdCountry

---------------------------------------------------the special case from issue 29608 is treated here------------------------------------------

DECLARE @tempLinesToRemove table
(
	IdLine		INT  IDENTITY (1, 1),
	IdExtract	INT
)

INSERT INTO @tempLinesToRemove (IdExtract)
SELECT t.IdExtract
FROM @temp t
INNER JOIN BUDGET_TOCOMPLETION BT ON
	t.IdProject = BT.IdProject AND
	dbo.fnGetToCompletionBudgetGeneration(t.IdProject,'C') = BT.IdGeneration
INNER JOIN @actualtemp a ON	--on purpose incomplete join
	t.IdProject 	= a.IdProject AND
	t.IdPhase 	= a.IdPhase AND
	t.IdWorkPackage = a.IdWorkPackage AND
	t.IdCostCenter 	= a.IdCostCenter
WHERE t.YearMonth <= BT.YearMonthActualData

DELETE t
FROM @temp t
INNER JOIN (SELECT IdExtract FROM @tempLinesToRemove GROUP BY IdExtract) tempLines
	ON tempLines.IdExtract = t.IdExtract

--------------------------------------------------------------------------------------------------------------------------------------------


-- delete all multiple keys from reforcast if any and overwrite with data from actual

DELETE t
FROM @temp t INNER JOIN @actualTemp a ON
 	t.IdCountry 	= a.IdCountry AND
	t.YearMonth 	= a.YearMonth AND
	t.IdProject 	= a.IdProject AND
	t.IdPhase 	= a.IdPhase AND
	t.IdWorkPackage = a.IdWorkPackage AND
	t.IdCostCenter 	= a.IdCostCenter AND
	t.AccountNumber = a.AccountNumber


INSERT INTO @temp (IdProject, IdPhase,IdWorkPackage,
		   IdCostCenter, YearMonth, AccountNumber,
		   Quantity, Value, [Date], IdCountry)

SELECT 		 IdProject, IdPhase,IdWorkPackage,
		   IdCostCenter, YearMonth, AccountNumber,
		   Quantity, Value, [Date], IdCountry
FROM @actualTemp


--NOW ALL DATA IS IN @temp table all we need is to get the data set


SELECT  C.Code AS 			[Country Code],
	(t.YearMonth/100) AS 		[Year],
	CC.Code AS 			[Cost Center Code],
	P.Code AS			[Project Code],
	WP.Code as 			[WP Code],
	t.AccountNumber as 		[G/L Account],
	sum(t.Quantity) as		[Quantity],
	sum(t.Value) AS			[Yearly Value],
	MAX(CURR.Code) AS 		[Currency Code],
	dbo.fnDate2String(MAX(t.[Date])) AS [Date of Update],
	MAX(F.NAME) as 			[FunctionName],
	MAX(CC.Name) as 		[Cost Center Name],
	MAX(P.Name) as 			[Project Name],
 	MAX(CIT.Name) as 		[COST Type],
 	MAX(IL.Name) as			[Inergy Location Name]--,
 	--MAX(c.Name) as			[Country Name]

FROM @temp t 
INNER JOIN COUNTRIES C 
	ON t.IdCountry = C.Id
INNER JOIN CURRENCIES CURR
	ON C.IdCurrency = CURR.Id
INNER JOIN COST_CENTERS CC
	ON t.IdCostCenter = CC.Id
INNER JOIN PROJECTS P
	ON t.IdProject = P.Id
INNER JOIN WORK_PACKAGES WP
	ON t.IdProject = WP.IdProject
	AND t.IdPhase = WP.IdPhase
	AND t.IdWorkPackage = WP.Id
INNER join Departments D
	ON CC.IdDepartment=D.ID
INNER JOIN [FUNCTIONS] F
	ON D.IdFunction=F.Id
INNER JOIN INERGY_LOCATIONS IL
 	ON CC.IdInergyLocation=IL.Id
INNER JOIN GL_ACCOUNTS GLA 
 	ON t.IdCountry = GLA.IdCountry AND
 	   t.AccountNumber = GLA.Account
INNER JOIN COST_INCOME_TYPES CIT 
 	ON GLA.IdCostType=CIT.Id
group by C.Code, (t.YearMonth/100), CC.Code, P.Code, WP.Code, t.AccountNumber	

GO

