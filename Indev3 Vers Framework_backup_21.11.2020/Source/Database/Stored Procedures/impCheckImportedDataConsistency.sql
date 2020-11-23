IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impCheckImportedDataConsistency]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impCheckImportedDataConsistency
GO

--impCheckImportedDataConsistency 12
--impCheckImportedDataConsistency 10
CREATE PROCEDURE impCheckImportedDataConsistency
	@IdImport 	INT --ID of the import
AS	
BEGIN

Declare @IdSource int,
	@YearMonth int,
	@strError varchar(255),
	@hasKRMError bit,
	@KRMDiff int -- difference of key rows missing found in total

SET @hasKRMError = 0
SET @KRMDiff = 0

SELECT @IdSource = IL.IdSource,
	@YearMonth = IL.YearMonth
FROM IMPORT_LOGS IL
WHERE IL.IdImport = @IdImport

IF (@IdSource IS NULL) 
BEGIN
	SET @strError = 'Import with id '+ cast(@IdImport as varchar(10)) +' does not exists in the database.'
	RAISERROR(@strError, 16, 1)
	return -1
END


--prepare the null associates table per country
DECLARE @CountryCode varchar (3)
DECLARE @NULLASSOCIATES TABLE
(
	CountryCode		varchar(3),
	NullAssociateId		int,
	NullEmployeeNumber	varchar(15)
)

DECLARE @ACTUALCUMULATED TABLE
(
	IdProject		INT, 
        IdPhase			INT,
        IdWorkPackage		INT,
        IdCostCenter		INT, 
        IdAssociate		INT, 
        IdCountry		INT, 
	IdAccount		INT,
	ProjectCode		varchar(10),
	WPCode			varchar(3),
	CostCenter		varchar(15),
	AccountNumber		varchar(20),
	AssociateNumber		varchar(15),
	Country			varchar(3),
	Quantity		decimal(12,2),
	Value			decimal(18,2)

	PRIMARY KEY (IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCountry, IdAccount)
)

DECLARE @IMPORT_YTD TABLE
(
	ProjectCode		varchar(10),
	WPCode			varchar(3),
	CostCenter		varchar(15),
	AssociateNumber		varchar(15),
	Country			varchar(3),
	AccountNumber		varchar(20),
	Quantity		decimal(12,2),
	Value			decimal(18,2)

	PRIMARY KEY (ProjectCode, WPCode, CostCenter, AssociateNumber, Country, AccountNumber)
)


--read the cost type account
DECLARE @IdCostTypeHours INT
DECLARE @IdCostTypeSales INT
SELECT @IdCostTypeHours = dbo.fnGetHoursCostTypeID()
SELECT @IdCostTypeSales = dbo.fnGetSalesCostTypeID()

-- we will use this associate number TEMPORARY (in order to avoid NULL whcih cannot be part of a PK in a table) CCP = check consistency procedure
DECLARE @NULLTempAssociateNumber varchar(15)
SET @NULLTempAssociateNumber = 'CCP________' 

--read the null asscoiates for all the countries involved in an import
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
	RETURN -2
END

UPDATE @NULLASSOCIATES
SET NullEmployeeNumber = EmployeeNumber
FROM @NULLASSOCIATES
INNER JOIN ASSOCIATES A
	ON NullAssociateId = A.Id

---
DECLARE @Application_Type_Name NVARCHAR(3)
SELECT @Application_Type_Name = [NAME] 
FROM IMPORT_APPLICATION_TYPES IAT
INNER JOIN IMPORT_SOURCES [IS]
	ON IAT.Id = [IS].IdApplicationTypes
WHERE [IS].Id = @IdSource


--A. Check the HoursQty and HoursVal
INSERT INTO @ACTUALCUMULATED
	(IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCountry, IdAccount, 
	ProjectCode, WPCode, CostCenter, AccountNumber, AssociateNumber,Country, 
	Quantity, Value)
SELECT ADH.IdProject, ADH.IdPhase, ADH.IdWorkPackage, ADH.IdCostCenter, ADH.IdAssociate, ADH.IdCountry, ADH.IdAccount, 
	NULL, NULL, NULL, NULL, NULL, NULL,
	SUM (ADH.HoursQty), SUM (ADH.HoursVal)
FROM ACTUAL_DATA_DETAILS_HOURS ADH
INNER JOIN IMPORT_LOGS IL
	ON ADH.IdImport = IL.IdImport
WHERE IL.IdSource = @IdSource AND                -- same source
      IL.YearMonth/100 = @YearMonth/100 and      -- same year
      IL.YearMonth % 100 <= @YearMonth % 100 and -- only the previous and current months
      IL.Validation = 'G'                        -- only the succeeded imports
GROUP BY IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCountry, IdAccount 

