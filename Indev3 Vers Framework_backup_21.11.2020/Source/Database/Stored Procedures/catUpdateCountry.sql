--Drops the Procedure catUpdateCountry if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateCountry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateCountry
GO
CREATE PROCEDURE catUpdateCountry
	@Id		INT,			--The Id of the Country you want to update
 	@Code		VARCHAR(3),	--The Code of the Country you want to Insert
	@Name		VARCHAR(30),	--The Name of the Country you want to Insert
	@IdRegion	INT = NULL,		--The Region from REGIONS table
	@IdCurrency	INT,		--The Currency from Currencies table
	@Email 		VARCHAR(50),
	@Rank INT
AS
DECLARE @Rowcount 		INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT
	
	SET @LogicalKey = 'Country Name'

	IF EXISTS( SELECT *
	FROM COUNTRIES AS C
	WHERE 	C.[Name] = @Name AND
		C.[Id] <> @Id) 
	SET @ValidateLogicKey = 1
	
	IF EXISTS( SELECT *
	FROM COUNTRIES AS C
	WHERE 	C.Code = @Code AND
		C.[Id] <> @Id)  
	BEGIN
		SET @ValidateLogicKey = 1
		SET @LogicalKey= 'Name'
	END

	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@Code IS NULL OR 
	   @Name IS NULL OR 
	   @IdCurrency IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	--Check that the selected region still exists
	IF (@IdRegion IS NOT NULL)
	BEGIN
		IF NOT EXISTS
		(
			SELECT 	[Id]
			FROM 	Regions
			WHERE 	[Id] = @IdRegion
		)
		BEGIN
			RAISERROR('The selected region does not exist anymore',16,1)
			RETURN -3
		END
	END

	DECLARE @OldIdRegion INT
	SELECT 	@OldIdRegion = IdRegion
	FROM 	COUNTRIES
	WHERE	[Id] = @Id

	exec @RetVal = catUpdateCatalogRank 'COUNTRIES', @Rank,2, @Id

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -4

	UPDATE COUNTRIES 	
	SET Code = @Code,
	    [Name] = @Name,
	    IdRegion = @IdRegion,
	    IdCurrency = @IdCurrency,
	    Email = @Email,
	    [Rank] = @Rank
	WHERE [Id] = @Id
	SET @Rowcount = @@ROWCOUNT

	DECLARE CostIncomeCursor CURSOR FAST_FORWARD FOR
	SELECT 	[Id],
		[Name],
		DefaultAccount
	FROM	COST_INCOME_TYPES

	OPEN CostIncomeCursor
	DECLARE @IdCostIncome INT
	DECLARE @NameCostIncome VARCHAR(50)
	DECLARE @DefaultAccountCostIncome VARCHAR(20)
	

	FETCH NEXT FROM CostIncomeCursor INTO @IdCostIncome, @NameCostIncome, @DefaultAccountCostIncome		
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@IdRegion IS NOT NULL)
		BEGIN
			IF (@OldIdRegion IS NULL)
			BEGIN
				IF NOT EXISTS
				(
					SELECT * FROM GL_ACCOUNTS
					WHERE 	IdCountry = @Id AND
						Account = @NameCostIncome
				)
				BEGIN
					EXEC @RETVAL = catInsertGlAccount @Id, @DefaultAccountCostIncome, @NameCostIncome, @IdCostIncome
					IF @RETVAL<0 OR @@ERROR<>0
					BEGIN
						CLOSE CostIncomeCursor
						DEALLOCATE CostIncomeCursor
						RETURN -5
					END
				END
			END
		END
		ELSE
		BEGIN
			IF (@OldIdRegion IS NOT NULL)
			BEGIN
				DECLARE @IdGlAccount INT
				
				SELECT 	@IdGlAccount = [Id]
				FROM	GL_ACCOUNTS
				WHERE	IdCountry = @Id AND
					Account = @DefaultAccountCostIncome
				
				EXEC @RETVAL =   catDeleteGlAccount @Id, @IdGlAccount
				IF @RETVAL<0 OR @@ERROR<>0
				BEGIN
					CLOSE CostIncomeCursor
					DEALLOCATE CostIncomeCursor
					RETURN -6
				END
			END
		END
		FETCH NEXT FROM CostIncomeCursor INTO @IdCostIncome, @NameCostIncome, @DefaultAccountCostIncome
	END
	
	CLOSE CostIncomeCursor
	DEALLOCATE CostIncomeCursor

	RETURN @Rowcount
GO

