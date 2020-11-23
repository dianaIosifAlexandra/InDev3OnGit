--Drops the Procedure catInsertInergyLocation if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertInergyLocation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertInergyLocation
GO
CREATE PROCEDURE catInsertInergyLocation
	@IdCountry	INT,
 	@Code		VARCHAR(3),	--The Code of the Inergy Location you want to Insert
	@Name		VARCHAR(50),	--The Name of the Inergy Location you want to Insert
	@Rank INT
AS
DECLARE @Id			INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT
	
	IF NOT EXISTS( SELECT *
	FROM COUNTRIES AS C(TABLOCKX)
	WHERE 	C.[Id] = @IdCountry) 
	BEGIN
		RAISERROR('The selected country does not exists anymore',16,1)
		RETURN
	END

	SET @LogicalKey = 'Code'

	IF EXISTS( SELECT *
	FROM INERGY_LOCATIONS AS IL(TABLOCKX)
	WHERE 	IL.[Code] = @Code) 
	SET @ValidateLogicKey = 1

	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	SET @ValidateLogicKey =0
	SET @LogicalKey= 'Name'

	IF EXISTS( SELECT *
	FROM INERGY_LOCATIONS AS IL
	WHERE 	IL.[Name] = @Name) 
	SET @ValidateLogicKey = 1

	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@IdCountry IS NULL OR 
	   @Code IS NULL OR 
	   @Name IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	SELECT @Id = ISNULL(MAX(IL.[Id]), 0) + 1
	FROM INERGY_LOCATIONS AS IL (TABLOCKX)
	
	exec @RetVal = catUpdateCatalogRank 'INERGY_LOCATIONS', @Rank,1,NULL

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	INSERT INTO INERGY_LOCATIONS ([Id],IdCountry,Code,[Name], [Rank])
	VALUES		   	     (@Id,@IdCountry,@Code,@Name, @Rank)
	
	RETURN @Id
GO

