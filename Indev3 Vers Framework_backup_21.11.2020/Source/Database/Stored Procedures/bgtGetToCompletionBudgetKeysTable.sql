--Drops the Procedure bgtGetToCompletionBudgetKeysTable if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetToCompletionBudgetKeysTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetToCompletionBudgetKeysTable
GO

CREATE  PROCEDURE bgtGetToCompletionBudgetKeysTable
	@IdProject		INT,
	@IdAssociate		INT,
	@Version		CHAR(1) -- Version of budget
AS
	DECLARE @RevisedGenerationNo INT
	DECLARE @ToCompletionPreviousGenerationNo INT
	DECLARE @ToCompletionCurrentGenerationNo INT	
	DECLARE @ToCompletionNewGenerationNo INT

	DECLARE @fnErrorState			INT
	DECLARE @fnErrorMessage			varchar(255)

	DECLARE @IsNewValidated				BIT,
			@YearMonthActualDataForNew  int
	
---------Get generations numbers
	SET @RevisedGenerationNo = dbo.fnGetRevisedBudgetGeneration(@IdProject,'C')
	
	SELECT  @ToCompletionPreviousGenerationNo = ToCompletionPreviousGenerationNo,
		@ToCompletionCurrentGenerationNo = ToCompletionCurrentGenerationNo,
		@ToCompletionNewGenerationNo = ToCompletionNewGenerationNo,
		@fnErrorState = ErrorState,
		@fnErrorMessage = ErrorMessage
	FROM dbo.fnGetToCompletionGenerationFromVersion(@IdProject, @Version, @IdAssociate)

	SELECT @IsNewValidated = IsValidated,
		   @YearMonthActualDataForNew = YearMonthActualData 
	FROM BUDGET_TOCOMPLETION
	WHERE IdProject = @IdProject and 
		  IdGeneration = @ToCompletionNewGenerationNo

	IF @fnErrorState=-1
	BEGIN
		RAISERROR(@fnErrorMessage,16,1)
		RETURN -1
	END

----------Create and populate months table
	CREATE TABLE #WPMonths
	(
		IdProject 	INT NOT NULL,
		IdPhase 	INT NOT NULL,
		IdWP		INT NOT NULL,
		YearMonth	INT NOT NULL
		PRIMARY KEY (IdProject, IdPhase, IdWP, YearMonth)
	)

	DECLARE PreselectionCursor CURSOR FAST_FORWARD FOR

	--Get the work packages selected in wp preselection + work packages in actual data (for this project)
	SELECT 
		WPM.IdProject	AS	'IdProject',
		WPM.IdPhase	AS	'IdPhase',	
		WPM.IdWP	AS	'IdWP'
	FROM #BUDGET_PRESELECTION_TEMP AS WPM
	WHERE WPM.IdProject = @IdProject

	OPEN PreselectionCursor
	DECLARE @IdPhase INT
	DECLARE @IdWP INT
	
	--Insert months into #WPMonths table for every work package from the above union
	FETCH NEXT FROM PreselectionCursor INTO @IdProject, @IdPhase, @IdWP	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #WPMonths 
			(IdProject, IdPhase, IdWP, YearMonth)
		SELECT
			IdProject, IdPhase, IdWP, YearMonth
		FROM dbo.fnGetWPMonths(@IdProject, @IdPhase, @IdWP)
		UNION -- on purpose eliminate duplicates
		SELECT IdProject, IdPhase, IdWorkPackage, YearMonth
		FROM BUDGET_TOCOMPLETION_DETAIL
		WHERE IdProject = @IdProject and
			  IdPhase = @IdPhase and
			  IdWorkPackage = @IdWP and
			  IdGeneration in (@ToCompletionPreviousGenerationNo, @ToCompletionCurrentGenerationNo, @ToCompletionNewGenerationNo)
		
		FETCH NEXT FROM PreselectionCursor INTO @IdProject, @IdPhase,@IdWP	
	END

	CLOSE PreselectionCursor
	DEALLOCATE PreselectionCursor

	

