--Drops the Procedure catUpdateOwner if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateOwner]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateOwner
GO
CREATE PROCEDURE catUpdateOwner
	@Id		INT,		--The Id of the selected Owner
	@Code		VARCHAR(10),	--The Code of the Owner you want to Insert
	@Name		VARCHAR(30),	--The Name of the Owner you want to Insert
	@IdOwnerType	INT,		--The Type of the Owner
	@Rank		INT
	
AS
DECLARE @Rowcount 		INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT
	
	SET @LogicalKey = 'Code'

	IF EXISTS( SELECT *
	FROM OWNERS AS O
	WHERE 	O.Code = @Code AND
		O.[Id] <> @Id) 
	SET @ValidateLogicKey = 1
	

	IF EXISTS( SELECT *
	FROM OWNERS AS O
	WHERE 	O.[Name] = @Name AND
		O.[Id] <> @Id)  
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
	   @IdOwnerType IS NULL OR 
	   @Name IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	exec  @RetVal = catUpdateCatalogRank 'OWNERS', @Rank,2, @Id

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	UPDATE OWNERS 	
	SET Code = @Code,
	    [Name] = @Name,
	    IdOwnerType = @IdOwnerType,
	    [Rank] = @Rank
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

