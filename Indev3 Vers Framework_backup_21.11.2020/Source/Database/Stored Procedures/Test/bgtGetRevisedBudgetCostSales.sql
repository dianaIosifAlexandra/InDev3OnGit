--Drops the Procedure bgtGetRevisedBudgetCostSales if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.bgtGetRevisedBudgetCostSales') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetRevisedBudgetCostSales
GO

CREATE  PROCEDURE bgtGetRevisedBudgetCostSales
	@IdProject				INT,
	@IdAssociate			INT,	--The Id of associate
	@IdAssociateViewer		INT,	--The Id of associate viewing the budget
	@IsAssociateCurrency 	BIT,	--Specifies whether the values will be converted from the cost center
	@Version				CHAR(1),
	@IdCountry				INT,
	@IdCurrencyDisplay		int = 0
AS

	if @IdCurrencyDisplay is null
		set @IdCurrencyDisplay = 0

	declare @CurrencyDisplayBit bit = 0
	if @IdCurrencyDisplay > 0
		set @CurrencyDisplayBit = 1

	-- 	CHECK CONSISTENCY BETWEEN TEMPORARY TABLE AND WORK PACKAGE TABLE
	IF EXISTS
	(
		SELECT BPT.IdProject, BPT.IdPhase, BPT.IdWP
		FROM #BUDGET_PRESELECTION_TEMP AS BPT
		LEFT JOIN WORK_PACKAGES AS WP
			ON WP.IdProject = BPT.IdProject
			AND WP.IdPhase = BPT.IdPhase
			AND WP.Id = BPT.IdWP
	 	WHERE WP.IDPhase IS NULL
	)
	BEGIN
		RAISERROR('Budget check: key Information about at least one of project''s WPs was changed by another user. Return to preselection screen and re-select your WPs.', 16, 1)
		RETURN -1
	END

	DECLARE @CurrentGeneration	INT
	DECLARE @LastGeneration		INT
	
	IF (@Version = 'N')
	BEGIN
		SELECT @CurrentGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject, 'C')
		--The error message should be displayed only if @IdProject is not null (there was at least 1 row in #BUDGET_PRESELECTION_TEMP).
		--If #BUDGET_PRESELECTION_TEMP has no row, it means that the budget is viewed from follow-up and there are no active wp's for
		--this project. In that case, an empty budget will be displayed and no error message.
		IF (@CurrentGeneration IS NULL AND @IdProject IS NOT NULL)
		BEGIN
			RAISERROR('No released version found for this budget', 16, 1)
			RETURN -1
		END

		SELECT @LastGeneration = ISNULL(dbo.fnGetRevisedBudgetGeneration(@IdProject, @Version),@CurrentGeneration)
	
		
		DECLARE @MaxGeneration INT
		SELECT 	@MaxGeneration = MAX(IdGeneration)
		FROM	BUDGET_REVISED_DETAIL BRD
		WHERE 	BRD.IdProject = @IdProject AND
			BRD.IdAssociate = @IdAssociate
		
		IF (@LastGeneration <> @MaxGeneration)
		BEGIN
			SET @LastGeneration = @CurrentGeneration
		END
	END

	IF (@Version = 'C')
	BEGIN
		SELECT @LastGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject, @Version)
		--The error message should be displayed only if @IdProject is not null (there was at least 1 row in #BUDGET_PRESELECTION_TEMP).
		--If #BUDGET_PRESELECTION_TEMP has no row, it means that the budget is viewed from follow-up and there are no active wp's for
		--this project. In that case, an empty budget will be displayed and no error message.
		IF (@LastGeneration IS NULL AND @IdProject IS NOT NULL)
		BEGIN
			RAISERROR('No released version found for this budget', 16, 1)
			RETURN -2
		END

		SELECT @CurrentGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject, 'P')
	END

	IF (@Version = 'P')
	BEGIN
		SELECT @LastGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject, @Version)
		--The error message should be displayed only if @IdProject is not null (there was at least 1 row in #BUDGET_PRESELECTION_TEMP).
		--If #BUDGET_PRESELECTION_TEMP has no row, it means that the budget is viewed from follow-up and there are no active wp's for
		--this project. In that case, an empty budget will be displayed and no error message.
		IF (@LastGeneration IS NULL AND @IdProject IS NOT NULL)
		BEGIN
			RAISERROR('No previous version found for this budget', 16, 1)
			RETURN -3
		END

		SELECT @CurrentGeneration = CASE WHEN @LastGeneration > 1 THEN @LastGeneration - 1 ELSE NULL END
	END
	
	DECLARE	@AssociateCurrency INT
	DECLARE @AssociateCurrencyCode VARCHAR(10)

	if @IdCurrencyDisplay <= 0 
	   begin
	   -- if Currency wasn't specified on the page, then relies on the currency of the viewer
			--Find out the associate currency
			SELECT 	@AssociateCurrency = CTR.IdCurrency,
					@AssociateCurrencyCode = CRR.Code
			FROM ASSOCIATES ASOC
			INNER JOIN COUNTRIES CTR 
				ON CTR.Id = ASOC.IdCountry
			INNER JOIN CURRENCIES CRR 
				ON CRR.Id = CTR.IdCurrency
			WHERE ASOC.Id = @IdAssociateViewer
	   end
	else
	   begin
	   -- if Currency was specified on the page, then relies on the this currency. This becomes the currency of the viewer
			SELECT  @AssociateCurrency = @IdCurrencyDisplay,
					@AssociateCurrencyCode = Code
			from CURRENCIES
			where Id = @IdCurrencyDisplay

	   end

	DECLARE @IsBudgetValidated BIT
	SELECT 	@IsBudgetValidated = IsValidated
	FROM	BUDGET_REVISED
	WHERE	IdProject = @IdProject AND
		IdGeneration = @LastGeneration

	IF (@IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0)
	BEGIN
		DECLARE BudgetCursor CURSOR FAST_FORWARD FOR
		SELECT DISTINCT	BPT.IdProject		AS 	'IdProject',
						BPT.IdPhase			AS	'IdPhase',
						BPT.IdWP			AS 	'IdWP',
						CURR.Id 			AS	'IdCurrency',
						CURR.Code			AS	'CurrencyCode',
						BRD.YearMonth		AS	'YearMonth'
		FROM #BUDGET_PRESELECTION_TEMP AS BPT
		INNER JOIN BUDGET_REVISED_DETAIL AS BRD
			ON BRD.IdProject = BPT.IdProject
			AND BRD.IdPhase = BPT.IdPhase
			AND BRD.IdWorkPackage = BPT.IdWP  
			AND BRD.IdAssociate = CASE 	WHEN (@IdAssociate = -1) THEN BRD.IdAssociate ELSE @IdAssociate	END
		INNER JOIN PROJECT_CORE_TEAMS CTM
			ON CTM.IdProject = BRD.IdProject
			AND CTM.IdAssociate = BRD.IdAssociate	
		INNER JOIN COST_CENTERS AS CC
			ON CC.Id = BRD.IdCostCenter
		INNER JOIN INERGY_LOCATIONS AS IL
			ON IL.Id = CC.IdInergyLocation
		INNER JOIN COUNTRIES
			ON COUNTRIES.Id = IL.IdCountry
		INNER JOIN CURRENCIES CURR 
				ON CURR.Id = COUNTRIES.IdCurrency
		WHERE  CTM.IsActive = CASE WHEN (@IdAssociate =-1  AND @IsBudgetValidated = 0) THEN 1 ELSE CTM.IsActive END AND
			(BRD.IdGeneration = @CurrentGeneration OR BRD.IdGeneration = @LastGeneration)

		OPEN BudgetCursor
		DECLARE @CheckIdProject INT
		DECLARE @CheckIdPhase INT
		DECLARE @CheckIdWP 	INT
		DECLARE @IdCurrency INT
		DECLARE @YearMonth INT
		DECLARE @CurrencyCode VARCHAR(10)
		DECLARE @ER DECIMAL(12,6)
	
		FETCH NEXT FROM BudgetCursor INTO @CheckIdProject,@CheckIdPhase,@CheckIdWP,@IdCurrency,@CurrencyCode,@YearMonth
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @ER = dbo.fnGetExchangeRate(@AssociateCurrency, 	@IdCurrency, @YearMonth)
	
			IF (@ER IS NULL)
			BEGIN
				DECLARE @WpName VARCHAR(30)
				DECLARE @StartYM INT
				DECLARE @EndYM	INT
				SELECT 	@WpName = Code + ' - ' + Name,
					@StartYM = StartYearMonth,
					@EndYM = EndYearMonth
				FROM 	WORK_PACKAGES
				WHERE	IdProject = @CheckIdProject AND
					IdPhase = @CheckIdPhase AND
					Id = @CheckIdWP
				DECLARE @YM VARCHAR(7)
				DECLARE @SYM VARCHAR(7)
				DECLARE @EYM VARCHAR(7)
				SELECT @YM = dbo.fnGetYMStringRepresentation(@YearMonth)
				SELECT @SYM = dbo.fnGetYMStringRepresentation(@StartYM)
				SELECT @EYM = dbo.fnGetYMStringRepresentation(@EndYM)
				RAISERROR('No exchange rate found for %s to %s conversion for YearMonth %s (Work Package %s, period %s - %s).',
						16,1, @AssociateCurrencyCode,@CurrencyCode,@YM, @WpName, @SYM, @EYM )
				CLOSE BudgetCursor
				DEALLOCATE BudgetCursor
				RETURN -1
			END
		   	FETCH NEXT FROM BudgetCursor INTO @CheckIdProject,@CheckIdPhase,@CheckIdWP,@IdCurrency,@CurrencyCode,@YearMonth
			
		END
		CLOSE BudgetCursor
		DEALLOCATE BudgetCursor
	END

	SELECT
		BPT.IdProject 							AS 'IdProject',
		BPT.IdPhase 							AS 'IdPhase',
		BPT.IdWP	 							AS 'IdWP',
		CC.Id 									AS 'IdCostCenter',
		DP.Name+'-'+IL.Code+'-'+CC.Code			AS 'CostCenterName',
		dbo.fnGetRevisedBudgetOtherCosts(BPT.IdProject,	@CurrentGeneration, BPT.IdPhase, BPT.IdWP, MAX(BRD_CURRENT.IdCostCenter), @IdAssociate, @IsAssociateCurrency | @CurrencyDisplayBit, @AssociateCurrency) AS 'CurrentCost',
		CAST (0 as Decimal(19,4))				AS 'UpdateCost',
		dbo.fnGetRevisedBudgetOtherCosts(BPT.IdProject,	@LastGeneration, BPT.IdPhase, BPT.IdWP, MAX(BRD_NEW.IdCostCenter), @IdAssociate, @IsAssociateCurrency | @CurrencyDisplayBit, @AssociateCurrency) AS 'NewCost',
		dbo.fnGetRevisedBudgetSales(BPT.IdProject,	@CurrentGeneration, BPT.IdPhase, BPT.IdWP, MAX(BRD_CURRENT.IdCostCenter), @IdAssociate, @IsAssociateCurrency | @CurrencyDisplayBit, @AssociateCurrency) AS 'CurrentSales',
		CAST (0 as Decimal(18,4))				AS 'UpdateSales',
		dbo.fnGetRevisedBudgetSales(BPT.IdProject,	@LastGeneration, BPT.IdPhase, BPT.IdWP, MAX(BRD_NEW.IdCostCenter), @IdAssociate, @IsAssociateCurrency, @AssociateCurrency) AS 'NewSales',
		CURR.Id									AS 'IdCurrency',
		CURR.Code								AS 'CurrencyCode',
		DP.Rank									AS 'DeptRank'
	INTO #BUDGET_REVISED_DETAIL_TEMP
	FROM #BUDGET_PRESELECTION_TEMP AS BPT
	LEFT JOIN BUDGET_REVISED_DETAIL AS BRD_NEW
		ON BRD_NEW.IdProject = BPT.IdProject
		AND BRD_NEW.IdGeneration = @LastGeneration
		AND BRD_NEW.IdPhase = BPT.IdPhase
		AND BRD_NEW.IdWorkPackage = BPT.IdWP  
		AND BRD_NEW.IdAssociate = CASE 	WHEN @IdAssociate = -1 THEN BRD_NEW.IdAssociate ELSE @IdAssociate END
	LEFT JOIN BUDGET_REVISED_DETAIL AS BRD_CURRENT
		ON BRD_CURRENT.IdProject = BRD_NEW.IdProject
		AND BRD_CURRENT.IdGeneration = @CurrentGeneration
		AND BRD_CURRENT.IdPhase = BRD_NEW.IdPhase
		AND BRD_CURRENT.IdCostCenter = BRD_NEW.IdCostCenter
		AND BRD_CURRENT.IdWorkPackage = BRD_NEW.IdWorkPackage
		AND BRD_CURRENT.YearMonth = BRD_NEW.YearMonth
		AND BRD_CURRENT.IdAssociate = BRD_NEW.IdAssociate
	INNER JOIN PROJECT_CORE_TEAMS CTM
		ON CTM.IdProject = BRD_NEW.IdProject AND
		   CTM.IdAssociate = BRD_NEW.IdAssociate
	INNER JOIN COST_CENTERS AS CC 
		ON CC.Id = BRD_NEW.IdCostCenter
	INNER JOIN INERGY_LOCATIONS AS IL
		ON IL.Id = CC.IdInergyLocation
	INNER JOIN DEPARTMENTS DP
		ON DP.Id = CC.IdDepartment
	INNER JOIN COUNTRIES
		ON COUNTRIES.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR 
		ON CURR.Id=COUNTRIES.IdCurrency
	WHERE  CTM.IsActive = CASE WHEN (@IdAssociate =-1  AND @IsBudgetValidated = 0) THEN 1 ELSE CTM.IsActive END
		AND COUNTRIES.[Id] = CASE WHEN @IdCountry = -1 THEN COUNTRIES.[Id] ELSE @IdCountry END
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, CC.Id, CC.Code, CURR.Id, CURR.Code, DP.Name, Il.Code, DP.Rank

	--update the differences
	UPDATE #BUDGET_REVISED_DETAIL_TEMP
	SET UpdateCost = case when (NewCost IS NULL AND CurrentCost IS NULL) OR @CurrentGeneration IS NULL THEN 0
					  else ISNULL(NewCost,0) - ISNULL(CurrentCost,0) end,
		UpdateSales = case when (NewSales IS NULL AND CurrentSales IS NULL) OR @CurrentGeneration IS NULL THEN NULL
					  else ISNULL(NewSales,0) - ISNULL(CurrentSales,0) end
	
	--first select with phases
	SELECT
		BPT.IdProject 							AS 'IdProject',
		PP.Id 									AS 'IdPhase',
		PP.Code + ' - ' + PP.Name				AS 'PhaseName',
		SUM(ROUND(BRDT.CurrentCost, 0))			AS 'CurrentCost',
		SUM(ROUND(BRDT.UpdateCost, 0))			AS 'UpdateCost',
		SUM(ROUND(BRDT.NewCost, 0))				AS 'NewCost',
		SUM(ROUND(BRDT.CurrentSales, 0))		AS 'CurrentSales',
		SUM(ROUND(BRDT.UpdateSales, 0))		 	AS 'UpdateSales',
		SUM(ROUND(BRDT.NewSales, 0))			AS 'NewSales'
	FROM #BUDGET_PRESELECTION_TEMP AS BPT
	INNER JOIN PROJECT_PHASES AS PP
		ON PP.Id = BPT.IdPhase
	LEFT JOIN #BUDGET_REVISED_DETAIL_TEMP AS BRDT
		ON BRDT.IdProject = BPT.IdProject AND
			BRDT.IdPhase = BPT.IdPhase AND
			BRDT.IdWP = BPT.IdWP	
	GROUP BY BPT.IdProject, PP.Id, PP.Name, PP.Code
	
	--second select with workpackages
	SELECT
		BPT.IdProject 							AS 'IdProject',
		BPT.IdPhase 							AS 'IdPhase',
		BPT.IdWP	 							AS 'IdWP',
		WP.Code						AS 'WPCode',
		WP.Code + ' - ' + WP.Name 				AS 'WPName',
		WP.StartYearMonth 						AS 'StartYearMonth',
		WP.EndYearMonth 						AS 'EndYearMonth',
		SUM(ROUND(BRDT.CurrentCost, 0))			AS 'CurrentCost',
		SUM(ROUND(BRDT.UpdateCost, 0))			AS 'UpdateCost',
		SUM(ROUND(BRDT.NewCost, 0))				AS 'NewCost',
		SUM(ROUND(BRDT.CurrentSales, 0))		AS 'CurrentSales',
		SUM(ROUND(BRDT.UpdateSales, 0)) 		AS 'UpdateSales',
		SUM(ROUND(BRDT.NewSales, 0))			AS 'NewSales',
		WP.IsActive								AS 'IsActive'
	FROM #BUDGET_PRESELECTION_TEMP BPT
	INNER JOIN WORK_PACKAGES WP
		ON WP.IdProject = BPT.IdProject AND
		   WP.IdPhase = BPT.IdPhase AND
		   WP.Id = BPT.IdWP
	LEFT JOIN #BUDGET_REVISED_DETAIL_TEMP BRDT
		ON	BRDT.IdProject = BPT.IdProject AND
			BRDT.IdPhase = BPT.IdPhase AND
			BRDT.IdWP = BPT.IdWP
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, WP.Name, WP.StartYearMonth, WP.EndYearMonth, WP.Code, WP.IsActive
	
	--third select for costsenters
	SELECT
		IdProject,
		IdPhase,
		IdWP,
		IdCostCenter,
		CostCenterName,
		CurrentCost,
		UpdateCost,
		NewCost,
		CurrentSales,
		UpdateSales,
		NewSales,
		IdCurrency,
		CurrencyCode
	FROM #BUDGET_REVISED_DETAIL_TEMP
	ORDER BY DeptRank, CostCenterName

GO