-- 	select * from #WPMonths
--CREATE Table with keys
 
	DECLARE @TableKeysFinal table
	(
		IdProject 	INT,
		IdPhase	  	INT,
		IdWorkPackage 	INT,
		IdCostCenter	INT,
		IdAssociate	INT,
		YearMonth	INT,
		IsNewActual	BIT,
		IsCurrentActual BIT,
		IsPreviousActual BIT
		PRIMARY KEY (IdProject, IdPhase, IdWorkPackage,IdCostCenter,IdAssociate, YearMonth)
	)

	DECLARE @TableKeysTemp table
	(
		IdProject 	INT,
		IdPhase	  	INT,
		IdWorkPackage 	INT,
		IdCostCenter	INT,
		IdAssociate	INT,
		YearMonth	INT
		PRIMARY KEY (IdProject, IdPhase, IdWorkPackage,IdCostCenter,IdAssociate, YearMonth)
	)
-- populate table with keys from tocompletion generation new
	INSERT INTO @TableKeysFinal (IdProject,IdPhase,IdWorkPackage,IdCostCenter,IdAssociate,YearMonth, IsNewActual, IsCurrentActual, IsPreviousActual)
	SELECT  
		WPM.IdProject,
		WPM.IdPhase,
		WPM.IdWP,
		BCDN.IdCostCenter,
		BCDN.IdAssociate,
		WPM.YearMonth,
		0,0,0
	FROM  #WPMONTHS WPM
	INNER JOIN BUDGET_TOCOMPLETION_DETAIL BCDN
	ON 	BCDN.IdProject = WPM.IdProject AND		
		BCDN.IdPhase = WPM.IdPhase AND
		BCDN.IdWorkPackage = WPM.IdWP AND
		BCDN.YearMonth = WPM.YearMonth AND
		BCDN.IdGeneration = @ToCompletionNewGenerationNo AND
	      	BCDN.IdAssociate = CASE 	WHEN (@IdAssociate = -1) THEN BCDN.IdAssociate
						ELSE @IdAssociate
						END
		

-- 	populate table with keys from revised

	INSERT INTO @TableKeysTemp (IdProject,IdPhase,IdWorkPackage,IdCostCenter,IdAssociate,YearMonth)
	SELECT
		WPM.IdProject,
		WPM.IdPhase,
		WPM.IdWP,
		BRD.IdCostCenter,
		BRD.IdAssociate,
		WPM.YearMonth
	FROM #WPMONTHS WPM	
	INNER JOIN BUDGET_REVISED_DETAIL AS BRD 
	ON	BRD.IdProject = WPM.IdProject AND
		BRD.IdGeneration = @RevisedGenerationNo AND
		BRD.IdPhase = WPM.IdPhase AND
		BRD.IdWorkPackage = WPM.IdWP AND
		BRD.YearMonth = WPM.YearMonth AND
		BRD.IdAssociate = CASE 	WHEN (@IdAssociate = -1) THEN BRD.IdAssociate
							ELSE @IdAssociate
						END
-- 	delete the final table with keys from temp table to evoid duplicates

	DELETE @TableKeysFinal
	FROM @TableKeysFinal tf
	INNER JOIN @TableKeysTemp tt
	ON 	tf.IdProject = tt.IdProject AND
		tf.IdPhase = tt.IdPhase AND
		tf.IdWorkPackage = tt.IdWorkPackage AND
		tf.IdCostCenter = tt.IdCostCenter AND
		tf.IdAssociate = tt.IdAssociate AND
		tf.YearMonth = tt.YearMonth

-- 	insert rows from revised into the final table

	INSERT INTO @TableKeysFinal (IdProject,IdPhase,IdWorkPackage,IdCostCenter,IdAssociate,YearMonth, IsNewActual, IsCurrentActual, IsPreviousActual)
	SELECT 	IdProject,
		IdPhase,
		IdWorkPackage,
		IdCostCenter,
		IdAssociate,
		YearMonth,
		0, 0, 0
	FROM @TableKeysTemp



