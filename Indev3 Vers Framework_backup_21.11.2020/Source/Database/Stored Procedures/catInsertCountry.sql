--Drops the Procedure catInsertCountry if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertCountry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertCountry
GO
CREATE PROCEDURE catInsertCountry
 	@Code		VARCHAR(3),	--The Code of the Country you want to Insert
	@Name		VARCHAR(30),	--The Name of the Country you want to Insert
	@IdRegion	INT = NULL,		--The Region from REGIONS table
	@IdCurrency	INT,		--The Currency from Currencies table
	@Email		VARCHAR(50),
	@Rank INT
	
AS
BEGIN
	DECLARE @Id					INT,
			@ValidateLogicKey	BIT,
			@ErrorMessage		VARCHAR(200),
			@LogicalKey			VARCHAR(20)
	
	SET @LogicalKey = 'Country Name'

	IF (@IdRegion IS NOT NULL)
	BEGIN
		IF NOT EXISTS( SELECT *
		FROM REGIONS AS R(TABLOCKX)
		WHERE 	R.[id] = @IdRegion) 
		BEGIN
			RAISERROR('The selected region does not exist anymore',16,1)
			RETURN
		END
	END

	IF NOT EXISTS( SELECT *
	FROM CURRENCIES AS C(TABLOCKX)
	WHERE 	C.[Id] = @IdCurrency) 
	BEGIN
		RAISERROR('The selected currency does not exist anymore',16,1)
		RETURN
	END

	IF EXISTS( SELECT *
	FROM COUNTRIES AS C(TABLOCKX)
	WHERE 	C.[Name] = @Name) 
	SET @ValidateLogicKey = 1

	IF EXISTS( SELECT *
	FROM COUNTRIES AS C
	WHERE 	C.Code = @Code) 
	BEGIN
		SET @ValidateLogicKey = 1
		SET @LogicalKey= 'Code'
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

	SELECT @Id = ISNULL(MAX(C.[Id]), 0) + 1
	FROM COUNTRIES AS C (TABLOCKX)

	DECLARE @RetVal INT	

	exec @RetVal = catUpdateCatalogRank 'COUNTRIES', @Rank,1,NULL
	IF (@@ERROR <> 0 OR @RetVal < 0)
		return -3

	INSERT INTO COUNTRIES ([Id],Code,[Name],IdRegion,IdCurrency,Email, [Rank])
	VALUES       (@Id,@Code,@Name,@IdRegion,@IdCurrency, @Email,@Rank)

	--Insert the 7 corresponding GL Accounts only if this country is an InergyCountry (it has a region)
	IF (@IdRegion IS NOT NULL)
	BEGIN
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
			EXEC @RetVal = catInsertGlAccount @Id, @DefaultAccountCostIncome, @NameCostIncome, @IdCostIncome
			IF (@@ERROR <> 0 OR @RetVal < 0)
			BEGIN
				CLOSE CostIncomeCursor
				DEALLOCATE CostIncomeCursor
				RETURN -4
			END
			FETCH NEXT FROM CostIncomeCursor INTO @IdCostIncome, @NameCostIncome, @DefaultAccountCostIncome		
		END
		CLOSE CostIncomeCursor
		DEALLOCATE CostIncomeCursor
	END

	----------------------------------------Insert the null associate for this country---------------------------------------------
	DECLARE @NullEmpNo VARCHAR(15)
	DECLARE @NullInergyLogin VARCHAR(50)
	DECLARE @NullName VARCHAR(50)
	--change null associate : Issue 0051621
	SET @NullEmpNo = '0'
	SET @NullInergyLogin = @Code + '\null'
	set @NullName = 'NA, cost or sales'

	EXEC catInsertAssociate @Id, @NullEmpNo, @NullName,@NullInergyLogin, 0, 0, 0
	-------------------------------------------------------------------------------------------------------------------------------
	RETURN @Id

END
GO

