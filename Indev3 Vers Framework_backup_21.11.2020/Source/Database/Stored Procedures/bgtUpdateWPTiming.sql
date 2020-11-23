--Drops the Procedure bgtUpdateWPTiming if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateWPTiming]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateWPTiming
GO
CREATE PROCEDURE bgtUpdateWPTiming
	@IdProject		INT,		
	@IdPhase		INT,		
	@IdWP			INT,		
	@StartYearMonth		INT,
	@EndYearMonth		INT,
	@LastUserUpdate		INT,
	@WPCode			VARCHAR(3)
AS

	Declare	@ErrorMessage		VARCHAR(255),
		@YMValidationResult	INT
--validate that record tring to be updated exists in work_packages catalog
	IF @WPCode IS NOT NULL AND NOT EXISTS(
			SELECT [Id] 
			FROM WORK_PACKAGES
			WHERE IdProject = @IdProject AND			      
			      IdPhase = @IdPhase AND
			      [Id] = @IdWP AND
			      Code = @WpCode
			)
	BEGIN
	SET @ErrorMessage = 'Key information about WP with code ' + @WPCode + '  has been changed by another user. Please refresh your information.'
	RAISERROR(@ErrorMessage, 16, 1)
		RETURN -1
	END

--validation yearmonth section
	
	
	DECLARE @RetVal INT

	if (@StartYearMonth <> -1)
	BEGIN
		-- verify if the yearmonth value is valid
		Select @YMValidationResult = ValidationResult,
		       @ErrorMessage = ErrorMessage
		from fnValidateYearMonth(@StartYearMonth)
	
		if (@YMValidationResult < 0)
		begin
		 	RAISERROR(@ErrorMessage, 16, 1)
			RETURN -1
		end
	END

	if (@EndYearMonth <> -1)
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


	--If this work package has data in any budget and the startYM or endYM is -1, raise an error
	IF 
	(
		EXISTS 
		(
			SELECT 	IdWorkPackage
			FROM 	BUDGET_INITIAL_DETAIL
			WHERE	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @IdWP
		)
		OR
		EXISTS 
		(
			SELECT 	IdWorkPackage
			FROM 	BUDGET_REVISED_DETAIL
			WHERE	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @IdWP
		)
		OR
		EXISTS 
		(
			SELECT 	IdWorkPackage
			FROM 	BUDGET_TOCOMPLETION_DETAIL
			WHERE	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @IdWP
		)
	)
	BEGIN
		IF (@StartYearMonth = -1 OR @EndYearMonth = -1)
		BEGIN
			RAISERROR('This Work Package must have the period correctly defined because it contains budget data. ', 16, 1)
			RETURN -3
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
		IdPhase = @IdPhase AND
		[Id] = @IdWP
	
	IF (@OldStartYearMonth <> @StartYearMonth OR @OldEndYearMonth <> @EndYearMonth)
	BEGIN
		IF 
		(
			EXISTS 
			(
				SELECT 	IdWorkPackage
				FROM 	BUDGET_TOCOMPLETION_DETAIL
				WHERE	IdProject = @IdProject AND
					IdPhase = @IdPhase AND
					IdWorkPackage = @IdWP
			)
		)
		BEGIN
			EXEC @RetVal = bgtUpdateToCompletionWPPeriod @IdProjectParam = @IdProject, @IdPhaseParam = @IdPhase, @IdWP = @IdWP, @StartYearMonth = @StartYearMonth, @EndYearMonth = @EndYearMonth
			IF (@@ERROR <> 0 OR @RetVal < 0)
			RETURN -4
		END

		IF 
		(
			EXISTS 
			(
				SELECT 	IdWorkPackage
				FROM 	BUDGET_REVISED_DETAIL
				WHERE	IdProject = @IdProject AND
					IdPhase = @IdPhase AND
					IdWorkPackage = @IdWP
			)
		)
		BEGIN
			EXEC @RetVal = bgtUpdateRevisedWPPeriod @IdProjectParam = @IdProject, @IdPhaseParam = @IdPhase, @IdWP = @IdWP, @StartYearMonth = @StartYearMonth, @EndYearMonth = @EndYearMonth
			IF (@@ERROR <> 0 OR @RetVal < 0)
				RETURN -5
		END

		IF 
		(
			EXISTS 
			(
				SELECT 	IdWorkPackage
				FROM 	BUDGET_INITIAL_DETAIL
				WHERE	IdProject = @IdProject AND
					IdPhase = @IdPhase AND
					IdWorkPackage = @IdWP
			)
		)
		BEGIN
			EXEC @RetVal = bgtUpdateInitialWPPeriod @IdProjectParam = @IdProject, @IdPhaseParam = @IdPhase, @IdWP = @IdWP, @StartYearMonth = @StartYearMonth, @EndYearMonth = @EndYearMonth
			IF (@@ERROR <> 0 OR @RetVal < 0)
				RETURN -6
		END
	END

	DECLARE @Rowcount INT
	--We will always find a WP corresponding - no testing condition should be done
	
	UPDATE WORK_PACKAGES
	SET
		StartYearMonth = (CASE  
					WHEN @StartYearMonth = -1 THEN NULL
					ELSE @StartYearMonth
				END),
		EndYearMonth = (CASE  
					WHEN @EndYearMonth = -1 THEN NULL
					ELSE @EndYearMonth
				END),
		LastUserUpdate = @LastUserUpdate,
		LastUpdate = GETDATE()
	WHERE 	IdProject= @IdProject AND
		IdPhase = @IdPhase AND
		Id = @IdWP
	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
				
GO