-- add eventul keys from released version of the tocompletion budget

	DELETE FROM @TableKeysTemp

	INSERT INTO @TableKeysTemp (IdProject,IdPhase,IdWorkPackage,IdCostCenter,IdAssociate,YearMonth)
	SELECT  
		WPM.IdProject,
		WPM.IdPhase,
		WPM.IdWP,
		BCDN.IdCostCenter,
		BCDN.IdAssociate,
		WPM.YearMonth
	FROM  #WPMONTHS WPM
	INNER JOIN BUDGET_TOCOMPLETION_DETAIL BCDN
	ON 	BCDN.IdProject = WPM.IdProject AND		
		BCDN.IdPhase = WPM.IdPhase AND
		BCDN.IdWorkPackage = WPM.IdWP AND
		BCDN.YearMonth = WPM.YearMonth AND
		BCDN.IdGeneration = @ToCompletionCurrentGenerationNo AND
	      	BCDN.IdAssociate = CASE 	WHEN (@IdAssociate = -1) THEN BCDN.IdAssociate
						ELSE @IdAssociate
						END

	DELETE @TableKeysFinal
	FROM @TableKeysFinal tf
	INNER JOIN @TableKeysTemp tt
	ON 	tf.IdProject = tt.IdProject AND
		tf.IdPhase = tt.IdPhase AND
		tf.IdWorkPackage = tt.IdWorkPackage AND
		tf.IdCostCenter = tt.IdCostCenter AND
		tf.IdAssociate = tt.IdAssociate AND
		tf.YearMonth = tt.YearMonth

	INSERT INTO @TableKeysFinal  (IdProject,IdPhase,IdWorkPackage,IdCostCenter,IdAssociate,YearMonth, IsNewActual, IsCurrentActual, IsPreviousActual)
	SELECT 	IdProject,
		IdPhase,
		IdWorkPackage,
		IdCostCenter,
		IdAssociate,
		YearMonth,
		0, 0, 0
	FROM @TableKeysTemp

-- 	add eventual keys from previous version from tocompletion budget

	DELETE FROM @TableKeysTemp

	INSERT INTO @TableKeysTemp (IdProject,IdPhase,IdWorkPackage,IdCostCenter,IdAssociate,YearMonth)
	SELECT  
		WPM.IdProject,
		WPM.IdPhase,
		WPM.IdWP,
		BCDN.IdCostCenter,
		BCDN.IdAssociate,
		WPM.YearMonth
	FROM  #WPMONTHS WPM
	INNER JOIN BUDGET_TOCOMPLETION_DETAIL BCDN
	ON 	BCDN.IdProject = WPM.IdProject AND		
		BCDN.IdPhase = WPM.IdPhase AND
		BCDN.IdWorkPackage = WPM.IdWP AND
		BCDN.YearMonth = WPM.YearMonth AND
		BCDN.IdGeneration = @ToCompletionPreviousGenerationNo AND
	      	BCDN.IdAssociate = CASE 	WHEN (@IdAssociate = -1) THEN BCDN.IdAssociate
						ELSE @IdAssociate
						END

	DELETE @TableKeysFinal
	FROM @TableKeysFinal tf
	INNER JOIN @TableKeysTemp tt
	ON 	tf.IdProject = tt.IdProject AND
		tf.IdPhase = tt.IdPhase AND
		tf.IdWorkPackage = tt.IdWorkPackage AND
		tf.IdCostCenter = tt.IdCostCenter AND
		tf.IdAssociate = tt.IdAssociate AND
		tf.YearMonth = tt.YearMonth

	INSERT INTO @TableKeysFinal  (IdProject,IdPhase,IdWorkPackage,IdCostCenter,IdAssociate,YearMonth, IsNewActual, IsCurrentActual, IsPreviousActual)
	SELECT 	IdProject,
		IdPhase,
		IdWorkPackage,
		IdCostCenter,
		IdAssociate,
		YearMonth,
		0,0,0
	FROM @TableKeysTemp

