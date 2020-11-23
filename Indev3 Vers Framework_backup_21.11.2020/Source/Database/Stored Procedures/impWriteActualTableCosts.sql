--Drops the Procedure impWriteActualTableCosts if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteActualTableCosts]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteActualTableCosts
GO

CREATE     PROCEDURE impWriteActualTableCosts
@IdImport INT			-- ID of the import
	
AS

Declare @YearMonth int,
	@strError varchar(255)

SELECT @YearMonth = IL.YearMonth
FROM IMPORT_LOGS IL
WHERE IL.IdImport = @IdImport

IF (@YearMonth IS NULL) 
BEGIN
	SET @strError = 'Import with id '+ cast(@IdImport as varchar(10)) +' does not exists in the database.'
	RAISERROR(@strError, 16, 1)
	return -1
END

--prepare the null associates table per country
DECLARE @CountryCode varchar (3)
DECLARE @NULLASSOCIATES TABLE
(
	CountryCode		varchar(3)  NOT NULL,
	NullAssociateId		int 	    NULL,
	NullEmployeeNumber	varchar(15) NULL
)

INSERT INTO @NULLASSOCIATES
	(CountryCode, NullAssociateId, NullEmployeeNumber)
SELECT Country,
       dbo.fnGetNullAssociateId(Country),
       null
FROM IMPORT_DETAILS
WHERE IdImport = @IdImport
GROUP BY Country

SELECT TOP 1 @CountryCode = CountryCode
FROM @NULLASSOCIATES
where NullAssociateId is null

IF (@CountryCode IS NOT NULL)
BEGIN
	RAISERROR('No null associate found for country %s.', 16, 1, @COUNTRYCODE)
	RETURN -1
END

UPDATE @NULLASSOCIATES
SET NullEmployeeNumber = EmployeeNumber
FROM @NULLASSOCIATES
INNER JOIN ASSOCIATES A
	ON NullAssociateId = A.Id



INSERT INTO [ACTUAL_DATA_DETAILS_COSTS]
(
	[IdProject], [IdPhase], [IdWorkPackage], [IdCostCenter]
	, [YearMonth], [IdAssociate], [IdCostType], [IdCountry]
	, [CostVal], [IdAccount], [DateImport], [IdImport]
)
SELECT
	WP.IdProject ,WP.IdPhase ,WP.Id ,CC.Id
	,@YearMonth ,A.Id ,dbo.fnGetBudgetCostType(C.Id,IMD.AccountNumber) 
	,C.Id
	,ISNULL(IMD.Value,0) - ISNULL((SELECT SUM(ISNULL(ADC.CostVal,0))
				      FROM ACTUAL_DATA_DETAILS_COSTS ADC 
				      WHERE ADC.IdProject = WP.IdProject AND
					    ADC.IdPhase = WP.IdPhase AND
					    ADC.IdWorkPackage =WP.Id AND
					    ADC.IdCostCenter = CC.Id  AND
					    ADC.YearMonth/100 = @YearMonth/100 AND -- check only year
					    ADC.IdAssociate = A.Id AND
					    ADC.IdCountry = C.Id AND
					    ADC.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)),0)
	,dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)
	,IMD.[Date]
	,@IdImport
FROM IMPORT_DETAILS IMD
INNER JOIN PROJECTS P 
	ON IMD.ProjectCode = P.Code
INNER JOIN WORK_PACKAGES WP 
	ON P.ID = WP.IdProject AND
	IMD.WPCode = WP.Code
INNER JOIN COUNTRIES C
	ON IMD.Country = C.Code
INNER JOIN INERGY_LOCATIONS IL
	ON C.Id = IL.IdCountry
INNER JOIN COST_CENTERS CC 
	ON IL.Id = CC.IdInergyLocation and
	   IMD.CostCenter = CC.Code
INNER JOIN ASSOCIATES A
	ON C.Id = A.IdCountry AND
	   IMD.AssociateNumber = A.EmployeeNumber
WHERE   dbo.fnGetBudgetCostType(C.Id,IMD.AccountNumber) BETWEEN 1 AND 5 AND		       
	IMD.IdImport = @IdImport AND
	IMD.AssociateNumber IS NOT NULL


DECLARE @IMPORT_NULL_ASSOCIATES TABLE
(
	Country VARCHAR(3),
	CostCenter VARCHAR(10),
	ProjectCode VARCHAR(10),
	WPCode VARCHAR(4),
	AccountNumber NVARCHAR(10),
	AssociateNumber VARCHAR(15),
	Quantity DECIMAL(18,2),
	UnitQty VARCHAR(4),
	[Value] DECIMAL(18,2),
	CurrencyCode VARCHAR(3),
	[Date] SMALLDATETIME
)

