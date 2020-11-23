--Drops the Procedure catInsertProject if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertProject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertProject
GO
CREATE PROCEDURE catInsertProject
	@Code		VARCHAR(10),	--The Code of the Project you want to Insert
	@Name		VARCHAR(50),	--The Name of the Project you want to Insert
	@IdProgram	INT,		--The Program related to this project
	@IdProjectType	INT,		--The type of the project 
	@IsActive	BIT,		--This option shos if the project is active or not
	@UseWorkPackageTemplate bit,
	@IdAssociate int
AS
DECLARE @Id			INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)
	
	IF NOT EXISTS( SELECT *
	FROM PROGRAMS AS P(TABLOCKX)
	WHERE 	P.[Id] = @IdProgram) 
	BEGIN
		RAISERROR('The selected program does not exists anymore',16,1)
		RETURN
	END

	IF NOT EXISTS( SELECT *
	FROM PROJECT_TYPES AS PT(TABLOCKX)
	WHERE 	PT.[Id] = @IdProjectType) 
	BEGIN
		RAISERROR('The selected project type does not exists anymore',16,1)
		RETURN
	END

	SET @LogicalKey = 'Code'

	IF EXISTS( SELECT *
	FROM PROJECTS AS P
	WHERE 	P.Code = @Code) 
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
		RETURN -3		
	END

	SELECT @Id = ISNULL(MAX(P.[Id]), 0) + 1
	FROM PROJECTS AS P (TABLOCKX)
	
	INSERT INTO PROJECTS ([Id],Code,[Name],IdProgram,IdProjectType,IsActive)
	VALUES		     (@Id,@Code,@Name,@IdProgram,@IdProjectType,@IsActive)


	IF (@Id > 0 and @UseWorkPackageTemplate = 1)
	BEGIN

		EXEC   catInsertWorkPackagesfromTemplate  @Id, @IdAssociate 

		IF(@@ERROR<>0)
		begin
		RAISERROR('Add work package error',16,1)
		RETURN -4
		end
	END
	
	RETURN @Id
GO