--delete the temp table to reuse it for actual data

	DELETE FROM @TableKeysTemp

-- populate table with keys from actual data

	--Create a table which will hold all keys from the 3 actual tables (ACTUAL_DATA_DETAILS_HOURS, ACTUAL_DATA_DETAILS_SALES,
	--ACTUAL_DATA_DETAILS_COSTS)
	CREATE TABLE #ACTUAL_DATA_KEYS
	(
		IdProject INT NOT NULL,
		IdPhase INT NOT NULL,
		IdWorkPackage INT NOT NULL,
		IdCostCenter INT NOT NULL,
		YearMonth INT NOT NULL
		PRIMARY KEY (IdProject, IdPhase, IdWorkPackage, IdCostCenter, YearMonth)
	)
	
	--Insert the actual keys in the #ACTUAL_DATA_KEYS table
	INSERT INTO #ACTUAL_DATA_KEYS (IdProject, IdPhase, IdWorkPackage, IdCostCenter, YearMonth)
	SELECT  DISTINCT
		AD.IdProject,
		AD.IdPhase, 
		AD.IdWorkPackage, 
		AD.IdCostCenter,		
		AD.YearMonth
	FROM ACTUAL_DATA_DETAILS_HOURS AD
	INNER JOIN  #BUDGET_PRESELECTION_TEMP BPT ON
		AD.IdProject = BPT.IdProject AND
		AD.IdPhase = BPT.IdPhase AND
		AD.IdWorkPackage = BPT.IdWP
	UNION
	SELECT  DISTINCT
		AD.IdProject,
		AD.IdPhase, 
		AD.IdWorkPackage, 
		AD.IdCostCenter,		
		AD.YearMonth
	FROM ACTUAL_DATA_DETAILS_SALES AD
	INNER JOIN  #BUDGET_PRESELECTION_TEMP BPT ON
		AD.IdProject = BPT.IdProject AND
		AD.IdPhase = BPT.IdPhase AND
		AD.IdWorkPackage = BPT.IdWP
	UNION
	SELECT  DISTINCT
		AD.IdProject,
		AD.IdPhase, 
		AD.IdWorkPackage, 
		AD.IdCostCenter,		
		AD.YearMonth
	FROM ACTUAL_DATA_DETAILS_COSTS AD
	INNER JOIN  #BUDGET_PRESELECTION_TEMP BPT ON
		AD.IdProject = BPT.IdProject AND
		AD.IdPhase = BPT.IdPhase AND
		AD.IdWorkPackage = BPT.IdWP

	INSERT INTO @TableKeysTemp (IdProject,IdPhase,IdWorkPackage,IdCostCenter,IdAssociate,YearMonth)
	SELECT  IdProject,
		IdPhase,
		IdWorkPackage,
		IdCostCenter,
		-1,
		YearMonth
	FROM	#ACTUAL_DATA_KEYS

