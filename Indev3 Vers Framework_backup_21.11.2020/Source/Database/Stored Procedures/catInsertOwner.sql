--Drops the Procedure catInsertOwner if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertOwner]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertOwner
GO
CREATE PROCEDURE catInsertOwner
	@Code		VARCHAR(10),	--The Code of the Owner you want to Insert
	@Name		VARCHAR(30),	--The Name of the Owner you want to Insert
	@IdOwnerType	INT,		--The Type of the Owner
	@Rank		INT
	
AS
DECLARE @Id			INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT
	
	--Owner Type catalogue does not have a UI so no chack should be done on this field

	SET @LogicalKey = 'Code'
	IF EXISTS( SELECT *
		FROM OWNERS AS O(nolock)
		WHERE 	O.Code = @Code) 
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	SET @LogicalKey= 'Name'
	IF EXISTS( SELECT *
		FROM OWNERS AS O(nolock)
		WHERE 	O.Name = @Name) 
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2
	END


	IF(@Code IS NULL OR 
	   @IdOwnerType IS NULL OR 
	   @Name IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -3		
	END

	SELECT @Id = ISNULL(MAX(O.[Id]), 0) + 1
	FROM OWNERS AS O (TABLOCKX)
	
	exec @RetVal = catUpdateCatalogRank 'OWNERS', @Rank,1,NULL

	IF (@@ERROR<>0 OR @RetVal < 0)
		return -4

	INSERT INTO OWNERS ([Id],Code,[Name],IdOwnerType, [Rank])
	VALUES		   (@Id,@Code,@Name,@IdOwnerType, @Rank)
	
	RETURN @Id
GO

