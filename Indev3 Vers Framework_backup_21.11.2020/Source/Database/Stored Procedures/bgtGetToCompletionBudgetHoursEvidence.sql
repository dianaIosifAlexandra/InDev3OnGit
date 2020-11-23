--Drops the Procedure bgtGetToCompletionBudgetHoursEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetToCompletionBudgetHoursEvidence]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetToCompletionBudgetHoursEvidence
GO

CREATE  PROCEDURE [dbo].[bgtGetToCompletionBudgetHoursEvidence]
	@IdProject 		INT,
	@IdAssociate		INT,
	@IdAssociateViewer	INT,
	@Version		CHAR(1), -- Version of budget
	@ShowOnlyCCsWithSignificantValues	BIT,
	@IdCountry		INT
AS

-- 	CHECK CONSISTENCY BETWEEN TEMPORARY TABLE AND WORK PACKAGE TABLE
	IF EXISTS
	(
		SELECT BPT.IdProject, BPT.IdPhase, BPT.IdWP
		FROM #BUDGET_PRESELECTION_TEMP AS BPT
		LEFT JOIN WORK_PACKAGES AS WP
			ON WP.IdProject = BPT.IdProject
			AND WP.IdPhase = BPT.IdPhase
			AND WP.[Id] = BPT.IdWP
	 	WHERE WP.IDPhase IS NULL
	)
	BEGIN
		RAISERROR('Budget check: key information about at least one of project''s WPs was changed by another user. Return to preselection screen and re-select your WPs.', 16, 1)
		RETURN -1
	END

	DECLARE @RevisedGenerationNo INT
	DECLARE @ToCompletionPreviousGenerationNo INT
	DECLARE @ToCompletionCurrentGenerationNo INT
	DECLARE @ToCompletionNewGenerationNo INT
	
	DECLARE @fnErrorState			INT
	DECLARE @fnErrorMessage			varchar(255)
	

