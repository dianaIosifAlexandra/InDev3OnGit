--Drops the Procedure extExtractProjectActualData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractProjectActualData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractProjectActualData
GO


CREATE PROCEDURE extExtractProjectActualData
(
	@IdProject int,
	@WPActiveStatus varchar(1),
	@IdCurrencyAssociate int
)

AS

DECLARE @tempActual table
(
	IdExtract 	INT  IDENTITY (1, 1) NOT NULL,
	IdProject 	INT,
	IdPhase 	INT,
	IdWorkPackage 	INT,
	IdCostCenter 	INT,
	YearMonth 	INT,
	AccountNumber 	varchar(20),
	IdAssociate 	int,
	Quantity 	decimal(12,2),
	Value 		decimal(18,2),
	ValidationDate smalldatetime

	PRIMARY KEY (YearMonth, IdProject, IdPhase, IdWorkPackage, IdCostCenter, AccountNumber, IdAssociate)
)


--GET ALL HOURS RECORDS FROM ACTUAL DATA

INSERT INTO @tempActual (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, ValidationDate)

SELECT  AD.IdProject, AD.IdPhase, AD.IdWorkPackage, Ad.IdCostCenter,
	AD.YearMonth, GLA.Account, AD.IdAssociate, SUM(AD.HoursQty), SUM(AD.HoursVal), MAX(IMP.ImportDate)
FROM ACTUAL_DATA_DETAILS_HOURS AD
INNER JOIN IMPORTS IMP
	ON AD.IdImport = IMP.IdImport
INNER JOIN  ACTUAL_DATA A 
	ON	A.IdProject = AD.IdProject
INNER JOIN COST_CENTERS CC 
	ON	AD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA 
	ON	AD.IdCountry = GLA.IdCountry AND
		AD.IdAccount = GLA.Id
INNER JOIN WORK_PACKAGES WP 
	ON	AD.Idproject = WP.IdProject AND
		AD.IdPhase = WP.IdPhase AND
		AD.IdWorkPackage = WP.Id
WHERE 	AD.IdProject = @IdProject and	
		WP.IsActive = CASE	WHEN @WPActiveStatus = 'A' THEN 1
							WHEN @WPActiveStatus = 'I' THEN 0
							WHEN @WPActiveStatus = 'L' THEN WP.IsActive END 
GROUP BY AD.IdProject, AD.IdPhase, AD.IdWorkPackage, Ad.IdCostCenter,
	AD.YearMonth, GLA.Account, AD.IdAssociate, AD.DateImport

--GET ALL SALES RECORDS FROM ACTUAL DATA

INSERT INTO @tempActual (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, ValidationDate)

SELECT  AD.IdProject, AD.IdPhase, AD.IdWorkPackage, AD.IdCostCenter,
	AD.YearMonth, GLA.Account, AD.IdAssociate, 0, SUM(AD.SalesVal), MAX(IMP.ImportDate)
FROM ACTUAL_DATA_DETAILS_SALES AD
INNER JOIN IMPORTS IMP
	ON AD.IdImport = IMP.IdImport
INNER JOIN ACTUAL_DATA A  ON
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
WHERE 	AD.IdProject = @IdProject and	
	WP.IsActive = CASE	
					WHEN @WPActiveStatus = 'A' THEN 1
					WHEN @WPActiveStatus = 'I' THEN 0
					WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
					END 
GROUP BY AD.IdProject, AD.IdPhase, AD.IdWorkPackage, AD.IdCostCenter,
	AD.YearMonth, GLA.Account, AD.IdAssociate, AD.DateImport

--GET ALL OTHER COSTS
INSERT INTO @tempActual (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate,  Quantity, Value, ValidationDate)
SELECT ADDC.IdProject, ADDC.IdPhase, ADDC.IdWorkPackage, ADDC.IdCostCenter,
	ADDC.YearMonth, GLA.Account, ADDC.IdAssociate, 0, SUM(ADDC.CostVal), MAX(IMP.ImportDate)
FROM ACTUAL_DATA_DETAILS_COSTS ADDC
INNER JOIN IMPORTS IMP
	ON ADDC.IdImport = IMP.IdImport
INNER JOIN ACTUAL_DATA A  ON
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
WHERE   ADDC.IdProject = @IdProject and	
	WP.IsActive = CASE	
					WHEN @WPActiveStatus = 'A' THEN 1
					WHEN @WPActiveStatus = 'I' THEN 0
					WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
					END 
GROUP BY ADDC.IdProject, ADDC.IdPhase, ADDC.IdWorkPackage, ADDC.IdCostCenter,
	ADDC.YearMonth, GLA.Account, ADDC.IdAssociate, ADDC.DateImport


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
	A.Name as 			[Employee Name],
	A.EmployeeNumber as 		[Employee Number],
	CIT.Name as 			[Cost Type Name],
	t.AccountNumber as 		[GL Account Number],
	GL.Name as 			[GL Account Description],
	CAST('actual' AS VARCHAR(15)) as [Extract Category],
	t.YearMonth/100 as 		[Year],
	t.YearMonth%100 as 		[Month],
	t.Quantity as 			[Quantity],
	t.Value as			[Value],
	CUR.Code as 			[Currency],
	CAST(dbo.fnGetExchangeRate(@IdCurrencyAssociate,CUR.Id,t.YearMonth)AS DECIMAL(18,4)) AS [Exchange Rate],
	dbo.fnDate2String(t.[ValidationDate]) as [Validation Date]

	
FROM @tempActual t
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


