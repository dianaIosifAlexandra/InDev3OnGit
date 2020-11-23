
DECLARE @IDProject INT,
@IDPhase INT,
@IdWorkPackage int,
@IdCostCenter INT,
@YearMonth INT, 
@IdAssociate INT,
@IdCountry INT,
@IdAccount INT,
@IDImport INT

DECLARE CC_CURSOR CURSOR FAST_FORWARD FOR

SELECT [IdProject], [IdPhase], [IdWorkPackage], 
[IdCostCenter], [YearMonth], [IdAssociate], 
[IdCountry], [IdAccount], [IdImport] 
FROM [ACTUAL_DATA_DETAILS_HOURS]
ORDER BY YearMonth 

OPEN CC_CURSOR
FETCH NEXT FROM CC_CURSOR
INTO @IDProject,
@IDPhase ,
@IdWorkPackage,
@IdCostCenter,
@YearMonth , 
@IdAssociate,
@IdCountry ,
@IdAccount ,
@IDImport

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @CountryCode VARCHAR(3),
		@Year INT,
		@Month INT,
		@CostCenterCode VARCHAR(10),
		@ProjectCode VARCHAR(10),
		@WPCode VARCHAR(4),
		@AccountNumber NVARCHAR(20),
		@AssociateNumber VARCHAR(15)
	
	SELECT @CountryCode = Code
	FROM COUNTRIES
	WHERE Id = @IdCountry

	SELECT @CostCenterCode = Code
	FROM COST_CENTERS
	WHERE Id = @IdCostCenter

	SELECT @ProjectCode = Code
	FROM PROJECTS
	WHERE Id = @IDProject

	SELECT @WPCode = Code
	FROM 	WORK_PACKAGES
	WHERE IdProject = @IDProject AND
		IdPhase=@IDPhase AND
		Id = @IdWorkPackage

	SELECT @AccountNumber = Account
	FROM GL_ACCOUNTS
	WHERE 	Id = @IdAccount AND
		IdCountry = @IdCountry

	SELECT @AssociateNumber = EmployeeNumber
	FROM ASSOCIATES
	WHERE Id = @IdAssociate

	DECLARE @HoursQtyImport INT
	DECLARE @ValHoursImport DECIMAL(18, 2)

	DECLARE @NullAssociateId INT
	SELECT 	@NullAssociateId = Id
	FROM 	ASSOCIATES
	WHERE 	InergyLogin = @CountryCode + '\null'

	DECLARE @Application_Type_Name NVARCHAR(3)

	SELECT @Application_Type_Name = [NAME]
	FROM IMPORT_APPLICATION_TYPES IAT
	INNER JOIN IMPORT_SOURCES [IS]
		ON IAT.Id = [IS].IdApplicationTypes
	INNER JOIN IMPORT_LOGS IL
		ON [IS].Id = IL.IdSource
	WHERE IL.IdImport = @IDImport



	IF (@IdAssociate <> @NullAssociateId)
	BEGIN
		SELECT 	@HoursQtyImport = Quantity,
			@ValHoursImport = ISNULL(Value,0)
		FROM 	IMPORT_DETAILS
		WHERE 	IdImport = @IDImport AND
			Country = @CountryCode AND
			Year = @YearMonth / 100 AND
			Month = @YearMonth % 100 AND
			CostCenter = @CostCenterCode AND
			ProjectCode = @ProjectCode AND
			WPCode = @WPCode AND
			AccountNumber = @AccountNumber AND
			AssociateNumber = @AssociateNumber
	END
	ELSE
	BEGIN
		SELECT 	@HoursQtyImport = SUM(Quantity),
			@ValHoursImport = SUM(ISNULL(Value, 0))
		FROM 	IMPORT_DETAILS
		WHERE 	IdImport = @IDImport AND
			Country = @CountryCode AND
			Year = @YearMonth / 100 AND
			Month = @YearMonth % 100 AND
			CostCenter = @CostCenterCode AND
			ProjectCode = @ProjectCode AND
			WPCode = @WPCode AND
			AccountNumber = @AccountNumber AND
			AssociateNumber IS NULL
	END

	IF (@Application_Type_Name = 'NET')  AND (@HoursQtyImport<>0 OR @ValHoursImport=0 )
	BEGIN
		UPDATE 	ACTUAL_DATA_DETAILS_HOURS
		SET 	HoursVal = dbo.fnGetValuedHours(@IdCostCenter, ISNULL(@HoursQtyImport,0) - 
				(SELECT ISNULL(SUM(ISNULL(ADH.HoursQty,0)),0) 
				FROM ACTUAL_DATA_DETAILS_HOURS ADH 
				WHERE ADH.IdProject = @IdProject AND
				      ADH.IdPhase = @IdPhase AND
				      ADH.IdWorkPackage = @IdWorkPackage AND
				      ADH.IdCostCenter = @IdCostCenter AND
				      --check just year
				      ADH.YearMonth / 100 = @YearMonth / 100 AND
				      ADH.YearMonth < @YearMonth AND
				      ADH.IdAssociate = @IdAssociate AND	
				      ADH.IdCountry = @IdCountry AND
				      ADH.IdAccount = @IdAccount
				), @YearMonth)
		WHERE 	IdProject = @IdProject AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWorkPackage AND
			IdCostCenter = @IdCostCenter AND
			YearMonth = @YearMonth AND
			IdAssociate = @IdAssociate AND
			IdCountry = @IdCountry AND
			IdAccount = @IdAccount

	END
	ELSE
	BEGIN
		UPDATE 	ACTUAL_DATA_DETAILS_HOURS
		SET 	HoursVal = @ValHoursImport - (SELECT ISNULL(SUM(ISNULL(ADH.HoursVal,0)),0) 
					FROM ACTUAL_DATA_DETAILS_HOURS ADH 
					WHERE ADH.IdProject = @IdProject AND
					      ADH.IdPhase = @IdPhase AND
					      ADH.IdWorkPackage = @IdWorkPackage AND
					      ADH.IdCostCenter = @IdCostCenter AND
					      --check just year
					      ADH.YearMonth / 100 = @YearMonth / 100 AND
					      ADH.YearMonth < @YearMonth AND
					      ADH.IdAssociate = @IdAssociate AND	
					      ADH.IdCountry = @IdCountry AND
					      ADH.IdAccount = @IdAccount
					)
		WHERE 	IdProject = @IdProject AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWorkPackage AND
			IdCostCenter = @IdCostCenter AND
			YearMonth = @YearMonth AND
			IdAssociate = @IdAssociate AND
			IdCountry = @IdCountry AND
			IdAccount = @IdAccount
	END	


	FETCH NEXT FROM CC_CURSOR 
	INTO @IDProject,
	@IDPhase ,
	@IdWorkPackage,
	@IdCostCenter,
	@YearMonth , 
	@IdAssociate,
	@IdCountry ,
	@IdAccount ,
	@IDImport
END

CLOSE CC_CURSOR
DEALLOCATE CC_CURSOR
