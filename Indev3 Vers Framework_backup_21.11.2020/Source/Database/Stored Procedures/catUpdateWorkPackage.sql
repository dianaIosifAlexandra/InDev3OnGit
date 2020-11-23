--Drops the Procedure catUpdateWorkPackage if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateWorkPackage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateWorkPackage
GO
CREATE PROCEDURE catUpdateWorkPackage
	@Id		INT,		--The Id of the selected WorkPackage
	@IdPhase	INT,		--The Id of the Phase that is connected to the Work Package you want to insert
 	@Code		VARCHAR(3),	--The Code of the Work Package you want to Insert
	@Name		VARCHAR(50),	--The Name of the Work Package you want to Insert
	@Rank		INT,		--The Rank of the Work Package you want to Insert
	@IdProject	INT,		--The Project related to this Work Package
	@IsActive	BIT,		--Specifies if the Work Package is Active or not
	@StartYearMonth	INT,	--The Start Date of the work Package
	@EndYearMonth	INT,	--The End Date of the work Package
	@LastUserUpdate	INT		--The Last User Update of the work Package	
AS

	DECLARE @RetVal INT

--validation yearmonth section
Declare	@ErrorMessage		VARCHAR(255),
	@YMValidationResult	INT

	--Identify the original IdPhase
	DECLARE @IdPhase_Original int

 	SELECT @IdPhase_Original = WP.IdPhase
	FROM WORK_PACKAGES AS WP
	WHERE 	WP.Code = @Code AND
		WP.IdProject = @IdProject


if (@StartYearMonth is not null)
begin
	-- verify if the yearmonth value is valid
	Select @YMValidationResult = ValidationResult,
	       @ErrorMessage = ErrorMessage
	from fnValidateYearMonth(@StartYearMonth)

	if (@YMValidationResult < 0)
	begin
	 	RAISERROR(@ErrorMessage, 16, 1)
		RETURN -2
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
		RETURN -3
	end
end
--end validation section

