
--Drops the Procedure extExtractProjectInitialData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractProjectInitialData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractProjectInitialData
GO


CREATE PROCEDURE extExtractProjectInitialData
(
	@IdProject int,
	@WPActiveStatus varchar(1),
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
	Value 		BIGINT,
	ValidationDate	SMALLDATETIME

	PRIMARY KEY (YearMonth, IdProject, IdPhase, IdWorkPackage, IdCostCenter, AccountNumber, IdAssociate)
)


--GET ALL HOURS RECORDS
INSERT INTO @tempInitial (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, ValidationDate)
SELECT  BID.IdProject, BID.IdPhase, BID.IdWorkPackage, BID.IdCostCenter,
	BID.YearMonth, GLA.Account, BID.IdAssociate, ROUND(SUM(BID.HoursQty),0), ROUND(SUM(BID.HoursVal),0), BI.ValidationDate
FROM BUDGET_INITIAL_DETAIL BID
INNER JOIN BUDGET_INITIAL BI
	ON BI.IdProject = BID.IdProject
INNER JOIN COST_CENTERS CC ON
	BID.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	BID.IdCountry = GLA.IdCountry AND
	BID.IdAccountHours = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	BID.IdProject = WP.IdProject AND
	BID.IdPhase = WP.IdPhase and
	BID.IdWorkPackage = WP.Id
WHERE (BID.HoursQty IS NOT NULL OR BID.HoursVal IS NOT NULL) AND
	BI.IdProject = @IdProject and	
	WP.IsActive = CASE	
					WHEN @WPActiveStatus = 'A' THEN 1
					WHEN @WPActiveStatus = 'I' THEN 0
					WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
					END 
GROUP BY BID.IdProject, BID.IdPhase, BID.IdWorkPackage, BID.IdCostCenter,
	BID.YearMonth, GLA.Account, BID.IdAssociate, BI.ValidationDate


--GET ALL SALES RECORD
INSERT INTO @tempInitial (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate,Quantity, Value, ValidationDate)

SELECT  BID.IdProject, BID.IdPhase, BID.IdWorkPackage, BID.IdCostCenter,
	BID.YearMonth, GLA.Account, BID.IdAssociate, 0, ROUND(SUM(BID.SalesVal),0), BI.ValidationDate
FROM 	BUDGET_INITIAL_DETAIL BID
INNER JOIN BUDGET_INITIAL BI ON
	BI.IdProject = BID.IdProject
INNER JOIN COST_CENTERS CC ON
	BID.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	BID.IdCountry = GLA.IdCountry AND
	BID.IdAccountSales = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	BID.IdProject = WP.IdProject AND
	BID.IdPhase = WP.IdPhase and
	BID.IdWorkPackage = WP.Id
WHERE	BID.SalesVal IS NOT NULL AND
	BI.IdProject = @IdProject and	
	WP.IsActive = CASE	
					WHEN @WPActiveStatus = 'A' THEN 1
					WHEN @WPActiveStatus = 'I' THEN 0
					WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
					END 
GROUP BY BID.IdProject, BID.IdPhase, BID.IdWorkPackage, BID.IdCostCenter,
	BID.YearMonth, GLA.Account, BID.IdAssociate, BI.ValidationDate


--GET ALL OTHER COSTS
INSERT INTO @tempInitial (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, ValidationDate)

SELECT 	BIDC.IdProject, BIDC.IdPhase, BIDC.IdWorkPackage, BIDC.IdCostCenter,
	BIDC.YearMonth, GLA.Account, BIDC.IdAssociate,0, ROUND(SUM(BIDC.CostVal),0), BI.ValidationDate

FROM 	BUDGET_INITIAL_DETAIL_COSTS BIDC
INNER JOIN BUDGET_INITIAL BI ON
	BI.IdProject = BIDC.IdProject
INNER JOIN COST_CENTERS CC ON
	BIDC.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	BIDC.IdCountry = GLA.IdCountry AND
	BIDC.IdAccount = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	BIDC.IdProject = WP.IdProject AND
	BIDC.IdPhase = WP.IdPhase and
	BIDC.IdWorkPackage = WP.Id
WHERE   BIDC.CostVal IS NOT NULL AND
	BI.IdProject = @IdProject and	
	WP.IsActive = CASE	
					WHEN @WPActiveStatus = 'A' THEN 1
					WHEN @WPActiveStatus = 'I' THEN 0
					WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
					END 
GROUP BY BIDC.IdProject, BIDC.IdPhase, BIDC.IdWorkPackage, BIDC.IdCostCenter,
	BIDC.YearMonth, GLA.Account, BIDC.IdAssociate, BI.ValidationDate


SELECT 	P.Code as 			[Project Code],
	P.Name as			[Project Name],
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
	CAST('initial' AS VARCHAR(15)) as [Extract Category],
	t.YearMonth/100 as 		[Year],
	t.YearMonth%100 as 		[Month],
	t.Quantity as			[Quantity],
	t.Value as 			[Value],
	CUR.Code as 			[Currency],
	CAST(dbo.fnGetExchangeRate(@IdCurrencyAssociate,CUR.Id,t.YearMonth) AS DECIMAL(18,4)) AS [Exchange Rate],
	dbo.fnDate2String(t.[ValidationDate]) as [Validation Date]
	
FROM @tempInitial t
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