UPDATE A
SET A.ProjectCode = P.Code,
    A.WPCode = WP.Code,
    A.CostCenter = CC.Code,
    A.AssociateNumber = ASOC.EmployeeNumber,
    A.Country = C.Code,
    A.AccountNumber = GL.Account
FROM @ACTUALCUMULATED A
INNER JOIN PROJECTS P
	ON P.Id = A.IdProject
INNER JOIN WORK_PACKAGES WP
	ON A.IdProject = WP.IdProject and
	   A.IdPhase = WP.IdPhase and
	   A.IdWorkPackage = WP.Id
INNER JOIN COST_CENTERS CC
	ON A.IdCostCenter = CC.Id
INNER JOIN ASSOCIATES ASOC
	ON A.IdAssociate = ASOC.Id
INNER JOIN COUNTRIES C
	ON A.IdCountry = C.Id
INNER JOIN GL_ACCOUNTS GL
	ON A.IdCountry = GL.IdCountry and
	   A.IdAccount = GL.Id

INSERT INTO @IMPORT_YTD
	(ProjectCode, WPCode, CostCenter, AssociateNumber, Country, AccountNumber, Quantity, Value)
select  ProjectCode,
	WPCode, 
	CostCenter, 
	ISNULL(AssociateNumber, @NULLTempAssociateNumber)  AS AssociateNumber,
	Country,  
	AccountNumber,
	SUM (Quantity) AS HoursQty, 
	Sum(Value) AS HoursVal
from IMPORT_DETAILS IMD
INNER JOIN COUNTRIES C
	on C.Code = IMD.Country
where IdImport  = @IdImport and 
      dbo.fnGetBudgetCostType(C.ID,IMD.AccountNumber)  = @IdCostTypeHours 
-- use group by and sum in order to summarize information where the associate is null
group by Country, Year, Month, CostCenter, ProjectCode, WPCode, AccountNumber, AssociateNumber

--put the account number of the null associates for all countries from the import
UPDATE I
SET AssociateNumber = NullEmployeeNumber
FROM @IMPORT_YTD I
INNER JOIN @NULLASSOCIATES NA
	ON I.Country = NA.CountryCode
WHERE AssociateNumber = @NULLTempAssociateNumber

-- if we have different number of rows, this means inconsistency
DECLARE @CountActual INT,
	@CountImport INT
SELECT @CountActual = COUNT (*) from @ACTUALCUMULATED
SELECT @CountImport = COUNT (*) from @IMPORT_YTD
IF (@CountActual <> @CountImport)
BEGIN
	SET @KRMDiff = @KRMDiff + (@CountActual - @CountImport)
	SET @hasKRMError = 1
END

IF (@hasKRMError = 0) -- if KRM is ok then we can verify details
BEGIN
	UPDATE I
	SET I.Quantity = I.Quantity - A.Quantity
	FROM @IMPORT_YTD I
	INNER JOIN @ACTUALCUMULATED A
		ON I.ProjectCode = A.ProjectCode AND
		   I.WPCode = A.WPCode AND
		   I.CostCenter = A.CostCenter AND
		   I.AssociateNumber = A.AssociateNumber AND
		   I.Country = A.Country AND
		   I.AccountNumber = A.AccountNumber
	
	DECLARE @CountImportDiffQty INT
	Select @CountImportDiffQty = Count(*) 
	FROM @IMPORT_YTD
	WHERE Quantity <> 0
	IF (@CountImportDiffQty > 0)
	BEGIN
		RAISERROR('Consistency check failed (HoursQty). Actual data imported is different then current import for %d row(s).', 16, 1, @CountImportDiffQty)
		RETURN -3
	END
	
	
	IF (@Application_Type_Name <> 'NET')
	BEGIN
		UPDATE I
		SET I.Value = I.Value - A.Value
		FROM @IMPORT_YTD I
		INNER JOIN @ACTUALCUMULATED A
			ON I.ProjectCode = A.ProjectCode AND
			   I.WPCode = A.WPCode AND
			   I.CostCenter = A.CostCenter AND
			   I.AssociateNumber = A.AssociateNumber AND
			   I.Country = A.Country AND
			   I.AccountNumber = A.AccountNumber
		
		DECLARE @CountImportDiffVal INT
		Select @CountImportDiffVal = Count(*) 
		FROM @IMPORT_YTD
		WHERE Value > 0
		IF (@CountImportDiffVal > 0)
		BEGIN	
			RAISERROR('Consistency check failed (HoursVal). Actual data imported is different then current import for %d row(s).', 16, 1, @CountImportDiffVal)
			RETURN -4
		END
	END
END

--B.Check the costs
--clean up data
DELETE @ACTUALCUMULATED
DELETE @IMPORT_YTD


