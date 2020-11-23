--Drops the Procedure impWriteActualTableHours if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteActualTableHours]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteActualTableHours

GO

CREATE PROCEDURE impWriteActualTableHours
	@IdImport INT
AS

Declare @IdSource int,
	@YearMonth int,
	@strError varchar(255)

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

--read the cost type account
DECLARE @IdCostTypeHours INT
SELECT @IdCostTypeHours = dbo.fnGetHoursCostTypeID()

--read the application type that did the CSV file
DECLARE @Application_Type_Name NVARCHAR(3)
SELECT @Application_Type_Name = [NAME] 
FROM IMPORT_APPLICATION_TYPES IAT
INNER JOIN IMPORT_SOURCES [IS]
	ON IAT.Id = [IS].IdApplicationTypes
WHERE [IS].Id = @IdSource





INSERT INTO [ACTUAL_DATA_DETAILS_HOURS]
	([IdProject], [IdPhase], [IdWorkPackage], [IdCostCenter], 
	[YearMonth], [IdAssociate], [IdCountry], [IdAccount], 
	[HoursQty], [HoursVal], [DateImport], [IdImport])
SELECT	P.Id, WP.IdPhase, WP.Id, CC.Id,
	 @YearMonth, A.Id, C.Id, dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber),
	ISNULL(IMD.Quantity,0) - ISNULL((SELECT SUM(ISNULL(ADH.HoursQty,0))
					FROM ACTUAL_DATA_DETAILS_HOURS ADH 
					WHERE ADH.IdProject = WP.IdProject AND
					      ADH.IdPhase = WP.IdPhase AND
					      ADH.IdWorkPackage =WP.Id AND
					      ADH.IdCostCenter = CC.Id AND
					      ADH.YearMonth/100 = @YearMonth/100 AND --check just year
					      ADH.IdAssociate = A.Id AND	
					      ADH.IdCountry = C.Id AND
					      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)), 0),

	CASE WHEN (@Application_Type_Name ='NET' AND IMD.Quantity <> 0)
	THEN dbo.fnGetValuedHours(CC.Id, 
		ISNULL(IMD.Quantity,0) - ISNULL((SELECT SUM(ISNULL(ADH.HoursQty,0)) 
						FROM ACTUAL_DATA_DETAILS_HOURS ADH 
						WHERE ADH.IdProject = WP.IdProject AND
						      ADH.IdPhase = WP.IdPhase AND
						      ADH.IdWorkPackage =WP.Id AND
						      ADH.IdCostCenter = CC.Id AND
						      ADH.YearMonth/100 = @YearMonth/100 AND --check just year
						      ADH.IdAssociate = A.Id AND	
						      ADH.IdCountry = C.Id AND
						      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)),0),@YearMonth)
	ELSE
	 ISNULL(IMD.Value,0) - ISNULL((SELECT (SUM(ISNULL(ADH.HoursVal,0))) 
					  FROM ACTUAL_DATA_DETAILS_HOURS ADH 
					  WHERE ADH.IdProject = WP.IdProject AND
					      ADH.IdPhase = Wp.IdPhase AND
					      ADH.IdWorkPackage =WP.Id AND
					      ADH.IdCostCenter = CC.Id AND
					      ADH.YearMonth/100 = @YearMonth/100 AND --check just year
					      ADH.IdAssociate = A.Id AND			      
					      ADH.IdCountry = C.Id AND
					      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)),0)
	END,
	ISNULL(IMD.[Date], GETDATE()),
	@IdImport
FROM IMPORT_DETAILS IMD
INNER JOIN PROJECTS P
	ON IMD.ProjectCode = P.Code
INNER JOIN WORK_PACKAGES WP
	ON WP.IdProject = P.ID AND 
	   WP.Code = IMD.WPCode
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
WHERE  IMD.IdImport = @IdImport AND
       dbo.fnGetBudgetCostType(C.ID,IMD.AccountNumber)  = @IdCostTypeHours AND
	IMD.AssociateNumber IS NOT NULL -- only update the rows that have valid associatenumbers


-- 	TAKE NULL ASSOCIATE NUMBERS RECORDS
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

-- insert into variable table with sumed values for nullassociates

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
INNER JOIN @NULLASSOCIATES NA
	ON IMD.Country = NA.CountryCode
INNER JOIN COUNTRIES C
	ON IMD.Country = C.Code
WHERE IMD.IdImport = @IdImport AND
      dbo.fnGetBudgetCostType(C.ID,IMD.AccountNumber)  = @IdCostTypeHours AND
      IMD.AssociateNumber IS NULL-- only take the rows that doesn't have valid associatenumbers
