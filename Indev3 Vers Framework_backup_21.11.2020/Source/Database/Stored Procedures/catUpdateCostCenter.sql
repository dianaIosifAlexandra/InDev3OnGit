--Drops the Procedure catUpdateCostCenter if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateCostCenter]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateCostCenter
GO
CREATE PROCEDURE catUpdateCostCenter
	@Id			INT,		--The Id of the cost center
	@IdInergyLocation	INT,		--The Id of the Inergy Location related to the Cost Center
	@IdDepartment		INT,		--The Id of the Department related to the Cost Center
	@IsActive		BIT,		--Specifies if the Cost Center is active or not
 	@Code			VARCHAR(15),	--The Code of the Cost Center you want to Insert
	@Name			VARCHAR(30)	--The Name of the Cost Center you want to Insert
AS
DECLARE	@RowCount		INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)


	
	SET @LogicalKey = 'Country, Code'

	--first we get the country of the newly inserted code 
	Declare @IdCountry int
	SELECT @IdCountry = IdCountry
	from INERGY_LOCATIONS
	WHERE Id = @IdInergyLocation

	IF EXISTS(SELECT *
		  FROM COST_CENTERS CC (TABLOCKX)
	          INNER JOIN INERGY_LOCATIONS IL
	  		ON CC.IdInergyLocation = IL.Id
		  WHERE CC.Code = @Code AND
			IL.IdCountry = @IdCountry AND
			CC.[Id] <> @Id) 
	SET @ValidateLogicKey = 1
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END





	IF(@IdInergyLocation IS NULL OR 
	   @IdDepartment IS NULL OR 
	   @IsActive IS NULL OR 
	   @Code IS NULL OR 
	   @Name IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	DECLARE @Old_IdCountry INT
	DECLARE @New_IdCountry INT
	DECLARE @Old_InergyLocation INT
	DECLARE @Old_CountryName varchar(30)

	SELECT  @Old_IdCountry = IL.IdCountry, 
		@Old_CountryName = C.Name,
	 	@Old_InergyLocation = CC.IdInergyLocation
	FROM COST_CENTERS CC
	INNER JOIN INERGY_LOCATIONS IL
		ON CC.IdInergyLocation = IL.Id
	INNER JOIN COUNTRIES C
		ON IL.IdCountry = C.Id
	WHERE CC.Id = @Id

	SELECT @New_IdCountry =IdCountry
	FROM INERGY_LOCATIONS
	WHERE Id = @IdInergyLocation

	IF ISNULL(@Old_IdCountry,0)<> ISNULL(@New_IdCountry,0)
	BEGIN
		SET @ValidateLogicKey = dbo.fnCheckCostCenterExistenceInAllCategories(@Id)
		if @ValidateLogicKey=1
		BEGIN
			RAISERROR('Inergy Location cannot be changed for this Cost Center. Only Inergy Locations from the same country (%s) are allowed when the cost center has budget or actual data.',16,1,@Old_CountryName)
			RETURN -3		
		END
	END

	
	UPDATE COST_CENTERS 	
	SET IdInergyLocation = @IdInergyLocation,
	    IdDepartment = @IdDepartment,
	    IsActive = @IsActive, 
	    Code = @Code,
	    [Name] = @Name
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

