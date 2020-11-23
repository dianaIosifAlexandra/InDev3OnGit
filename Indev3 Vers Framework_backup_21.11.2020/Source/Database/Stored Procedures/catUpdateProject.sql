--Drops the Procedure catUpdateProject if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateProject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateProject
GO
CREATE PROCEDURE catUpdateProject
	@Id		INT,		--The Id of the selected Project
	@Code		VARCHAR(10) = NULL,	--The Code of the Project you want to Insert
	@Name		VARCHAR(50) = NULL,	--The Name of the Project you want to Insert
	@IdProgram	INT = NULL,		--The Program related to this project
	@IdProjectType	INT = NULL,		--The type of the project 
	@IsActive	BIT = NULL		--This option shos if the project is active or not	
AS
DECLARE @Rowcount 		INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)
	
	SET @LogicalKey = 'Code'

	IF EXISTS( SELECT *
	FROM PROJECTS AS P
	WHERE 	P.Code = @Code AND
		P.[Id] <> @Id) 
	SET @ValidateLogicKey = 1
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@Code IS NULL OR 
	   @IdProgram IS NULL OR 
	   @Name IS NULL OR 
	   @IdProjectType IS NULL OR 
	   @IsActive IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	UPDATE PROJECTS 	
	SET Code = @Code,
	    [Name] = @Name,
	    IdProgram = @IdProgram,
	    IdProjectType = @IdProjectType,
	    IsActive = @IsActive
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