GROUP BY IMD.Country,
	IMD.CostCenter,
	IMD.ProjectCode,
	IMD.WPCode,
	IMD.AccountNumber


INSERT INTO [ACTUAL_DATA_DETAILS_HOURS]
	([IdProject], [IdPhase], [IdWorkPackage], [IdCostCenter], 
	[YearMonth], [IdAssociate], [IdCountry], [IdAccount], 
	[HoursQty], [HoursVal], [DateImport], [IdImport])
SELECT
	P.Id, WP.IdPhase, WP.Id, CC.Id,
	@YearMonth, A.Id, C.Id,dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber),
	ISNULL(IMD.Quantity,0) - ISNULL((SELECT SUM(ISNULL(ADH.HoursQty,0)) 
					FROM ACTUAL_DATA_DETAILS_HOURS ADH 
					WHERE ADH.IdProject = WP.IdProject AND
					      ADH.IdPhase = WP.IdPhase AND
					      ADH.IdWorkPackage =WP.Id AND
					      ADH.IdCostCenter = CC.Id AND	      
					      ADH.YearMonth/100 = @YearMonth/100 AND --check just year
					      ADH.IdAssociate = A.Id AND
					      ADH.IdCountry = C.Id AND
					      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)),0),

	CASE WHEN (@Application_Type_Name ='NET' AND IMD.Quantity <> 0)
	     THEN dbo.fnGetValuedHours(CC.Id,
		ISNULL(IMD.Quantity,0) - ISNULL((SELECT SUM(ISNULL(ADH.HoursQty,0))
						FROM ACTUAL_DATA_DETAILS_HOURS ADH 
						WHERE ADH.IdProject = WP.IdProject AND
						      ADH.IdPhase = WP.IdPhase AND
						      ADH.IdWorkPackage =WP.Id AND
						      ADH.IdCostCenter = CC.Id AND
						      ADH.YearMonth/100 = @YearMonth/100 AND --check just year
						      ADH.IdAssociate = A.Id AND	
						      ADH.IdCountry = C.Id AND
						      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)),0),
						@YearMonth)
		ELSE
		 ISNULL(IMD.Value,0) - ISNULL((SELECT SUM(ISNULL(ADH.HoursVal,0))
						  FROM ACTUAL_DATA_DETAILS_HOURS ADH 
						  WHERE ADH.IdProject = WP.IdProject AND
						      ADH.IdPhase = Wp.IdPhase AND
						      ADH.IdWorkPackage =WP.Id AND
						      ADH.IdCostCenter = CC.Id AND
						      ADH.YearMonth/100 = @YearMonth/100 AND --check just year
						      ADH.IdAssociate = A.Id AND		     
						      ADH.IdCountry = C.Id AND
						      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)),0)
	      END,
	IMD.[Date],
	@IdImport

FROM 	@IMPORT_NULL_ASSOCIATES IMD
INNER JOIN PROJECTS P
	ON IMD.ProjectCode = P.Code
INNER JOIN WORK_PACKAGES WP
	ON WP.IdProject = P.ID AND 
	   WP.Code = IMD.WPCode
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
-- these rows have either qty not null or value not null for previous periods of the same year
DELETE A
FROM ACTUAL_DATA_DETAILS_HOURS A
WHERE IdImport = @IdImport and
	  HoursQty = 0 AND
      HoursVal = 0 AND
       (((Select SUM(HoursQty)
	    from ACTUAL_DATA_DETAILS_HOURS
	    Where IdProject = A.IdProject AND 
		  IdPhase = A.IdPhase AND 
		  IdWorkPackage = A.IdWorkPackage AND
		  IdCostCenter = A.IdCostCenter AND
		  IdAssociate = A.IdAssociate AND
		  IdCountry = A.IdCountry AND
		  IdAccount = A.IdAccount AND
		  YearMonth/100 = A.YearMonth/100 AND
		  YearMonth < A.YearMonth) IS NOT NULL) OR
      ((Select SUM(HoursVal)
	    from ACTUAL_DATA_DETAILS_HOURS
	    Where IdProject = A.IdProject AND 
		  IdPhase = A.IdPhase AND 
		  IdWorkPackage = A.IdWorkPackage AND
		  IdCostCenter = A.IdCostCenter AND
		  IdAssociate = A.IdAssociate AND
		  IdCountry = A.IdCountry AND
		  IdAccount = A.IdAccount AND
		  YearMonth/100 = A.YearMonth/100 AND
		  YearMonth < A.YearMonth) IS NOT NULL))




GO

