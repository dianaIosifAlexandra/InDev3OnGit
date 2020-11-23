--Drops the Procedure extExtractProjectAnnualData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractProjectAnnualData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractProjectAnnualData
GO


CREATE PROCEDURE extExtractProjectAnnualData
(
	@IdProject int,
	@Year int,
	@WPActiveStatus varchar(1),
	@IdCurrencyAssociate int
)

AS

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
	ValidationDate smalldatetime

	PRIMARY KEY (YearMonth, IdProject, IdPhase, IdWorkPackage, IdCostCenter, AccountNumber)
)


--GET ALL HOURS RECORDS FROM ACTUAL DATA

INSERT INTO @tempAnnual (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, Quantity, Value, ValidationDate)

SELECT  AD.IdProject, AD.IdPhase, AD.IdWorkPackage, Ad.IdCostCenter,
	AD.YearMonth, GLA.Account, SUM(AD.HoursQty), SUM(AD.HoursVal), AD.DateImport
FROM ANNUAL_BUDGET_DATA_DETAILS_HOURS AD
INNER JOIN  ANNUAL_BUDGET A ON
	A.IdProject = AD.IdProject
INNER JOIN COST_CENTERS CC ON
	AD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	AD.IdCountry = GLA.IdCountry AND
	AD.IdAccount = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	AD.Idproject = WP.IdProject AND
	AD.IdPhase = WP.IdPhase AND
	AD.IdWorkPackage = WP.Id
WHERE 	AD.IdProject = @IdProject
		and AD.YearMonth/100 = @Year and	
	WP.IsActive = CASE	
					WHEN @WPActiveStatus = 'A' THEN 1
					WHEN @WPActiveStatus = 'I' THEN 0
					WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
					END 
GROUP BY AD.IdProject, AD.IdPhase, AD.IdWorkPackage, Ad.IdCostCenter,
	AD.YearMonth, GLA.Account, AD.DateImport

--GET ALL SALES RECORDS FROM ACTUAL DATA

INSERT INTO @tempAnnual (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, Quantity, Value, ValidationDate)

SELECT  AD.IdProject, AD.IdPhase, AD.IdWorkPackage, AD.IdCostCenter,
	AD.YearMonth, GLA.Account, 0, SUM(AD.SalesVal), AD.DateImport
FROM ANNUAL_BUDGET_DATA_DETAILS_SALES AD
INNER JOIN ANNUAL_BUDGET A  ON
	A.IdProject = AD.IdProject
INNER JOIN COST_CENTERS CC ON
	AD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	AD.IdCountry = GLA.IdCountry AND
	AD.IdAccount = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	AD.Idproject = WP.IdProject AND
	AD.IdPhase = WP.IdPhase AND
	AD.IdWorkPackage = WP.Id
WHERE 	AD.IdProject = @IdProject
		and AD.YearMonth/100 = @Year and	
	WP.IsActive = CASE	
					WHEN @WPActiveStatus = 'A' THEN 1
					WHEN @WPActiveStatus = 'I' THEN 0
					WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
					END 
GROUP BY AD.IdProject, AD.IdPhase, AD.IdWorkPackage, AD.IdCostCenter,
	AD.YearMonth, GLA.Account, AD.DateImport

--GET ALL OTHER COSTS
INSERT INTO @tempAnnual (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber,  Quantity, Value, ValidationDate)
SELECT ADDC.IdProject, ADDC.IdPhase, ADDC.IdWorkPackage, ADDC.IdCostCenter,
	ADDC.YearMonth, GLA.Account, 0, SUM(ADDC.CostVal), ADDC.DateImport
FROM ANNUAL_BUDGET_DATA_DETAILS_COSTS ADDC
INNER JOIN ANNUAL_BUDGET A  ON
	A.IdProject = ADDC.IdProject
INNER JOIN COST_CENTERS CC ON
	ADDC.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	ADDC.IdCountry = GLA.IdCountry AND
	ADDC.IdAccount = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	ADDC.Idproject = WP.IdProject AND
	ADDC.IdPhase = WP.IdPhase AND
	ADDC.IdWorkPackage = WP.Id
WHERE   ADDC.IdProject = @IdProject
		and ADDC.YearMonth/100 = @Year and	
	WP.IsActive = CASE	
					WHEN @WPActiveStatus = 'A' THEN 1
					WHEN @WPActiveStatus = 'I' THEN 0
					WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
					END 
GROUP BY ADDC.IdProject, ADDC.IdPhase, ADDC.IdWorkPackage, ADDC.IdCostCenter,
	ADDC.YearMonth, GLA.Account, ADDC.DateImport



SELECT 	P.Code as 			[Project Code],
	P.Name as 			[Project Name],
	PH.Code as 			[Phase Code],
	WP.Code as 			[WP Code],
	WP.Name as			[WP Name],
	WP.Rank as			[WP Rank],
	C.Name as 			[Country Name],
	IL.Name as 			[Inergy Location Name],
	CC.Code as 			[Cost Center Code],
	CC.Name as 			[Cost Center Name],
	D.Name as 			[Department Name],
	F.Name as 			[Function Name],
	CIT.Name as 			[Cost Type Name],
	t.AccountNumber as 		[GL Account Number],
	GL.Name as 			[GL Account Description],
	CAST('annual budget' AS VARCHAR(15)) as  [Extract Category],
	t.YearMonth/100 as 		[Year],
	t.YearMonth%100 as 		[Month],
	t.Quantity as 			[Quantity],
	t.Value as			[Value],
	CUR.Code as 			[Currency],
	CAST(dbo.fnGetAnnualExchangeRate(@IdCurrencyAssociate,CUR.Id,t.YearMonth)AS DECIMAL(18,4)) AS [Exchange Rate],
	dbo.fnDate2String(t.[ValidationDate]) as [Validation Date]

	
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