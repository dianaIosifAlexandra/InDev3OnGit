--Drops the Procedure catUpdateRegion if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateRegion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateRegion
GO
CREATE PROCEDURE catUpdateRegion
	@Id	INT,		--The Id of the selected Region
	@Code	VARCHAR(8),	--The Code of the Region you want to Update
	@Name	VARCHAR(50),	--The Name of the Region you want to Update
	@Rank INT
AS
DECLARE @Rowcount 		INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT
	
	SET @LogicalKey = 'Code'

	IF EXISTS( SELECT *
	FROM REGIONS AS R
	WHERE 	R.Code = @Code AND
		R.[Id] <> @Id) 
	SET @ValidateLogicKey = 1

	IF EXISTS( SELECT *
	FROM REGIONS AS R
	WHERE 	R.[Name] = @Name AND R.[Id] <> @Id)  
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

	exec @RetVal = catUpdateCatalogRank 'Regions', @Rank,2, @Id
	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	UPDATE REGIONS 	
	SET 	Code = @Code,
		[Name] = @Name,
		[Rank] = @Rank
	WHERE [Id] = @Id	

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

