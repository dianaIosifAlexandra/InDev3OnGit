--Drops the Procedure catInsertWorkPackage if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertWorkPackage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertWorkPackage
GO
CREATE PROCEDURE catInsertWorkPackage
	@IdPhase	INT,		--The Id of the Phase that is connected to the Work Package you want to insert
 	@Code		VARCHAR(3),	--The Code of the Work Package you want to Insert
	@Name		VARCHAR(50),	--The Name of the Work Package you want to Insert
	@Rank		INT,		--The Rank Number of the Work Package you want to Insert
	@IdProject	INT,		--The Project related to this Work Package
	@IsActive	BIT,		--Specifies if the Work Package is Active or not
	@StartYearMonth	INT,		--The Start Date of the work Package
	@EndYearMonth	INT,		--The End Date of the work Package
	@LastUserUpdate	INT		--The Last User Update of the work Package	
AS

	DECLARE @RetVal INT
	--The Phase catalogue does not have a UI so no check is required for this catalogue

	IF NOT EXISTS( SELECT *
	FROM PROJECTS AS P(TABLOCKX)
	WHERE 	P.[Id] = @IdProject) 
	BEGIN
		RAISERROR('The selected project does not exists anymore',16,1)
		RETURN
	END

	--validation yearmonth section
	Declare	@ErrorMessage		VARCHAR(255),
		@YMValidationResult	INT
	
	if (@StartYearMonth is not null)
	begin
		-- verify if the yearmonth value is valid
		Select @YMValidationResult = ValidationResult,
		       @ErrorMessage = ErrorMessage
		from fnValidateYearMonth(@StartYearMonth)
	
		if (@YMValidationResult < 0)
		begin
		 	RAISERROR(@ErrorMessage, 16, 1)
			RETURN -1
		end
	end
	
	if (@EndYearMonth is not null)
	begin
		-- verify if the yearmonth value is valid
		Select @YMValidationResult = ValidationResult,
		       @ErrorMessage = ErrorMessage
		from fnValidateYearMonth(@EndYearMonth)
	
		if (@YMValidationResult < 0)
		begin
		 	RAISERROR(@ErrorMessage, 16, 1)
			RETURN -2
		end
	end
	--end validation section

DECLARE @Id			INT,
	@ValidateLogicKey	BIT,
	@LogicalKey		VARCHAR(20)
	
	SET @LogicalKey = 'Code, Project'

	IF EXISTS( SELECT *
	FROM WORK_PACKAGES AS WP
	WHERE 	WP.Code = @Code AND
		WP.IdProject = @IdProject) 
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
	   @IdProject IS NULL OR 
	   @IsActive IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	SELECT @Id = ISNULL(MAX(WP.[Id]), 0) + 1
	FROM WORK_PACKAGES AS WP (TABLOCKX)
	WHERE 	WP.IdProject = @IdProject AND 
		WP.IdPhase = @IdPhase

	exec @RetVal = catUpdateWorkPackageRank 'WORK_PACKAGES', @Rank,1,NULL, @IdProject, @IdPhase

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	INSERT INTO WORK_PACKAGES ([Id],IdPhase,Code,[Name], Rank, IdProject, IsActive, StartYearMonth, EndYearMonth, LastUpdate, LastUserUpdate)
	VALUES		          (@Id,@IdPhase,@Code,@Name,@Rank,@IdProject,@IsActive,@StartYearMonth,@EndYearMonth,GETDATE(),@LastUserUpdate)

	
	RETURN @Id
GO