INSERT INTO @ACTUALCUMULATED
	(IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCountry, IdAccount, 
	ProjectCode, WPCode, CostCenter, AccountNumber, AssociateNumber,Country, 
	Quantity, Value)
SELECT ADC.IdProject, ADC.IdPhase, ADC.IdWorkPackage, ADC.IdCostCenter, ADC.IdAssociate, ADC.IdCountry, ADC.IdAccount,
       NULL, NULL, NULL, NULL, NULL, NULL,
       NULL, SUM (ADC.CostVal) as CostVal
FROM ACTUAL_DATA_DETAILS_COSTS ADC
INNER JOIN IMPORT_LOGS IL
	ON ADC.IdImport = IL.IdImport
WHERE IL.IdSource = @IdSource AND                -- same source
      IL.YearMonth/100 = @YearMonth/100 and      -- same year
      IL.YearMonth % 100 <= @YearMonth % 100 and -- only the previous and current months
      IL.Validation = 'G'                        -- only the succeeded imports
GROUP BY IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCountry, IdAccount 

UPDATE A
SET A.ProjectCode = P.Code,
    A.WPCode = WP.Code,
    A.CostCenter = CC.Code,
    A.AssociateNumber = ASOC.EmployeeNumber,
    A.Country = C.Code,
    A.AccountNumber = GL.Account
FROM @ACTUALCUMULATED A
INNER JOIN PROJECTS P
	ON P.Id = A.IdProject
INNER JOIN WORK_PACKAGES WP
	ON A.IdProject = WP.IdProject and
	   A.IdPhase = WP.IdPhase and
	   A.IdWorkPackage = WP.Id
INNER JOIN COST_CENTERS CC
	ON A.IdCostCenter = CC.Id
INNER JOIN ASSOCIATES ASOC
	ON A.IdAssociate = ASOC.Id
INNER JOIN COUNTRIES C
	ON A.IdCountry = C.Id
INNER JOIN GL_ACCOUNTS GL
	ON A.IdCountry = GL.IdCountry and
	   A.IdAccount = GL.Id

INSERT INTO @IMPORT_YTD
	(ProjectCode, WPCode, CostCenter, AssociateNumber, Country, AccountNumber, Quantity, Value)
SELECT  ProjectCode,
	WPCode, 
	CostCenter, 
	ISNULL(AssociateNumber, @NULLTempAssociateNumber)  AS AssociateNumber,
	Country,  
	AccountNumber,
	NULL AS Quantity, 
	Sum(Value) AS CostVal
from IMPORT_DETAILS IMD
INNER JOIN COUNTRIES C
	ON C.Code = IMD.Country
WHERE IdImport  = @IdImport and 
      dbo.fnGetBudgetCostType(C.ID,IMD.AccountNumber) BETWEEN 1 AND 5
-- use group by and sum in order to summarize information where the associate is null
GROUP BY Country, Year, Month, CostCenter, ProjectCode, WPCode, AccountNumber, AssociateNumber

--put the account number of the null associates for all countries from the import
UPDATE I
SET AssociateNumber = NullEmployeeNumber
FROM @IMPORT_YTD I
INNER JOIN @NULLASSOCIATES NA
	ON I.Country = NA.CountryCode
WHERE AssociateNumber = @NULLTempAssociateNumber

-- if we have different number of rows, this means inconsistency
SELECT @CountActual = COUNT (*) from @ACTUALCUMULATED
SELECT @CountImport = COUNT (*) from @IMPORT_YTD
IF (@CountActual <> @CountImport)
BEGIN
	SET @KRMDiff = @KRMDiff + (@CountActual - @CountImport)
	SET @hasKRMError = 1
END

IF (@hasKRMError = 0) -- if KRM is ok then we can verify details
BEGIN
	UPDATE I
	SET I.Value = I.Value - A.Value
	FROM @IMPORT_YTD I
	INNER JOIN @ACTUALCUMULATED A
		ON I.ProjectCode = A.ProjectCode AND
		   I.WPCode = A.WPCode AND
		   I.CostCenter = A.CostCenter AND
		   I.AssociateNumber = A.AssociateNumber AND
		   I.Country = A.Country AND
		   I.AccountNumber = A.AccountNumber
	
	SELECT @CountImportDiffVal = Count(*) 
	FROM @IMPORT_YTD
	WHERE Value > 0
	IF (@CountImportDiffVal > 0)
	BEGIN
		RAISERROR('Consistency check failed (CostVal). Actual data imported is different then current import for %d row(s).', 16, 1, @CountImportDiffVal)
		RETURN -5
	END
END


--C.Check the sales
DELETE @ACTUALCUMULATED
DELETE @IMPORT_YTD


INSERT INTO @ACTUALCUMULATED
	(IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCountry, IdAccount, 
	ProjectCode, WPCode, CostCenter, AccountNumber, AssociateNumber,Country, 
	Quantity, Value)
