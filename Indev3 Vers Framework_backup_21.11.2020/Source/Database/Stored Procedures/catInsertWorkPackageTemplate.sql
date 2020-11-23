--Drops the Procedure catInsertWorkPackageTemplate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertWorkPackageTemplate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertWorkPackageTemplate
GO
CREATE PROCEDURE catInsertWorkPackageTemplate
	@IdPhase	INT,		--The Id of the Phase that is connected to the Work Package you want to insert
 	@Code		VARCHAR(3),	--The Code of the Work Package you want to Insert
	@Name		VARCHAR(50),	--The Name of the Work Package you want to Insert
	@Rank		INT,		--The Rank Number of the Work Package you want to Insert
	@IsActive	BIT,		--Specifies if the Work Package is Active or not
	@LastUserUpdate	INT		--The Last User Update of the work Package	
AS

	DECLARE @RetVal INT
	--The Phase catalogue does not have a UI so no check is required for this catalogue

	
	DECLARE @Id			INT,
	@ValidateLogicKey	BIT,
	@LogicalKey		VARCHAR(20),
	@ErrorMessage		VARCHAR(255)

	SET @LogicalKey = 'Code'

	IF EXISTS( SELECT *
	FROM WORK_PACKAGES_TEMPLATE AS WP
	WHERE 	WP.Code = @Code) 
	SET @ValidateLogicKey = 1
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@IdPhase IS NULL OR 
	   @Code IS NULL OR 
	   @Name IS NULL OR 
	   @Rank IS NULL OR 
	   @IsActive IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	SELECT @Id = ISNULL(MAX(WP.[Id]), 0) + 1
	FROM WORK_PACKAGES_TEMPLATE AS WP (TABLOCKX)
	WHERE 	WP.IdPhase = @IdPhase

	exec @RetVal = catUpdateWorkPackageTemplateRank 'WORK_PACKAGES_TEMPLATE', @Rank,1,NULL, @IdPhase

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	INSERT INTO WORK_PACKAGES_TEMPLATE ([Id],IdPhase,Code,[Name], Rank, IsActive, LastUpdate, LastUserUpdate)
	VALUES		          (@Id,@IdPhase,@Code,@Name,@Rank,@IsActive,GETDATE(),@LastUserUpdate)

	
	RETURN @Id
GO

