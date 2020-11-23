--Drops the Procedure catUpdateInergyLocation if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateInergyLocation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateInergyLocation
GO
CREATE PROCEDURE catUpdateInergyLocation
	@Id		INT,			--The Id of the selected Inergy Location
	@IdCountry	INT,
 	@Code		VARCHAR(3),	--The Code of the Inergy Location you want to Insert
	@Name		VARCHAR(50),	--The Name of the Inergy Location you want to Insert
	@Rank INT
AS
DECLARE @Rowcount 		INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT
	
	SET @LogicalKey = 'Code'

	IF EXISTS( SELECT *
	FROM INERGY_LOCATIONS AS IL
	WHERE 	IL.[Code] = @Code AND
		IL.[Id] <> @Id) 
	SET @ValidateLogicKey = 1

	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	SET @ValidateLogicKey = 0
	SET @LogicalKey= 'Name'

	IF EXISTS( SELECT *
	FROM INERGY_LOCATIONS AS IL
	WHERE 	IL.[Name] = @Name AND
		IL.[Id] <> @Id) 
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

	IF NOT EXISTS( SELECT Id
		   FROM INERGY_LOCATIONS
		   WHERE Id = @Id AND
		   IdCountry = @IdCountry)
	BEGIN
		SELECT @ValidateLogicKey = dbo.fnCheckInergyLocationExistenceInAllCategories(@Id)
		DECLARE @Old_CountryName varchar(30),
			@Old_InergyLocation varchar(30)

		SELECT @Old_CountryName  = C.Name,
		       @Old_InergyLocation = IL.Name
		FROM INERGY_LOCATIONS IL
		INNER JOIN COUNTRIES C
			ON IL.IdCountry = C.Id
		WHERE IL.Id = @Id

		IF @ValidateLogicKey = 1
		BEGIN		
			RAISERROR('Country  %s cannot be changed. %s has at least one cost center with budget data.',16,1,@Old_CountryName, @Old_InergyLocation)
		RETURN -1
		END
	END
	
	exec @RetVal = catUpdateCatalogRank 'INERGY_LOCATIONS', @Rank,2, @Id

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	UPDATE INERGY_LOCATIONS 	
	SET IdCountry = @IdCountry,
	    Code = @Code,
	    [Name] = @Name,
	    [Rank] = @Rank
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