INSERT INTO @IMPORT_NULL_ASSOCIATES
(Country, CostCenter, ProjectCode, 
WPCode,AccountNumber, AssociateNumber, Quantity, UnitQty,
[Value], CurrencyCode, [Date])
SELECT 	IMD.Country,
	IMD.CostCenter,
	IMD.ProjectCode,
	IMD.WPCode,
	IMD.AccountNumber,
	MAX(NA.NullEmployeeNumber),
	SUM(IMD.Quantity),
	MAX(ISNULL(IMD.UnitQty,'')),
	SUM(IMD.Value),
	MAX(IMD.CurrencyCode),
	MAX(IMD.[Date])
FROM IMPORT_DETAILS IMD
INNER JOIN COUNTRIES C
	ON IMD.Country = C.Code
INNER JOIN @NULLASSOCIATES NA
	ON IMD.Country = NA.CountryCode
WHERE   IMD.IdImport = @IdImport AND
	dbo.fnGetBudgetCostType(C.Id,IMD.AccountNumber) BETWEEN 1 AND 5 AND
	IMD.AssociateNumber IS NULL--take only records that doesn't have valid associate ids
GROUP BY IMD.Country,
	IMD.CostCenter,
	IMD.ProjectCode,
	IMD.WPCode,
	IMD.AccountNumber


INSERT INTO [ACTUAL_DATA_DETAILS_COSTS]
(
	[IdProject], [IdPhase], [IdWorkPackage], [IdCostCenter]
	, [YearMonth], [IdAssociate], [IdCostType], [IdCountry]
	, [CostVal], [IdAccount], [DateImport], [IdImport]
)
SELECT
	WP.IdProject ,WP.IdPhase ,WP.Id ,CC.Id
	,@YearMonth ,A.Id ,dbo.fnGetBudgetCostType(C.Id,IMD.AccountNumber) 
	,C.Id
	,ISNULL(IMD.Value,0) - ISNULL((SELECT SUM(ISNULL(ADC.CostVal,0))
					FROM ACTUAL_DATA_DETAILS_COSTS ADC 
					WHERE ADC.IdProject = WP.IdProject AND
					      ADC.IdPhase = WP.IdPhase AND
					      ADC.IdWorkPackage =WP.Id AND
					      ADC.IdCostCenter = CC.Id  AND
					      ADC.YearMonth/100  = @YearMonth/100 AND -- check only year 
					      ADC.IdAssociate = A.Id AND
					      ADC.IdCountry = C.Id AND
					      ADC.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)),0)
		
	,dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)
	,ISNULL(IMD.[Date], GETDATE())
	,@IdImport
FROM @IMPORT_NULL_ASSOCIATES IMD
INNER JOIN Projects P 
	ON IMD.ProjectCode = P.Code
INNER JOIN WORK_PACKAGES WP 
	ON P.ID = WP.IdProject AND
	IMD.WPCode = WP.Code
INNER JOIN COUNTRIES C
	ON IMD.Country = C.Code
INNER JOIN INERGY_LOCATIONS IL
	ON C.Id = IL.IdCountry
INNER JOIN COST_CENTERS CC 
	ON IL.Id = CC.IdInergyLocation and
	   IMD.CostCenter = CC.Code
INNER JOIN ASSOCIATES A
	ON C.Id = A.IdCountry AND
	   IMD.AssociateNumber = A.EmployeeNumber



-- delete the rows that obtained 0 by calculating MTD from YTD
-- these rows have value not null for previous periods of the same year
DELETE A
FROM ACTUAL_DATA_DETAILS_COSTS A
WHERE IdImport = @IdImport and
	  CostVal = 0 AND
      (SELECT SUM(CostVal)
	  FROM ACTUAL_DATA_DETAILS_COSTS
	  WHERE IdProject = A.IdProject AND 
			  IdPhase = A.IdPhase AND 
			  IdWorkPackage = A.IdWorkPackage AND
			  IdCostCenter = A.IdCostCenter AND
			  IdAssociate = A.IdAssociate AND
			  IdCountry = A.IdCountry AND
			  IdAccount = A.IdAccount AND
			  YearMonth/100 = A.YearMonth/100 AND
			  YearMonth < A.YearMonth) IS NOT NULL


GO


