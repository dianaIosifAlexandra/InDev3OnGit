--Drops the Procedure catUpdateDepartment if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateDepartment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateDepartment
GO
CREATE PROCEDURE catUpdateDepartment
	@Id		INT,			--The Id of the selected Department
	@IdFunction	INT,		--The Id of the function that coresponds to this Department
	@Name		VARCHAR(50),	--The Name of the Department you want to Insert
	@Rank		INT
	
AS
DECLARE @Rowcount 		INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT
	
	SET @LogicalKey = 'Name'

	IF EXISTS( SELECT *
	FROM DEPARTMENTS AS D
	WHERE 	D.[Name] = @Name AND 
		D.[Id] <> @Id) 
	SET @ValidateLogicKey = 1
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@IdFunction IS NULL OR 
	   @Name IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	exec @RetVal = catUpdateCatalogRank 'DEPARTMENTS', @Rank,2, @Id

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	UPDATE DEPARTMENTS 	
	SET IdFunction = @IdFunction,
	    [Name] = @Name,
            [Rank] = @Rank
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