DECLARE @Rowcount 		INT,
	@ValidateLogicKey	BIT,
	@LogicalKey		VARCHAR(30)
	
	SET @LogicalKey = 'Code, Project'

	IF EXISTS( SELECT *
	FROM WORK_PACKAGES AS WP
	WHERE 	WP.Code = @Code AND
		WP.IdProject = @IdProject AND
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
	   @IdProject IS NULL OR 
	   @IsActive IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -5		
	END



	--If this work package has data in any budget and the startYM or endYM is null, raise an error
	IF 
	(
		EXISTS 
		(
			SELECT 	IdWorkPackage
			FROM 	BUDGET_INITIAL_DETAIL
			WHERE	IdProject = @IdProject AND
				IdPhase = @IdPhase_Original AND
				IdWorkPackage = @Id
		)
		OR
		EXISTS 
		(
			SELECT 	IdWorkPackage
			FROM 	BUDGET_REVISED_DETAIL
			WHERE	IdProject = @IdProject AND
				IdPhase = @IdPhase_Original AND
				IdWorkPackage = @Id
		)
		OR
		EXISTS 
		(
			SELECT 	IdWorkPackage
			FROM 	BUDGET_TOCOMPLETION_DETAIL
			WHERE	IdProject = @IdProject AND
				IdPhase = @IdPhase_Original AND
				IdWorkPackage = @Id
		)
	)
	BEGIN
		IF (@StartYearMonth IS NULL OR @EndYearMonth IS NULL)
		BEGIN
			RAISERROR('This Work Package must have the period correctly defined because it contains budget data. ', 16, 1)
			RETURN -6
		END
	END

	--Check if the period has changed (the updated values of startyearmonth and endyearmonth are different than
	--the ones already saved in the database
	DECLARE @OldStartYearMonth INT
	DECLARE @OldEndYearMonth INT

	SELECT 	@OldStartYearMonth = StartYearMonth,
		@OldEndYearMonth = EndYearMonth
	FROM 	WORK_PACKAGES
	WHERE 	IdProject = @IdProject AND
		IdPhase = @IdPhase_Original AND
		[Id] = @Id
	
	IF (@OldStartYearMonth <> @StartYearMonth OR @OldEndYearMonth <> @EndYearMonth)
	BEGIN
		IF 
		(
			EXISTS 
			(
				SELECT 	IdWorkPackage
				FROM 	BUDGET_TOCOMPLETION_DETAIL
				WHERE	IdProject = @IdProject AND
					IdPhase = @IdPhase_Original AND
					IdWorkPackage = @Id
			)
		)
		BEGIN
			EXEC @RetVal = bgtUpdateToCompletionWPPeriod @IdProjectParam = @IdProject, @IdPhaseParam = @IdPhase_Original, @IdWP = @Id, @StartYearMonth = @StartYearMonth, @EndYearMonth = @EndYearMonth
			IF (@@ERROR<>0 OR @RetVal < 0)
				RETURN -7
		END

		IF 
		(
			EXISTS 
			(
				SELECT 	IdWorkPackage
				FROM 	BUDGET_REVISED_DETAIL
				WHERE	IdProject = @IdProject AND
					IdPhase = @IdPhase_Original AND
					IdWorkPackage = @Id
			)
		)
		BEGIN
			EXEC @RetVal = bgtUpdateRevisedWPPeriod @IdProjectParam = @IdProject, @IdPhaseParam = @IdPhase_Original, @IdWP = @Id, @StartYearMonth = @StartYearMonth, @EndYearMonth = @EndYearMonth
			IF (@@ERROR<>0 OR @RetVal < 0)
				RETURN -8
		END

		IF 
		(
			EXISTS 
			(
				SELECT 	IdWorkPackage
				FROM 	BUDGET_INITIAL_DETAIL
				WHERE	IdProject = @IdProject AND
					IdPhase = @IdPhase_Original AND
					IdWorkPackage = @Id
			)
		)
		BEGIN
			EXEC @RetVal = bgtUpdateInitialWPPeriod @IdProjectParam = @IdProject, @IdPhaseParam = @IdPhase_Original, @IdWP = @Id, @StartYearMonth = @StartYearMonth, @EndYearMonth = @EndYearMonth
			IF (@@ERROR<>0 OR @RetVal < 0)
				RETURN -9
		END
	END

	exec @RetVal = catUpdateWorkPackageRank 'WORK_PACKAGES', @Rank,2, @Id, @IdProject, @IdPhase_Original

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -10


	--check to see if idphase has changed
	IF @IdPhase <> @IdPhase_Original
	BEGIN
		--Update old record with a new code for unique constraint reasons
		DECLARE @TempWPCode varchar(3)
		select @TempWPCode = '_' + RIGHT( CAST(DATEPART(ms,GETDATE()) as VARCHAR(100)),2)	
--  		PRINT @TempWPCode


		UPDATE WORK_PACKAGES 	
		SET   	Code = @TempWPCode
		WHERE 	[Id] = @Id AND
			IdPhase = @IdPhase_Original AND
			IdProject = @IdProject

		--create new record with new data

-- 		get a new max rank
		DECLARE @NewRank int
		SELECT @NewRank = dbo.fnGetWorkPackageMaxRank()	
		

		DECLARE @IdWorkPackageNew int		
		exec @IdWorkPackageNew = catInsertWorkPackage @IdPhase, @Code, @Name, @NewRank, @IdProject, @IsActive, @StartYearMonth, @EndYearMonth, @LastUserUpdate
		
		IF(@@ERROR<>0 OR @IdWorkPackageNew < 0)
			return -11
		
		--UPDATE RELATED TABLES

		exec @RetVal = catUpdateWPKeyReferences @IdProject, @IdPhase, @IdWorkPackageNew, @Id, @IdPhase_Original
		IF(@@ERROR<>0 OR @RetVal < 0)
			return -12
		--delete old record from workpackage		
		

		exec  catDeleteWorkPackage @IdProject, @IdPhase_Original,@Id 
		SET @Rowcount = @@ROWCOUNT	
	END
	ELSE
	BEGIN

		UPDATE WORK_PACKAGES 	
		SET   	Code = @Code,
			[Name] = @Name,
			Rank = @Rank,
			IsActive = @IsActive,
			StartYearMonth = @StartYearMonth,
			EndYearMonth = @EndYearMonth,
			LastUpdate = GETDATE(),
			LastUserUpdate = @LastUserUpdate
		WHERE 	[Id] = @Id AND
			IdPhase = @IdPhase AND
			IdProject = @IdProject

		SET @Rowcount = @@ROWCOUNT

	END
	
	RETURN @Rowcount

GO

