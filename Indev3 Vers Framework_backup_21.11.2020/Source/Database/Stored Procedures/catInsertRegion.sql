--Drops the Procedure catInsertRegion if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertRegion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertRegion
GO
CREATE PROCEDURE catInsertRegion
	@Code	VARCHAR(8),	--The Code of thge Region you want to Insert
	@Name	VARCHAR(50),	--The Name of the Region you want to Insert
	@Rank INT		
	
AS
DECLARE @Id			INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT
	
	SET @LogicalKey = 'Code'

	IF EXISTS( SELECT *
	FROM REGIONS AS R
	WHERE 	R.Code = @Code) 
	SET @ValidateLogicKey = 1

	IF EXISTS( SELECT *
	FROM REGIONS AS R
	WHERE 	R.[Name] = @Name) 
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

	IF(@Code IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	SELECT @Id = ISNULL(MAX(R.[Id]), 0) + 1
	FROM REGIONS AS R (TABLOCKX)

	exec @RetVal = catUpdateCatalogRank 'Regions', @Rank,1,NULL

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	INSERT INTO REGIONS ([Id],Code,[Name],[Rank])
	VALUES		    (@Id,@Code,@Name, @Rank)
	
	RETURN @Id
GO