---------Get generations numbers
	SET @RevisedGenerationNo = dbo.fnGetRevisedBudgetGeneration(@IdProject,'C')
	
	SELECT  @ToCompletionPreviousGenerationNo = ToCompletionPreviousGenerationNo,
		@ToCompletionCurrentGenerationNo = ToCompletionCurrentGenerationNo,
		@ToCompletionNewGenerationNo = ToCompletionNewGenerationNo,
		@fnErrorState = ErrorState,
		@fnErrorMessage = ErrorMessage
	FROM dbo.fnGetToCompletionGenerationFromVersion(@IdProject, @Version, @IdAssociate)

	IF @fnErrorState=-1
	BEGIN
		RAISERROR(@fnErrorMessage,16,1)
		RETURN -1
	END

	CREATE TABLE #BUDGET_TOCOMPLETION_DETAIL_TEMP
	(
		Id INT identity(1,1),
		IdProject INT NOT NULL,
		IdPhase INT NOT NULL,
		IdWP INT NOT NULL,
		IdCostCenter INT NOT NULL,
		IdAssociate INT NOT NULL,
		YearMonth INT NOT NULL,
		WPName VARCHAR(36),
		CostCenterName VARCHAR(50),
		Previous INT,
		IsPreviousActual BIT NOT NULL,
		CurrentPreviousDiff INT,
		[Current] INT,
		IsCurrentActual BIT NOT NULL,
		NewCurrentDiff INT,
		New INT,
		IsNewActual BIT NOT NULL,
		NewRevisedDiff INT,
		Revised INT
		PRIMARY KEY (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth)
	)

	
	INSERT INTO #BUDGET_TOCOMPLETION_DETAIL_TEMP (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth, IsNewActual, IsCurrentActual, IsPreviousActual)
	EXEC bgtGetToCompletionBudgetKeysTable @IdProject = @IdProject, @IdAssociate = @IdAssociate, @Version = @Version

	--Set the flag for IsNewActual to 0 if there are no actual data for the previous month 
	UPDATE	BTD
	SET	BTD.IsNewActual = 0
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	WHERE	BTD.YearMonth = dbo.fnGetYearMonthOfPreviousMonth(getdate()) AND
		--dbo.fnGetActualHoursQty(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth) IS NULL
		dbo.fnCheckUploadedActualDataForCC(BTD.IdCostCenter, BTD.YearMonth) = 0

	--Add the wp and cost center names
	UPDATE 	BTD 
	SET  	BTD.WPName = WP.Code + ' - ' + WP.Name,
		BTD.CostCenterName = DP.[Name]+'-'+IL.Code+'-'+CC.[Code]
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN WORK_PACKAGES WP ON
		WP.IdProject = BTD.IdProject AND
		WP.IdPhase = BTD.IdPhase AND
		WP.Id = BTD.IdWP
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN DEPARTMENTS DP ON
		DP.Id = CC.IdDepartment
	
	--Add new values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.New = BCD.HoursQty
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionNewGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	WHERE	BTD.IsNewActual = 0

	--Add new values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.New = ROUND(ISNULL(dbo.fnGetActualHoursQty(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth),0), 0)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	WHERE	BTD.IsNewActual = 1

	--Add released values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = BCD.HoursQty
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionCurrentGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	WHERE 	BTD.IsCurrentActual = 0

	--Add current values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = ROUND(ISNULL(dbo.fnGetActualHoursQty(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth),0), 0)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	WHERE	BTD.IsCurrentActual = 1

	--Add previous values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Previous] = BCD.HoursQty
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionPreviousGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	WHERE	IsPreviousActual = 0

	--Add previous values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.Previous = ROUND(ISNULL(dbo.fnGetActualHoursQty(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth),0), 0)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	WHERE	BTD.IsPreviousActual = 1

	--Add revised values
	UPDATE 	BTD
	SET 	BTD.Revised = BRD.HoursQty
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_REVISED_DETAIL BRD ON 
		BRD.IdProject = BTD.IdProject AND
		BRD.IdGeneration = @RevisedGenerationNo AND
		BRD.IdPhase = BTD.IdPhase AND
		BRD.IdWorkPackage = BTD.IdWP AND
		BRD.IdCostCenter = BTD.IdCostCenter AND
		BRD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BRD.YearMonth = BTD.YearMonth

	-- if there are 2 associates who have IsCurrentActual = 1 at the same node, leave only one of them to have
	-- [Current] <> 0, because [Current] is set to the sum, per team, of values from actual data
	update a
	set [Current] = 0
	from #BUDGET_TOCOMPLETION_DETAIL_TEMP a
	join
		(select IdProject, IdPhase, IdWP, IdCostCenter, YearMonth, min(Id) as Id
			from #BUDGET_TOCOMPLETION_DETAIL_TEMP
			where IsCurrentActual = 1
			group by IdProject, IdPhase, IdWP, IdCostCenter, YearMonth
			having count(*) > 1
		) b on 
			a.IdProject = b.IdProject and
			a.IdPhase = b.IdPhase and
			a.IdWP = b.IdWP and
			a.IdCostCenter = b.IdCostCenter and
			a.YearMonth = b.YearMonth
	where a.IsCurrentActual = 1 and a.Id > b.Id

	-- if there are 2 associates who have IsNewActual = 1 at the same node, leave only one of them to have
	-- [New] <> 0, because [New] is set to the sum, per team, of values from actual data
	update a
	set Previous = 0
	from #BUDGET_TOCOMPLETION_DETAIL_TEMP a
	join
		(select IdProject, IdPhase, IdWP, IdCostCenter, YearMonth, min(Id) as Id
			from #BUDGET_TOCOMPLETION_DETAIL_TEMP
			where IsPreviousActual = 1
			group by IdProject, IdPhase, IdWP, IdCostCenter, YearMonth
			having count(*) > 1
		) b on 
			a.IdProject = b.IdProject and
			a.IdPhase = b.IdPhase and
			a.IdWP = b.IdWP and
			a.IdCostCenter = b.IdCostCenter and
			a.YearMonth = b.YearMonth
	where a.IsPreviousActual = 1 and a.Id > b.Id


	-- if there are 2 associates who have IsPreviousActual = 1 at the same node, leave only one of them to have
	-- [Previous] <> 0, because [Previous] is set to the sum, per team, of values from actual data
	update a
	set New = 0
	from #BUDGET_TOCOMPLETION_DETAIL_TEMP a
	join
		(select IdProject, IdPhase, IdWP, IdCostCenter, YearMonth, min(Id) as Id
			from #BUDGET_TOCOMPLETION_DETAIL_TEMP
			where IsNewActual = 1
			group by IdProject, IdPhase, IdWP, IdCostCenter, YearMonth
			having count(*) > 1
		) b on 
			a.IdProject = b.IdProject and
			a.IdPhase = b.IdPhase and
			a.IdWP = b.IdWP and
			a.IdCostCenter = b.IdCostCenter and
			a.YearMonth = b.YearMonth
	where a.IsNewActual = 1 and a.Id > b.Id

	--Update diff columns
	IF (@ToCompletionNewGenerationNo IS NOT NULL and @ToCompletionCurrentGenerationNo is NOT NULL)
	BEGIN
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	NewCurrentDiff = CASE WHEN New IS NULL AND [Current] IS NULL THEN NULL ELSE ISNULL(New, 0) - ISNULL([Current], 0) END
	END

	IF (@ToCompletionNewGenerationNo IS NOT NULL)--revised will always have a current version no need to test
	BEGIN
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	NewRevisedDiff = CASE WHEN New IS NULL AND Revised IS NULL THEN NULL ELSE ISNULL(New, 0) - ISNULL(Revised, 0) END
	END

	IF (@ToCompletionPreviousGenerationNo IS NOT NULL and @ToCompletionCurrentGenerationNo is NOT NULL)	
	BEGIN
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	CurrentPreviousDiff = CASE WHEN [Current] IS NULL AND Previous IS NULL THEN NULL ELSE ISNULL([Current], 0) - ISNULL(Previous, 0) END
	END


	DECLARE @IsBudgetValidated BIT
	SELECT 	@IsBudgetValidated = IsValidated
	FROM	BUDGET_TOCOMPLETION
	WHERE	IdProject = @IdProject AND
		IdGeneration = @ToCompletionCurrentGenerationNo
