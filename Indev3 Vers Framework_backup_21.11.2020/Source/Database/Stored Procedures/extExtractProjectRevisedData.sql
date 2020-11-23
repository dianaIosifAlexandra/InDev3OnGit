--Drops the Procedure extExtractProjectRevisedData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractProjectRevisedData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractProjectRevisedData
GO

--exec extExtractProjectRevisedData 276

CREATE PROCEDURE extExtractProjectRevisedData
(
	@IdProject int,
	@IdGeneration int,
	@WPActiveStatus varchar(1),
	@IdCurrencyAssociate int
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
	Value 		BIGINT,
	ValidationDate	SMALLDATETIME

	PRIMARY KEY (YearMonth, IdProject, IdPhase, IdWorkPackage, IdCostCenter, AccountNumber, IdAssociate)
)


--GET ALL HOURS RECORDS
INSERT INTO @tempRevised (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, ValidationDate)

SELECT  BRD.IdProject, BRD.IdPhase, BRD.IdWorkPackage, BRD.IdCostCenter,
	BRD.YearMonth, GLA.Account, BRD.IdAssociate, 
	ROUND(SUM(BRD.HoursQty),0),
	case when MAX(cast(BR.IsValidated as int))=1 then ROUND(SUM(BRD.HoursVal),0)
		 else ROUND(SUM(dbo.fnGetValuedHours(BRD.IdCostCenter, BRD.HoursQty, BRD.YearMonth)),0) end, 
	BR.ValidationDate
FROM 	BUDGET_REVISED_DETAIL BRD
INNER JOIN BUDGET_REVISED BR ON
	BR.IdProject = BRD.IdProject AND
	BR.IdGeneration = BRD.IdGeneration
INNER JOIN COST_CENTERS CC ON
	BRD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	BRD.IdCountry = GLA.IdCountry AND
	BRD.IdAccountHours = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	BRD.IdProject = WP.IdProject AND
	BRD.IdPhase = WP.IdPhase AND
	BRD.IdWorkPackage = WP.Id
WHERE 	BR.IdGeneration = @IdGeneration and --dbo.fnGetRevisedBudgetGeneration(BR.IdProject,'C') AND
	(BRD.HoursQty IS NOT NULL OR BRD.HoursVal IS NOT NULL) AND
	BR.IdProject = @IdProject and	
	WP.IsActive = CASE	
					WHEN @WPActiveStatus = 'A' THEN 1
					WHEN @WPActiveStatus = 'I' THEN 0
					WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
					END 
GROUP BY BRD.IdProject, BRD.IdPhase, BRD.IdWorkPackage, BRD.IdCostCenter,
	BRD.YearMonth, GLA.Account, BRD.IdAssociate, BR.ValidationDate


--GET ALL SALES RECORD
INSERT INTO @tempRevised (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, ValidationDate)

SELECT  BRD.IdProject, BRD.IdPhase, BRD.IdWorkPackage, BRD.IdCostCenter,
	BRD.YearMonth, GLA.Account, BRD.IdAssociate, 0, ROUND(SUM(BRD.SalesVal),0), BR.ValidationDate
FROM 	BUDGET_REVISED_DETAIL BRD
INNER JOIN BUDGET_REVISED BR ON
	BR.IdProject = BRD.IdProject AND
	BR.IdGeneration = BRD.IdGeneration
INNER JOIN COST_CENTERS CC ON
	BRD.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	BRD.IdCountry = GLA.IdCountry AND
	BRD.IdAccountSales = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	BRD.IdProject = WP.IdProject AND
	BRD.IdPhase = WP.IdPhase AND
	BRD.IdWorkPackage = WP.Id

WHERE 	BR.IdGeneration = @IdGeneration and--dbo.fnGetRevisedBudgetGeneration(BR.IdProject,'C') AND	
	BRD.SalesVal IS NOT NULL AND
	BR.IdProject = @IdProject and	
	WP.IsActive = CASE	
					WHEN @WPActiveStatus = 'A' THEN 1
					WHEN @WPActiveStatus = 'I' THEN 0
					WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
					END 
GROUP BY BRD.IdProject, BRD.IdPhase, BRD.IdWorkPackage, BRD.IdCostCenter,
	BRD.YearMonth, GLA.Account, BRD.IdAssociate, BR.ValidationDate


--GET ALL OTHER COSTS
INSERT INTO @tempRevised (IdProject, IdPhase, IdWorkPackage, IdCostCenter,
		YearMonth, AccountNumber, IdAssociate, Quantity, Value, ValidationDate)

SELECT 	BRDC.IdProject, BRDC.IdPhase, BRDC.IdWorkPackage, BRDC.IdCostCenter,
	BRDC.YearMonth, GLA.Account, BRDC.IdAssociate, 0, ROUND(SUM(BRDC.CostVal),0), BR.ValidationDate

FROM 	BUDGET_REVISED_DETAIL_COSTS BRDC
INNER JOIN BUDGET_REVISED BR ON
	BR.IdProject = BRDC.IdProject AND
	BR.IdGeneration = BRDC.IdGeneration
INNER JOIN COST_CENTERS CC ON
	BRDC.IdCostCenter = CC.Id
INNER JOIN GL_ACCOUNTS GLA ON
	BRDC.IdCountry = GLA.IdCountry AND
	BRDC.IdAccount = GLA.Id
INNER JOIN WORK_PACKAGES WP ON
	BRDC.IdProject = WP.IdProject AND
	BRDC.IdPhase = WP.IdPhase AND
	BRDC.IdWorkPackage = WP.Id
WHERE 	BRDC.IdGeneration = @IdGeneration and--dbo.fnGetRevisedBudgetGeneration(BR.IdProject,'C') AND
	BRDC.CostVal IS NOT NULL AND
	BR.IdProject = @IdProject and	
	WP.IsActive = CASE	
					WHEN @WPActiveStatus = 'A' THEN 1
					WHEN @WPActiveStatus = 'I' THEN 0
					WHEN @WPActiveStatus = 'L' THEN WP.IsActive 
					END 
GROUP BY BRDC.IdProject, BRDC.IdPhase, BRDC.IdWorkPackage, BRDC.IdCostCenter,
	BRDC.YearMonth, GLA.Account, BRDC.IdAssociate, BR.ValidationDate



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
	CAST('revised' AS VARCHAR(15)) as [Extract Category],
	t.YearMonth/100 as		[Year],
	t.YearMonth%100 as 		[Month],
	t.Quantity as			[Quantity],
	t.Value as 			[Value],
	CUR.Code as 			[Currency],
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

