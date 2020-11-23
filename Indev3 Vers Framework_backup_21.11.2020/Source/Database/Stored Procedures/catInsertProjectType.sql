--Drops the Procedure catInsertProjectType if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertProjectType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertProjectType
GO
CREATE PROCEDURE catInsertProjectType
	@Type	VARCHAR(20),		--The Type of the Project Type you want to Insert
	@Rank	INT	
AS
DECLARE @Id			INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT
	
	SET @LogicalKey = 'Type'

	IF EXISTS( SELECT *
	FROM PROJECT_TYPES AS PT
	WHERE 	PT.[Type] = @Type) 
	SET @ValidateLogicKey = 1
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@Type IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	SELECT @Id = ISNULL(MAX(PT.[Id]), 0) + 1
	FROM PROJECT_TYPES AS PT (HOLDLOCK)
	
	exec @RetVal = catUpdateCatalogRank 'PROJECT_TYPES', @Rank,1,NULL

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	INSERT INTO PROJECT_TYPES ([Id],Type, [Rank])
	VALUES		          (@Id,@Type, @Rank)
	
	RETURN @Id
GO

