--Drops the Procedure catUpdateProjectType if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateProjectType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateProjectType
GO
CREATE PROCEDURE catUpdateProjectType
	@Id		INT,		--The Id of the selected Project Type
 	@Type		VARCHAR(20),	--The Type of the Project Type you want to Update
	@Rank		INT
AS
DECLARE @IdUpdate	INT,
	@Rowcount 	INT

DECLARE	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT
	
	SET @LogicalKey = 'Type'

	IF EXISTS( SELECT *
	FROM PROJECT_TYPES AS PT
	WHERE 	PT.[Type] = @Type AND
		PT.[Id] <> @Id) 
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
	
	exec @RetVal = catUpdateCatalogRank 'PROJECT_TYPES', @Rank,2, @Id

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	UPDATE PROJECT_TYPES 	
	SET Type = @Type,
	    [Rank] = @Rank
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

