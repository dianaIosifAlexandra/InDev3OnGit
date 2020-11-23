--Drops the Procedure catInsertGlAccount if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertGlAccount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertGlAccount
GO
CREATE PROCEDURE catInsertGlAccount
	@IdCountry	INT,
 	@Account	VARCHAR(20),	--The Code of the Inergy Location you want to Insert
	@Name		VARCHAR(30),	--The Name of the Inergy Location you want to Insert
	@IdCostType	INT		--The Id of the cost type related to the GL_ACCOUNT you want to insert
AS
DECLARE @Id			INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)
	
	IF NOT EXISTS( SELECT *
	FROM COUNTRIES AS C(TABLOCKX)
	WHERE 	C.[Id] = @IdCountry) 
	BEGIN
		RAISERROR('The selected country does not exists anymore',16,1)
		RETURN
	END

	SET @LogicalKey = 'Country, Account'

	IF EXISTS( SELECT *
	FROM GL_ACCOUNTS AS GA(TABLOCKX)
	WHERE 	GA.Account = @Account AND 
		GA.IdCountry = @IdCountry) 
	SET @ValidateLogicKey = 1
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@IdCountry IS NULL OR 
	   @Account IS NULL OR 
	   @Name IS NULL OR 
	   @IdCostType IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	SELECT @Id = ISNULL(MAX(GA.[Id]), 0) + 1
	FROM GL_ACCOUNTS AS GA (TABLOCKX)
	WHERE IdCountry = @IdCountry 
	
	INSERT INTO GL_ACCOUNTS ([Id],IdCountry,Account,[Name],IdCostType)
	VALUES		   	(@Id,@IdCountry,@Account,@Name,@IdCostType)
	
	RETURN @Id
GO

