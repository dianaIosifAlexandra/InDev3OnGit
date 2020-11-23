--Drops the Procedure catUpdateWorkPackageTemplate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateWorkPackageTemplate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateWorkPackageTemplate
GO
CREATE PROCEDURE catUpdateWorkPackageTemplate
	@Id		INT,		--The Id of the selected WorkPackage
	@IdPhase	INT,		--The Id of the Phase that is connected to the Work Package you want to insert
 	@Code		VARCHAR(3),	--The Code of the Work Package you want to Insert
	@Name		VARCHAR(50),	--The Name of the Work Package you want to Insert
	@Rank		INT,		--The Rank of the Work Package you want to Insert
	@IsActive	BIT,		--Specifies if the Work Package is Active or not
	@LastUserUpdate	INT		--The Last User Update of the work Package	
AS

	DECLARE @RetVal INT

Declare	@ErrorMessage		VARCHAR(255)

	--Identify the original IdPhase
	DECLARE @IdPhase_Original int

 	SELECT @IdPhase_Original = WP.IdPhase
	FROM WORK_PACKAGES_TEMPLATE AS WP
	WHERE 	WP.Code = @Code




DECLARE @Rowcount 		INT,
	@ValidateLogicKey	BIT,
	@LogicalKey		VARCHAR(30)
	
	SET @LogicalKey = 'Code'

	IF EXISTS( SELECT *
	FROM WORK_PACKAGES_TEMPLATE AS WP
	WHERE 	WP.Code = @Code AND
		WP.[Id] <> @Id) 
	SET @ValidateLogicKey = 1
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -4
	END

	IF(@IdPhase IS NULL OR 
	   @Code IS NULL OR 
	   @Name IS NULL OR 
	   @Rank IS NULL OR 
	   @IsActive IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -5		
	END

	exec @RetVal = catUpdateWorkPackageTemplateRank 'WORK_PACKAGES_TEMPLATE', @Rank,2, @Id, @IdPhase_Original

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -10


	--check to see if idphase has changed
	IF @IdPhase <> @IdPhase_Original
	BEGIN
		--Update old record with a new code for unique constraint reasons
		DECLARE @TempWPCode varchar(3)
		select @TempWPCode = '_' + RIGHT( CAST(DATEPART(ms,GETDATE()) as VARCHAR(100)),2)	
--  		PRINT @TempWPCode


		UPDATE WORK_PACKAGES_TEMPLATE 	
		SET   	Code = @TempWPCode
		WHERE 	[Id] = @Id AND
			IdPhase = @IdPhase_Original

		--create new record with new data

-- 		get a new max rank
		DECLARE @NewRank int
		SELECT @NewRank = dbo.fnGetWorkPackageTemplateMaxRank()	
		

		DECLARE @IdWorkPackageTemplateNew int		
		exec @IdWorkPackageTemplateNew = catInsertWorkPackageTemplate @IdPhase, @Code, @Name, @NewRank, @IsActive, @LastUserUpdate
		
		IF(@@ERROR<>0 OR @IdWorkPackageTemplateNew < 0)
			return -11
		
		exec  catDeleteWorkPackageTemplate @IdPhase_Original,@Id 
		SET @Rowcount = @@ROWCOUNT	
	END
	ELSE
	BEGIN

		UPDATE WORK_PACKAGES_TEMPLATE 	
		SET   	Code = @Code,
			[Name] = @Name,
			Rank = @Rank,
			IsActive = @IsActive,
			LastUpdate = GETDATE(),
			LastUserUpdate = @LastUserUpdate
		WHERE 	[Id] = @Id AND
			IdPhase = @IdPhase

		SET @Rowcount = @@ROWCOUNT

	END
	
	RETURN @Rowcount

GO