/*		
	--Select the Phase table
	SELECT
		BPT.IdProject		 	AS 'IdProject',
		PP.Id 				AS 'IdPhase',
		PP.Code + ' - ' + PP.Name 	AS 'PhaseName',
		SUM(BTD.Previous) 		AS 'Previous',
		SUM(BTD.CurrentPreviousDiff) 	AS 'CurrentPreviousDiff',
		SUM(BTD.[Current]) 		AS 'Current',
		SUM(BTD.NewCurrentDiff) 	AS 'NewCurrentDiff',
		SUM(BTD.New) 			AS 'New',
		SUM(BTD.NewRevisedDiff)		AS 'NewRevisedDiff',
		SUM(BTD.Revised)		AS 'Revised'
	FROM #BUDGET_PRESELECTION_TEMP AS BPT
	INNER JOIN PROJECT_PHASES AS PP
		ON PP.Id = BPT.IdPhase
	LEFT JOIN #BUDGET_TOCOMPLETION_DETAIL_TEMP AS BTD ON 
			BTD.IdProject = BPT.IdProject AND
			BTD.IdPhase = BPT.IdPhase AND
			BTD.IdWP = BPT.IdWP
	GROUP BY BPT.IdProject, PP.Id, PP.Name, PP.Code		
*/


	CREATE TABLE #CC_TABLE
	(
		IdProject		INT,
		IdPhase			INT,
		IdWP			INT,
		IdCostCenter		INT,
		CostCenterName		VARCHAR(50),
		Previous		INT,
		CurrentPreviousDiff	INT,
		[Current]		INT,
		NewCurrentDiff		INT,
		New			INT,
		NewRevisedDiff		INT,
		Revised			INT,
		IdCurrency		INT,
		CurrencyCode		VARCHAR(3)
		PRIMARY KEY (IdProject, IdPhase, IdWP, IdCostCenter)
	)

	IF ISNULL(@ShowOnlyCCsWithSignificantValues, 0) = 0
	BEGIN
		INSERT INTO #CC_TABLE
		SELECT 	BTD.IdProject 			AS	'IdProject',
			BTD.IdPhase			AS	'IdPhase',
			BTD.IdWP			AS	'IdWP',
			BTD.IdCostCenter		AS	'IdCostCenter',
			BTD.CostCenterName		AS	'CostCenterName',
			SUM(BTD.Previous)		AS	'Previous',
			SUM(BTD.CurrentPreviousDiff) 	AS	'CurrentPreviousDiff',
			SUM(BTD.[Current])		AS 	'Current',
			SUM(BTD.NewCurrentDiff)		AS	'NewCurrentDiff',
			SUM(BTD.New)			AS	'New',
			SUM(BTD.NewRevisedDiff)		AS	'NewRevisedDiff',
			SUM(BTD.Revised)		AS 	'Revised',
			CURR.[Id]			AS 	'IdCurrency',
			CURR.[Code]			AS 	'CurrencyCode'
		FROM #BUDGET_TOCOMPLETION_DETAIL_TEMP AS BTD
		INNER JOIN COST_CENTERS AS CC
			ON CC.Id = BTD.IdCostCenter
		INNER JOIN DEPARTMENTS DP
			ON DP.Id = CC.IdDepartment
		INNER JOIN INERGY_LOCATIONS AS IL
			ON IL.[Id] = CC.IdInergyLocation
		INNER JOIN COUNTRIES
			ON COUNTRIES.[Id] = IL.IdCountry
		INNER JOIN CURRENCIES CURR 
			ON CURR.[Id]=COUNTRIES.IdCurrency
		WHERE COUNTRIES.[Id] = CASE WHEN @IdCountry = -1 THEN COUNTRIES.[Id] ELSE @IdCountry END
		GROUP BY BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.CostCenterName, CURR.[Id], CURR.[Code], DP.Rank
		ORDER BY DP.Rank, BTD.CostCenterName
	END
	ELSE
	BEGIN
		INSERT INTO #CC_TABLE
		SELECT 	BTD.IdProject 			AS	'IdProject',
			BTD.IdPhase			AS	'IdPhase',
			BTD.IdWP			AS	'IdWP',
			BTD.IdCostCenter		AS	'IdCostCenter',
			BTD.CostCenterName		AS	'CostCenterName',
			SUM(BTD.Previous)		AS	'Previous',
			SUM(BTD.CurrentPreviousDiff) 	AS	'CurrentPreviousDiff',
			SUM(BTD.[Current])		AS 	'Current',
			SUM(BTD.NewCurrentDiff)		AS	'NewCurrentDiff',
			SUM(BTD.New)			AS	'New',
			SUM(BTD.NewRevisedDiff)		AS	'NewRevisedDiff',
			SUM(BTD.Revised)		AS 	'Revised',
			CURR.[Id]			AS 	'IdCurrency',
			CURR.[Code]			AS 	'CurrencyCode'
		FROM #BUDGET_TOCOMPLETION_DETAIL_TEMP AS BTD
		INNER JOIN COST_CENTERS AS CC
			ON CC.Id = BTD.IdCostCenter
		INNER JOIN DEPARTMENTS DP
			ON DP.Id = CC.IdDepartment
		INNER JOIN INERGY_LOCATIONS AS IL
			ON IL.[Id] = CC.IdInergyLocation
		INNER JOIN COUNTRIES
			ON COUNTRIES.[Id] = IL.IdCountry
		INNER JOIN CURRENCIES CURR 
			ON CURR.[Id]=COUNTRIES.IdCurrency
		WHERE COUNTRIES.[Id] = CASE WHEN @IdCountry = -1 THEN COUNTRIES.[Id] ELSE @IdCountry END
		GROUP BY BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.CostCenterName, CURR.[Id], CURR.[Code], DP.Rank
		HAVING COALESCE( NULLIF(SUM(ROUND(BTD.[Current], 0)), 0), 
				 NULLIF(SUM(ROUND(BTD.NewCurrentDiff, 0)), 0), 
				 NULLIF(SUM(ROUND(BTD.New, 0)), 0), 
				 NULLIF(SUM(ROUND(BTD.NewRevisedDiff, 0)), 0) 
				) IS NOT NULL	
		ORDER BY DP.Rank, BTD.CostCenterName	
	END



	--Select the WP level table
	SELECT 	BPT.IdProject 				AS	'IdProject',
		BPT.IdPhase				AS	'IdPhase',
		BPT.IdWP				AS	'IdWP',
		WP.Code					AS	'PhaseWPCode',
		WP.Code + ' - ' + WP.Name		AS	'PhaseWPName',
		CASE WHEN @IdAssociate = -1 THEN dbo.fnGetWeightedAveragePercent(BPT.IdProject, @ToCompletionNewGenerationNo, BPT.IdPhase, BPT.IdWP, @IdAssociate) 
		     ELSE MAX(BCP.[Percent]) END 	AS 	'Progress',
		WP.StartYearMonth			AS	'StartYearMonth',
		WP.EndYearMonth				AS	'EndYearMonth',
		SUM(ISNULL(CC.Previous, 0))		AS	'Previous',
		SUM(ISNULL(CC.CurrentPreviousDiff, 0)) 	AS	'CurrentPreviousDiff',
		SUM(ISNULL(CC.[Current], 0))		AS 	'Current',
		SUM(ISNULL(CC.NewCurrentDiff, 0))	AS	'NewCurrentDiff',
		SUM(ISNULL(CC.New, 0))			AS	'New',
		SUM(ISNULL(CC.NewRevisedDiff, 0))	AS	'NewRevisedDiff',
		SUM(ISNULL(CC.Revised, 0))		AS 	'Revised',
		WP.IsActive				AS 	'IsActive'
	FROM #BUDGET_PRESELECTION_TEMP BPT
	LEFT JOIN #CC_TABLE CC ON
		CC.IdProject = BPT.IdProject AND
		CC.IdPhase = BPT.IdPhase AND
		CC.IdWP = BPT.IdWP
	LEFT JOIN BUDGET_TOCOMPLETION_PROGRESS BCP ON
		BCP.IdProject = BPT.IdProject AND
		BCP.IdGeneration = @ToCompletionNewGenerationNo AND
		BCP.IdPhase = BPT.IdPhase AND
		BCP.IdWorkPackage = BPT.IdWP AND
		BCP.IdAssociate = @IdAssociate
	INNER JOIN WORK_PACKAGES AS WP ON
		WP.IdProject = BPT.IdProject AND
		WP.IdPhase = BPT.IdPhase AND
		WP.[Id] = BPT.IdWP
	INNER JOIN PROJECT_PHASES PH ON
		PH.Id = WP.IdPhase
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, WP.StartYearMonth, WP.EndYearMonth, WP.IsActive, PH.Code, WP.Code, WP.Name
	ORDER BY PH.Code


	--Select the COST CENTER level table
	SELECT IdProject, IdPhase, IdWP, IdCostCenter, CostCenterName, Previous, CurrentPreviousDiff, [Current],
		NewCurrentDiff, New, NewRevisedDiff, Revised, IdCurrency, CurrencyCode
	FROM #CC_TABLE


	--Select the YEARMONTH level table
	SELECT	BTD.IdProject		AS	'IdProject',
		BTD.IdPhase			AS	'IdPhase',
		BTD.IdWP			AS	'IdWP',
		BTD.IdCostCenter		AS	'IdCostCenter',
		BTD.YearMonth		AS	'YearMonth',
		SUM(BTD.Previous)		AS	'Previous',
		BTD.IsPreviousActual	AS	'IsPreviousActual',
		SUM(BTD.CurrentPreviousDiff)	AS	'CurrentPreviousDiff',
		SUM(BTD.[Current])		AS	'Current',
		BTD.IsCurrentActual		AS	'IsCurrentActual',
		SUM(BTD.NewCurrentDiff)		AS	'NewCurrentDiff',
		SUM(BTD.New)			AS	'New',
		BTD.IsNewActual		AS	'IsNewActual',
		SUM(BTD.NewRevisedDiff)		AS	'NewRevisedDiff',
		SUM(BTD.Revised)			AS	'Revised'
	FROM #BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	GROUP BY BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, BTD.IsPreviousActual, BTD.IsCurrentActual, BTD.IsNewActual
	ORDER BY BTD.YearMonth

GO

