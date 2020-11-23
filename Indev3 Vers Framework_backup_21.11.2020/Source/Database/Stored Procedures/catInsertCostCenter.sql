--Drops the Procedure catInsertCostCenter if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertCostCenter]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertCostCenter
GO
CREATE PROCEDURE catInsertCostCenter
	@IdInergyLocation	INT,		--The Id of the Inergy Location related to the Cost Center
	@IdDepartment		INT,		--The Id of the Department related to the Cost Center
	@IsActive		BIT,		--Specifies if the Cost Center is active or not
 	@Code			VARCHAR(15),	--The Code of the Cost Center you want to Insert
	@Name			VARCHAR(30)	--The Name of the Cost Center you want to Insert
	
AS
DECLARE @Id			INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)
	
	IF NOT EXISTS( SELECT *
	FROM INERGY_LOCATIONS AS I(TABLOCKX)
	WHERE 	I.[Id] = @IdInergyLocation) 
	BEGIN
		RAISERROR('The selected Inergy Location does not exists anymore',16,1)
		RETURN
	END

	IF NOT EXISTS( SELECT *
	FROM DEPARTMENTS AS D(TABLOCKX)
	WHERE 	D.[Id] = @IdDepartment) 
	BEGIN
		RAISERROR('The selected department does not exists anymore',16,1)
		RETURN
	END



	--first we get the country of the newly inserted code 
	Declare @IdCountry int
	SELECT @IdCountry = IdCountry
	from INERGY_LOCATIONS
	WHERE Id = @IdInergyLocation

	SET @LogicalKey = 'Country, Code'
	IF EXISTS( SELECT *
		   FROM COST_CENTERS CC(TABLOCKX)
		   INNER JOIN INERGY_LOCATIONS IL
  			ON CC.IdInergyLocation = IL.Id
		   WHERE CC.Code = @Code and
			 IL.IdCountry = @IdCountry) 
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

	SELECT @Id = ISNULL(MAX(CC.[Id]), 0) + 1
	FROM COST_CENTERS AS CC (TABLOCKX)
	
	INSERT INTO COST_CENTERS([Id], IdInergyLocation, IdDepartment, IsActive, Code, [Name])
	VALUES		   	(@Id,@IdInergyLocation,@IdDepartment,@IsActive,@Code,@Name)
	
	RETURN @Id
GO

