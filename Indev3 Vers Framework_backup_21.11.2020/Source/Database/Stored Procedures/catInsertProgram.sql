--Drops the Procedure catInsertProgram if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertProgram]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertProgram
GO
CREATE PROCEDURE catInsertProgram
	@IdOwner	INT,		--The Id of the Owner that is connected to the Program you want to insert
	@Code		VARCHAR(10),	--The Code of the Program you want to Insert
 	@Name		VARCHAR(50),	--The Name of the Program you want to Insert
	@IsActive	BIT,		--Shows if the Program is Active or not
	@Rank INT
AS
DECLARE @Id			INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT
	
	IF NOT EXISTS( SELECT *
	FROM OWNERS AS O(TABLOCKX)
	WHERE 	O.[Id] = @IdOwner) 
	BEGIN
		RAISERROR('The selected owner does not exists anymore',16,1)
		RETURN
	END
	
	SET @LogicalKey = 'Code'

	IF EXISTS( SELECT *
	FROM PROGRAMS AS P
	WHERE 	P.Code = @Code) 
	SET @ValidateLogicKey = 1

	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@IdOwner IS NULL OR 
	   @Code IS NULL OR 
	   @Name IS NULL OR 
	   @IsActive IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	SELECT @Id = ISNULL(MAX(P.[Id]), 0) + 1
	FROM PROGRAMS AS P (TABLOCKX)

	exec @RetVal = catUpdateCatalogRank 'PROGRAMS', @Rank,1,NULL

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	INSERT INTO PROGRAMS ([Id],Code,[Name],IdOwner,IsActive, [Rank])
	VALUES		     (@Id,@Code,@Name,@IdOwner,@IsActive, @Rank)
	
	RETURN @Id
GO

