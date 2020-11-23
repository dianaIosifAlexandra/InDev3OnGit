--Drops the Procedure catInsertAssociate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertAssociate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertAssociate
GO
CREATE PROCEDURE catInsertAssociate
	@IdCountry		INT,		--The Id of the Country that is connected to the Associate you want to insert
 	@EmployeeNumber		VARCHAR(15),	--The Employee Number of the Associate you want to Insert
	@Name			VARCHAR(50),	--The Name of the Associate you want to Insert
	@InergyLogin		VARCHAR(50),	--The Inergy Login of the Associate you want to Insert
	@PercentageFullTime 	INT,		--The AvailabilityPercent of the Associate you want to Insert
	@IsActive		BIT,		--The IsActive of the Associate you want to Insert
	@IsSubContractor	BIT		--The IsSubContractor of the Associate you want to Insert

AS
DECLARE @Id			INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(50)
	

	IF NOT EXISTS( SELECT *
	FROM COUNTRIES AS C(TABLOCKX)
	WHERE 	C.[Id] = @IdCountry) 
	BEGIN
		RAISERROR('The selected country does not exists anymore',16,1)
		RETURN
	END

	SET @LogicalKey = 'Country, Employee Number'

	IF EXISTS( SELECT *
	FROM ASSOCIATES AS A (TABLOCKX)
	WHERE 	A.EmployeeNumber = @EmployeeNumber AND
		A.IdCountry = @IdCountry) 
	SET @ValidateLogicKey = 1
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	SET @LogicalKey = 'Inergy Login, Country'

	IF EXISTS( SELECT *
	FROM ASSOCIATES AS A (TABLOCKX)
	WHERE 	A.InergyLogin = @InergyLogin AND
		A.IdCountry = @IdCountry
	)
	SET @ValidateLogicKey = 1

	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@IdCountry IS NULL OR 
	   @EmployeeNumber IS NULL OR 
	   @Name IS NULL OR 
	   @InergyLogin IS NULL OR 
	   @PercentageFullTime IS NULL OR 
	   @IsActive IS NULL OR 
	   @IsSubContractor IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END
	SELECT @Id = ISNULL(MAX(A.[Id]), 0) + 1
	FROM ASSOCIATES AS A (TABLOCKX)

	INSERT INTO ASSOCIATES ([Id],IdCountry,EmployeeNumber,[Name],InergyLogin,PercentageFullTime,IsActive,IsSubContractor)
	VALUES		       (@Id,@IdCountry,@EmployeeNumber,@Name,@InergyLogin,@PercentageFullTime,@IsActive,@IsSubContractor)
	
	RETURN @Id
GO