--insert into final table the keys from actual for months that not exists

	INSERT INTO @TableKeysFinal  (IdProject,IdPhase,IdWorkPackage,IdCostCenter,IdAssociate,YearMonth, IsNewActual)
	SELECT 	tt.IdProject,
		tt.IdPhase,
		tt.IdWorkPackage,
		tt.IdCostCenter,
		-1,
		tt.YearMonth,
		1
	FROM @TableKeysTemp tt
	LEFT JOIN @TableKeysFinal tf
	ON 	tt.IdProject = tf.IdProject AND
		tt.IdPhase = tf.IdPhase AND
		tt.IdWorkPackage = tf.IdWorkPackage AND
		tt.IdCostCenter = tf.IdCostCenter AND
		tt.YearMonth = tf.YearMonth
	WHERE 1 = CASE WHEN @IsNewValidated=1 AND ISNULL(@ToCompletionCurrentGenerationNo,-1) <> @ToCompletionNewGenerationNo THEN
					CASE WHEN tt.YearMonth <= ISNULL(@YearMonthActualDataForNew, 190001) 
						then 1 
					else 
						0 END
			 ELSE 1	END
		AND tf.IdProject IS NULL

	--------------------------------------------------------------------------------------------------------------------------------------

	--This code is for the special case when a cost center is found only in actual data. In this case, we must artificially fill in
	--all months from the period of the wp to which the cc belongs even if these records are not found in any table (to completionl, revised
	--actual data). The user must always see the entire period of the wp, for all cost centers that belong to that wp
	
	DELETE FROM @TableKeysTemp

	--For each cost center in the final table, cross join with the period of the wp it belongs to. We will have all periods
	--for all cost centers in @TableKeysTemp
	INSERT INTO @TableKeysTemp(IdProject, IdPhase, IdWorkPackage,IdCostCenter,IdAssociate, YearMonth)
	SELECT DISTINCT
		tf.IdProject, 
		tf.IdPhase,
		tf.IdWorkPackage,
		tf.IdCostCenter,
		0, --The artificially inserted records will have 0 for id associate
		WPM.YearMonth
	FROM 	@TableKeysFinal tf
	CROSS JOIN #WPMonths WPM
	WHERE 	tf.IdProject = WPM.IdProject AND
		tf.IdPhase = WPM.IdPhase AND
		tf.IdWorkPackage = WPM.IdWP

	--Delete the months which are already in the final table. What remains will be the cost center months which are missing (for the
	--cost centers that had only actual data - they were present only in actual_data_details table)
	DELETE @TableKeysTemp
	FROM @TableKeysTemp tt
	INNER JOIN @TableKeysFinal tf ON --On purpose incomplete join. The IdAssociate in @TableKeysTemp is 0
		tf.IdProject = tt.IdProject AND
		tf.IdPhase = tt.IdPhase AND
		tf.IdWorkPackage = tt.IdWorkPackage AND
		tf.IdCostCenter = tt.IdCostCenter AND
		tf.YearMonth = tt.YearMonth

	--Fill in the missing months
	INSERT INTO @TableKeysFinal  (IdProject,IdPhase,IdWorkPackage,IdCostCenter,IdAssociate,YearMonth, IsNewActual, IsCurrentActual, IsPreviousActual)
	SELECT 	IdProject,
		IdPhase,
		IdWorkPackage,
		IdCostCenter,
		IdAssociate,
		YearMonth,
		0, 0, 0
	FROM @TableKeysTemp
	--------------------------------------------------------------------------------------------------------------------------------------

	IF (@ToCompletionCurrentGenerationNo IS NOT NULL)
	BEGIN
		-- 	update flag to mark actual data for previous and released versions
		UPDATE 	tf
		SET 	tf.IsCurrentActual = CASE WHEN tf.YearMonth<=BTC.YearMonthActualData THEN 1 ELSE 0 END
		FROM 	@TableKeysFinal tf
		INNER JOIN BUDGET_TOCOMPLETION BTC
		ON 	BTC.IdProject = tf.IdProject AND
			BTC.IdGeneration = @ToCompletionCurrentGenerationNo
		INNER JOIN #ACTUAL_DATA_KEYS AD
		ON	AD.IdProject = tf.IdProject AND
			AD.IdPhase = tf.IdPhase AND
			AD.IdWorkPackage = tf.IdWorkPackage AND
			AD.IdCostCenter = tf.IdCostCenter AND
			AD.YearMonth  = tf.YearMonth
	END
	ELSE
	BEGIN
		--If the previous generation does not exist, set all IsPreviousActual flags to 0
		UPDATE 	@TableKeysFinal
		SET 	IsCurrentActual = 0
	END

	IF (@ToCompletionPreviousGenerationNo IS NOT NULL)
	BEGIN
		UPDATE 	tf
		SET 	tf.IsPreviousActual = CASE WHEN tf.YearMonth<=BTC.YearMonthActualData THEN 1 ELSE 0 END
		FROM 	@TableKeysFinal tf
		INNER JOIN BUDGET_TOCOMPLETION BTC
		ON 	BTC.IdProject = tf.IdProject AND
			BTC.IdGeneration = @ToCompletionPreviousGenerationNo
		INNER JOIN #ACTUAL_DATA_KEYS AD
		ON	AD.IdProject = tf.IdProject AND
			AD.IdPhase = tf.IdPhase AND
			AD.IdWorkPackage = tf.IdWorkPackage AND
			AD.IdCostCenter = tf.IdCostCenter AND
			AD.YearMonth  = tf.YearMonth
	END
	ELSE
	BEGIN
		--If the previous generation does not exist, set all IsPreviousActual flags to 0
		UPDATE 	@TableKeysFinal
		SET 	IsPreviousActual = 0
	END