SELECT ADS.IdProject, ADS.IdPhase, ADS.IdWorkPackage, ADS.IdCostCenter, ADS.IdAssociate, ADS.IdCountry, ADS.IdAccount,
	NULL, NULL, NULL, NULL, NULL, NULL,
       NULL, SUM (ADS.SalesVal)
FROM ACTUAL_DATA_DETAILS_SALES ADS
INNER JOIN IMPORT_LOGS IL
	ON ADS.IdImport = IL.IdImport
WHERE IL.IdSource = @IdSource AND                -- same source
      IL.YearMonth/100 = @YearMonth/100 and      -- same year
      IL.YearMonth % 100 <= @YearMonth % 100 and -- only the previous and current months
      IL.Validation = 'G'                        -- only the succeeded imports
GROUP BY IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCountry, IdAccount 

UPDATE A
SET A.ProjectCode = P.Code,
    A.WPCode = WP.Code,
    A.CostCenter = CC.Code,
    A.AssociateNumber = ASOC.EmployeeNumber,
    A.Country = C.Code,
    A.AccountNumber = GL.Account
FROM @ACTUALCUMULATED A
INNER JOIN PROJECTS P
	ON P.Id = A.IdProject
INNER JOIN WORK_PACKAGES WP
	ON A.IdProject = WP.IdProject and
	   A.IdPhase = WP.IdPhase and
	   A.IdWorkPackage = WP.Id
INNER JOIN COST_CENTERS CC
	ON A.IdCostCenter = CC.Id
INNER JOIN ASSOCIATES ASOC
	ON A.IdAssociate = ASOC.Id
INNER JOIN COUNTRIES C
	ON A.IdCountry = C.Id
INNER JOIN GL_ACCOUNTS GL
	ON A.IdCountry = GL.IdCountry and
	   A.IdAccount = GL.Id

INSERT INTO @IMPORT_YTD
	(ProjectCode, WPCode, CostCenter, AssociateNumber, Country, AccountNumber, Quantity, Value)
SELECT  ProjectCode,
	WPCode, 
	CostCenter, 
	ISNULL(AssociateNumber, @NULLTempAssociateNumber)  AS AssociateNumber,
	Country,  
	AccountNumber, 
	NULL AS Quantity, 
	Sum(Value) AS SalesVal
FROM IMPORT_DETAILS IMD
INNER JOIN COUNTRIES C
	ON C.Code = IMD.Country
WHERE IdImport  = @IdImport and 
      dbo.fnGetBudgetCostType(C.ID,IMD.AccountNumber) = @IdCostTypeSales
-- use group by and sum in order to summarize information where the associate is null
GROUP BY Country, Year, Month, CostCenter, ProjectCode, WPCode, AccountNumber, AssociateNumber

--put the account number of the null associates for all countries from the import
UPDATE I
SET AssociateNumber = NullEmployeeNumber
FROM @IMPORT_YTD I
INNER JOIN @NULLASSOCIATES NA
	ON I.Country = NA.CountryCode
WHERE AssociateNumber = @NULLTempAssociateNumber

-- if we have different number of rows, this means inconsistency
SELECT @CountActual = COUNT (*) from @ACTUALCUMULATED
SELECT @CountImport = COUNT (*) from @IMPORT_YTD
IF (@CountActual <> @CountImport)
BEGIN
	SET @KRMDiff = @KRMDiff + (@CountActual - @CountImport)
	SET @hasKRMError = 1
END

IF (@hasKRMError = 0) -- if KRM is ok then we can verify details
BEGIN
	UPDATE I
	SET I.Value = I.Value - A.Value
	FROM @IMPORT_YTD I
	INNER JOIN @ACTUALCUMULATED A
		ON I.ProjectCode = A.ProjectCode AND
		   I.WPCode = A.WPCode AND
		   I.CostCenter = A.CostCenter AND
		   I.AssociateNumber = A.AssociateNumber AND
		   I.Country = A.Country AND
		   I.AccountNumber = A.AccountNumber

	SELECT @CountImportDiffVal = Count(*) 
	FROM @IMPORT_YTD
	WHERE Value > 0
	IF (@CountImportDiffVal > 0)
	BEGIN	
		RAISERROR('Consistency check failed (SalesVal). Actual data imported is different then current import for %d row(s).', 16, 1, @CountImportDiffVal)
		RETURN -6
	END
END

--it is important to return with error in case there were KRM type check failes (@KRMDiff > 0)
IF (@hasKRMError > 0)
BEGIN
	SET @strError = 'Consistency check failed. A number of ' + cast(@KRMDiff as varchar(10)) + ' key row(s) were missing from import.'
	RAISERROR (@strError, 16,1)
	RETURN -7
END



END
GO