-------------------------------------------------------------------------------------------------------------------------------------------
/*For all months prior to the earliest month from actual data (for each wp) or to YearMonthActualData from BUDGET_TOCOMPLETION, mark the respective
rows as if they were from actual (they will appear in blue and empty)*/

----------Create YearMonth for current date
	DECLARE @YearMonthOfPreviousMonth INT
	Set @YearMonthOfPreviousMonth = dbo.fnGetYearMonthOfPreviousMonth(getdate())

	--All months before the smallest month from actual or before the YearMonthActualData from BUDGET_TOCOMPLETION (whichever comes first) for new generation
	--for each work package will be marked as if they had actual data, so that they appear with blue in the interface and with empty
	--values -- for new is different
	UPDATE tf
	SET IsNewActual = 1
	FROM @TableKeysFinal tf
	WHERE tf.YearMonth <= CASE WHEN @IsNewValidated=1 AND ISNULL(@ToCompletionCurrentGenerationNo,-1) <> @ToCompletionNewGenerationNo
						 THEN ISNULL(@YearMonthActualDataForNew, 190001) ELSE @YearMonthOfPreviousMonth END

	--All months before the smallest month from actual or before the YearMonthActualData from BUDGET_TOCOMPLETION (whichever comes first) for released generation
	--for each work package will be marked as if they had actual data, so that they appear with blue in the interface and with empty
	--values
	UPDATE tf
	SET IsCurrentActual = 1
	FROM @TableKeysFinal tf
	INNER JOIN BUDGET_TOCOMPLETION BC
	ON	BC.IdProject = tf.IdProject AND
		BC.IdGeneration = @ToCompletionCurrentGenerationNo
	WHERE 	BC.YearMonthActualData IS NOT NULL AND
		tf.YearMonth <= BC.YearMonthActualData 


	--All months before the smallest month from actual or before the YearMonthActualData from BUDGET_TOCOMPLETION (whichever comes first) for previous generation
	--for each work package will be marked as if they had actual data, so that they appear with blue in the interface and with empty
	--values
	UPDATE tf
	SET IsPreviousActual = 1
	FROM @TableKeysFinal tf
	INNER JOIN BUDGET_TOCOMPLETION BC
	ON	BC.IdProject = tf.IdProject AND
		BC.IdGeneration = @ToCompletionPreviousGenerationNo
	WHERE 	BC.YearMonthActualData IS NOT NULL AND
			tf.YearMonth <= BC.YearMonthActualData

-------------------------------------------------------------------------------------------------------------------------------------------
-- make the final select
	
	SELECT	IdProject,
		IdPhase,
		IdWorkPackage,
		IdCostCenter,
		IdAssociate,
		YearMonth,
		IsNewActual,
		IsCurrentActual,
		IsPreviousActual
	FROM @TableKeysFinal
	ORDER BY IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth

GO

