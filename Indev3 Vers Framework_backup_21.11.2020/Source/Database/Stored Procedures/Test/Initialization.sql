
--Drops the Procedure bgtFillExchangeRateCache if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtFillExchangeRateCache]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtFillExchangeRateCache
GO
CREATE PROCEDURE bgtFillExchangeRateCache
	@CurrencyFrom		INT,	--The CurrencyFrom of the selected Exchange Rate
	@CurrencyTo			INT,	--The CurrencyTo of the selected Exchange Rate
	@StartYearMonth		INT,	--The Start Year and Month on which Exchange Rates will be selected
	@EndYearMonth		INT		--The End Year and Month on which Exchange Rates will be selected
AS
	DECLARE @CurrentYearMonth INT,
			@ConversionRate   DECIMAL(10,4)

	CREATE TABLE #ER_TEMP
	(YearMonth 		   INT 			  NOT NULL, 
	 ExchangeRateValue DECIMAL(10, 4) NOT NULL)



	DECLARE YearMonthCursor CURSOR FAST_FORWARD FOR
	SELECT DISTINCT YearMonth
	FROM EXCHANGE_RATES
	WHERE 	(IdCurrencyTo = @CurrencyFrom OR
			IdCurrencyTo = @CurrencyTo) AND
			YearMonth BETWEEN @StartYearMonth AND @EndYearMonth
	ORDER BY YearMonth

	OPEN YearMonthCursor
	
	FETCH NEXT FROM YearMonthCursor
	INTO @CurrentYearMonth

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @ConversionRate = dbo.fnGetExchangeRate(@CurrencyFrom, @CurrencyTo, @CurrentYearMonth)

		IF (@ConversionRate IS NOT NULL)
		BEGIN
			INSERT INTO #ER_TEMP (YearMonth, ExchangeRateValue)
			VALUES (@CurrentYearMonth, @ConversionRate)
		END

		FETCH NEXT FROM YearMonthCursor
		INTO @CurrentYearMonth
	END
	CLOSE YearMonthCursor
	DEALLOCATE YearMonthCursor

	SELECT * FROM #ER_TEMP

GO

--Drops the Procedure bgtGetInitialBudgetEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.bgtGetInitialBudgetEvidence') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetInitialBudgetEvidence
GO

CREATE  PROCEDURE bgtGetInitialBudgetEvidence
	@IdProject				INT,
	@IdAssociate			INT, --The Id of associate that the budget belongs to
	@IdAssociateViewer		INT, --The Id of the associate viewing the budget
	@IsAssociateCurrency	BIT,
	@IdCountry		INT,
	@IdCurrencyDisplay		int = 0		
AS

	if @IdCurrencyDisplay is null
		set @IdCurrencyDisplay = 0

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
		RAISERROR('Budget check: key information about at least one of project''s WPs was changed by another user. Return to preselection screen and re-select your WPs.', 16, 1)
		RETURN -1
	END

	DECLARE	@AssociateCurrency INT
	DECLARE @AssociateCurrencyCode VARCHAR(10)
	
	--Find out the associate currency of the viewer
	if @IdCurrencyDisplay <= 0 
	   begin
	   -- if Currency wasn't specified on the page, then relies on the currency of the viewer
			SELECT  @AssociateCurrency = CTR.IdCurrency,
					@AssociateCurrencyCode = CRR.Code
			FROM ASSOCIATES AS ASOC
			INNER JOIN COUNTRIES AS CTR ON CTR.Id = ASOC.IdCountry
			INNER JOIN CURRENCIES AS CRR ON CRR.Id = CTR.IdCurrency
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

	--Selects the data for the third table and put it in a temportary table that will be used for 
	--JOINS for the first 2 tables

	
	DECLARE @IsBudgetValidated BIT
	SELECT 	@IsBudgetValidated = IsValidated
	FROM	BUDGET_INITIAL
	WHERE	IdProject = @IdProject

	IF (@IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0)
	BEGIN
		DECLARE BudgetCursor CURSOR FAST_FORWARD FOR
		SELECT 
			BPT.IdProject	AS 	'IdProject',
			BPT.IdPhase		AS	'IdPhase',
			BPT.IdWP		AS 	'IdWP',
			CURR.Id 		AS	'IdCurrency',
			CURR.Code		AS	'CurrencyCode',
			BID.YearMonth	AS	'YearMonth'
		FROM #BUDGET_PRESELECTION_TEMP AS BPT
		LEFT JOIN WORK_PACKAGES AS WP
			ON WP.IdProject = BPT.IdProject
			AND WP.IdPhase = BPT.IdPhase
			AND WP.Id = BPT.IdWP
		LEFT JOIN BUDGET_INITIAL_DETAIL AS BID
			ON BID.IdProject = BPT.IdProject
			AND BID.IdPhase = BPT.IdPhase
			AND BID.IdWorkPackage = BPT.IdWP  
			AND BID.IdAssociate = CASE 	WHEN (@IdAssociate = -1) THEN BID.IdAssociate ELSE @IdAssociate END
		INNER JOIN PROJECT_CORE_TEAMS CTM
			ON CTM.IdProject = BID.IdProject
			AND CTM.IdAssociate = BID.IdAssociate		
		INNER JOIN COST_CENTERS AS CC
			ON CC.Id = BID.IdCostCenter
		INNER JOIN INERGY_LOCATIONS AS IL
			ON IL.Id = CC.IdInergyLocation
		INNER JOIN COUNTRIES
			ON COUNTRIES.Id = IL.IdCountry
		INNER JOIN CURRENCIES CURR 
				ON CURR.Id = COUNTRIES.IdCurrency
		WHERE  CTM.IsActive = CASE WHEN (@IdAssociate =-1  AND @IsBudgetValidated = 0) THEN 1 ELSE CTM.IsActive END


		OPEN BudgetCursor
		DECLARE @CheckIdProject INT
		DECLARE @CheckIdPhase INT
		DECLARE @CheckIdWP 	INT
		DECLARE @IdCurrency INT
		DECLARE @YearMonth INT
		DECLARE @CurrencyCode VARCHAR(10)
		DECLARE @ER DECIMAL(12,6) = 0
	
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
					16,1, @AssociateCurrencyCode,@CurrencyCode, @YM, @WpName, @SYM, @EYM )
				CLOSE BudgetCursor
				DEALLOCATE BudgetCursor
				RETURN -2
			END
		   	FETCH NEXT FROM BudgetCursor INTO @CheckIdProject,@CheckIdPhase,@CheckIdWP,@IdCurrency,@CurrencyCode,@YearMonth
			
		END
		CLOSE BudgetCursor
		DEALLOCATE BudgetCursor
	END

	
	SELECT 
		BPT.IdProject							AS 'IdProject',
		BPT.IdPhase 							AS 'IdPhase',
		BPT.IdWP								AS 'IdWP',
		CC.Id									AS 'IdCostCenter',
		DP.Name+'-'+IL.Code+'-'+CC.Code			AS 'CostCenterName',
		SUM(BID.HoursQty)						AS 'HoursQty',
		CAST(0 as Decimal(18,4))				AS 'Averate',
		SUM(CASE WHEN @IsAssociateCurrency = 1  or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.Id,@AssociateCurrency,BID.YearMonth) ELSE 1	END 
			* BID.HoursVal)						AS 'HoursVal',
		SUM(CASE WHEN @IsAssociateCurrency = 1  or @IdCurrencyDisplay > 0  THEN dbo.fnGetExchangeRate(CURR.Id,@AssociateCurrency,BID.YearMonth) ELSE 1	END 
			* ISNULL(dbo.fnGetInitialOtherCosts(BID.IdProject,BID.IdPhase,BID.IdWorkPackage	,BID.IdCostCenter,BID.IdAssociate,BID.YearMonth),0)) 									
												AS 'OtherCosts',
		SUM(CASE WHEN @IsAssociateCurrency = 1   or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.Id,@AssociateCurrency,BID.YearMonth) ELSE 1	END 
			* BID.SalesVal)						AS 'SalesVal',	
		CAST(0 as Decimal(19,4))				AS 'NetCosts',
		CURR.Id									AS 'IdCurrency',
		CURR.Code								AS 'CurrencyCode',
		DP.Rank									AS 'DeptRank'
	INTO #BUDGET_INITIAL_DETAIL_TEMP
	FROM #BUDGET_PRESELECTION_TEMP AS BPT
	LEFT JOIN BUDGET_INITIAL_DETAIL AS BID
		ON BID.IdProject = BPT.IdProject AND
			BID.IdPhase = BPT.IdPhase AND
			BID.IdWorkPackage = BPT.IdWP AND 
			BID.IdAssociate = CASE 	WHEN @IdAssociate = -1 THEN BID.IdAssociate ELSE @IdAssociate	END
	INNER JOIN PROJECT_CORE_TEAMS CTM
		ON CTM.IdProject = BID.IdProject AND
		   CTM.IdAssociate = BID.IdAssociate	
	INNER JOIN COST_CENTERS CC
		ON CC.Id = BID.IdCostCenter
	INNER JOIN DEPARTMENTS DP
		ON DP.Id = CC.IdDepartment
	INNER JOIN INERGY_LOCATIONS IL
		ON IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES
		ON COUNTRIES.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR 
		ON CURR.Id = COUNTRIES.IdCurrency
	WHERE CTM.IsActive = CASE  WHEN (@IdAssociate = -1 AND @IsBudgetValidated = 0) THEN  1 ELSE CTM.IsActive END
		AND COUNTRIES.[Id] = CASE WHEN @IdCountry = -1 THEN COUNTRIES.[Id] ELSE @IdCountry END
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, CC.Id, CC.Code, CURR.Id, CURR.Code, DP.Name, Il.Code, DP.Rank
	

	--update phrase for differences (other cost is always non null - because of the 0 link necessary in the interface)
	UPDATE #BUDGET_INITIAL_DETAIL_TEMP
	SET NetCosts = ISNULL(HoursVal, 0) + ISNULL(OtherCosts,0) + ISNULL(SalesVal,0),
		Averate = CASE WHEN ISNULL(HoursQty,0)=0 THEN NULL ELSE HoursVal/HoursQty END

	--first select for phases
	SELECT 
		BPT.IdProject 					AS 'IdProject',
		PP.Id 							AS 'IdPhase',
		PP.Code + ' - ' + PP.Name 		AS 'PhaseName',
		SUM(BID.HoursQty)				AS 'TotalHours',
		CASE WHEN ISNULL(SUM(BID.HoursQty),0) = 0 THEN NULL
				ELSE ROUND(SUM(ROUND(BID.HoursVal, 0)) / SUM(BID.HoursQty), 0) END AS 'Averate',
		SUM(ROUND(BID.HoursVal, 0))		AS 'ValuedHours',
		SUM(ROUND(BID.OtherCosts, 0)) 	AS 'OtherCosts',
		SUM(ROUND(BID.SalesVal, 0)) 	AS 'Sales',
		SUM(ROUND(BID.NetCosts, 0))		AS 'NetCosts'
	FROM #BUDGET_PRESELECTION_TEMP BPT 
	INNER JOIN PROJECT_PHASES PP
		ON PP.Id = BPT.IdPhase
	LEFT JOIN #BUDGET_INITIAL_DETAIL_TEMP BID
		 ON BID.IdProject = BPT.IdProject AND
			BID.IdPhase = BPT.IdPhase AND
			BID.IdWP = BPT.IdWP
	GROUP BY BPT.IdProject, PP.Id, PP.Name, PP.Code

	--second select for workpackages
	SELECT 
		BPT.IdProject					AS 'IdProject',
		BPT.IdPhase 					AS 'IdPhase',
		BPT.IdWP						AS 'IdWP',
		WP.Code					AS 'WPCode',	
		WP.Code + ' - ' + WP.Name		AS 'WPName',
		WP.StartYearMonth				AS 'StartYearMonth',
		WP.EndYearMonth					AS 'EndYearMonth',
		SUM(BID.HoursQty)				AS 'TotalHours',
		CASE WHEN ISNULL(SUM(BID.HoursQty),0) = 0 THEN NULL
			ELSE ROUND(SUM(ROUND(BID.HoursVal, 0))/SUM(BID.HoursQty), 0) END AS 'Averate',
		SUM(ROUND(BID.HoursVal, 0))		AS 'ValuedHours',
		SUM(ROUND(BID.OtherCosts, 0)) 	AS 'OtherCosts',
		SUM(ROUND(BID.SalesVal, 0)) 	AS 'Sales',
		SUM(ROUND(BID.NetCosts, 0))		AS 'NetCosts',
		WP.IsActive						AS 'IsActive'
	FROM #BUDGET_PRESELECTION_TEMP BPT 
	INNER JOIN WORK_PACKAGES WP 
		ON WP.IdProject = BPT.IdProject AND
		   WP.IdPhase = BPT.IdPhase AND
		   WP.Id = BPT.IdWP
	LEFT JOIN #BUDGET_INITIAL_DETAIL_TEMP BID 
		ON 	BID.IdProject = BPT.IdProject AND
			BID.IdPhase = BPT.IdPhase AND
			BID.IdWP = BPT.IdWP
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, WP.Name, WP.StartYearMonth, WP.EndYearMonth, WP.Code, WP.IsActive
	
	--third select for costcenters
	SELECT 
		IdProject			AS	'IdProject',
		IdPhase				AS	'IdPhase',
		IdWP				AS	'IdWP',
		IdCostCenter		AS	'IdCostCenter',
		CostCenterName		AS	'CostCenterName',
		HoursQty			AS	'TotalHours',
		Averate				AS	'Averate',
		HoursVal			AS	'ValuedHours',
		OtherCosts			AS	'OtherCosts',
		SalesVal			AS	'Sales',
		NetCosts			AS	'NetCosts',
		IdCurrency			AS	'IdCurrency',
		CurrencyCode		AS	'CurrencyCode'
	FROM 	#BUDGET_INITIAL_DETAIL_TEMP
	ORDER BY DeptRank, CostCenterName


GO


--Drops the Procedure bgtGetInitialBudgetOtherCost if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetInitialBudgetOtherCost]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetInitialBudgetOtherCost
GO

CREATE  PROCEDURE bgtGetInitialBudgetOtherCost
	@IdProject				INT,		--The Id of the selected Project
	@IdPhase				INT,		--The Id of a phase from project
	@IdWP					INT,		--The Id of workpackage
	@IdCostCenter			INT,		--The Id of cost center
	@IdAssociate			INT,		--The Id of associate the budget belongs to
	@IdAssociateViewer		INT,		--The Id of associate viewing the budget
	@IsAssociateCurrency 	BIT,			--Specifies whether the values will be converted from the cost center
									--currency to the associate currency
	@IdCurrencyDisplay		int = 0
	
AS
BEGIN

	if @IdCurrencyDisplay is null
		set @IdCurrencyDisplay = 0


	DECLARE	@AssociateCurrency INT
	DECLARE @AssociateCurrencyCode VARCHAR(10)

	--Find out the associate currency
	if @IdCurrencyDisplay <= 0
	   begin
			SELECT 	@AssociateCurrency = CTR.IdCurrency,
					@AssociateCurrencyCode = CRR.Code
			FROM ASSOCIATES ASOC
			INNER JOIN COUNTRIES CTR 
				ON CTR.Id = ASOC.IdCountry
			INNER JOIN CURRENCIES AS CRR 
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


	SELECT 	BID_SUM.IdProject	AS 'IdProject',
		BID_SUM.IdPhase		AS 'IdPhase',
		BID_SUM.IdWorkPackage	AS 'IdWP',
		BID_SUM.IdCostcenter	AS 'IdCostCenter',
		BCT.[Id]		AS 'IdOtherCost',
		BCT.[Name]		AS 'OtherCostType',
		BID_SUM.AllOtherCosts   AS 'OtherCostVal',
		CURR.[Id]		AS 'IdCurrency',
		CURR.[Name]		AS 'CurrencyName'
		
	FROM (	SELECT 	BID.IdProject,
			BID.IdPhase,
			BID.IdWorkPackage,
			BID.IdCostCenter,
			BID.IdAssociate,
			BIDC.IdCostType,
			SUM(
				CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0
				THEN
					dbo.fnGetExchangeRate(CURR.Id, @AssociateCurrency, BIDC.YearMonth)
				ELSE
					1
				END * BIDC.CostVal
			)	AS 'AllOtherCosts'
		FROM 	BUDGET_INITIAL_DETAIL BID
		LEFT JOIN BUDGET_INITIAL_DETAIL_COSTS BIDC
			ON BIDC.IdProject = BID.IdProject
				AND BIDC.IdPhase = BID.IdPhase
				AND BIDC.IdWorkPackage = BID.IdWorkPackage
				AND BIDC.IdCostCenter = BID.IdCostCenter
				AND BIDC.IdAssociate = BID.IdAssociate
				AND BIDC.YearMonth = BID.YearMonth
		INNER JOIN COST_CENTERS CC 
			ON CC.Id = BID.IdCostCenter
		INNER JOIN INERGY_LOCATIONS IL 
			ON IL.Id = CC.IdInergyLocation
		INNER JOIN COUNTRIES 
			ON COUNTRIES.Id = IL.IdCountry
		INNER JOIN CURRENCIES CURR 
			ON CURR.Id=COUNTRIES.IdCurrency
		WHERE	BID.IdProject = @IdProject
			AND BID.IdPhase = @IdPhase
			AND BID.IdWorkPackage = @IdWP
			AND BID.IdCostCenter = @IdCostCenter
			AND BID.IdAssociate = @IdAssociate
		GROUP BY BID.IdProject,BID.IdPhase,BID.IdWorkPackage,
			BID.IdCostCenter,BID.IdAssociate,BIDC.IdCostType			
	)AS BID_SUM
	INNER JOIN BUDGET_COST_TYPES BCT
		ON BCT.Id = BID_SUM.IdCostType
	INNER JOIN COST_CENTERS CC 
		ON CC.Id = BID_SUM.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL 
		ON CC.IdInergyLocation = IL.Id
	INNER JOIN COUNTRIES
		ON IL.IdCountry = COUNTRIES.Id
	INNER JOIN CURRENCIES CURR 
		ON CURR.Id=COUNTRIES.IdCurrency
END

GO

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

--Drops the Procedure bgtGetRevisedBudgetHours if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.bgtGetRevisedBudgetHours') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetRevisedBudgetHours
GO

CREATE  PROCEDURE bgtGetRevisedBudgetHours
	@IdProject				INT,
	@IdAssociate			INT,	--The Id of associate
	@IdAssociateViewer		INT,	--The Id of associate
	@IsAssociateCurrency 	BIT,	--Specifies whether the values will be converted from the cost center
	@Version				CHAR(1),
	@IdCountry				INT,
	@IdCurrencyDisplay		int =0
AS
	DECLARE @CurrentGeneration	INT
	DECLARE @LastGeneration		INT
	

	if @IdCurrencyDisplay is null
		set @IdCurrencyDisplay = 1

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
		RAISERROR('Budget check: key information about at least one of project''s WPs was changed by another user. Return to preselection screen and re-select your WPs.', 16, 1)
		RETURN -1
	END
		
	IF (@Version = 'N')
	BEGIN
		SELECT @CurrentGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject, 'C')
		--The error message should be displayed only if @IdProject is not null (there was at least 1 row in #BUDGET_PRESELECTION_TEMP).
		--If #BUDGET_PRESELECTION_TEMP has no row, it means that the budget is viewed from follow-up and there are no active wp's for
		--this project. In that case, an empty budget will be displayed and no error message.
		IF (@CurrentGeneration IS NULL AND @IdProject IS NOT NULL)
		BEGIN
			RAISERROR('No released version found for this budget', 16, 1)
			RETURN -2
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
			RETURN -3
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
			RETURN -4
		END

		SELECT @CurrentGeneration = CASE WHEN @LastGeneration > 1 THEN @LastGeneration - 1 ELSE NULL END
	END
	
	DECLARE	@AssociateCurrency INT
	DECLARE @AssociateCurrencyCode VARCHAR(10)

	--Find out the associate currency
	if @IdCurrencyDisplay <= 0
	   begin
	   -- if Currency wasn't specified on the page, then relies on the currency of the viewer
			SELECT @AssociateCurrency = CTR.IdCurrency,
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
		SELECT DISTINCT
			BPT.IdProject	AS 	'IdProject',
			BPT.IdPhase		AS	'IdPhase',
			BPT.IdWP		AS 	'IdWP',
			CURR.Id 		AS	'IdCurrency',
			CURR.Code		AS	'CurrencyCode',
			BRD.YearMonth	AS	'YearMonth'
		FROM #BUDGET_PRESELECTION_TEMP AS BPT
		INNER JOIN BUDGET_REVISED_DETAIL AS BRD
			ON BRD.IdProject = BPT.IdProject
			AND BRD.IdPhase = BPT.IdPhase
			AND BRD.IdWorkPackage = BPT.IdWP  
			AND BRD.IdAssociate = CASE WHEN (@IdAssociate = -1) THEN BRD.IdAssociate ELSE @IdAssociate END
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
				RETURN -5
			END
		   	FETCH NEXT FROM BudgetCursor INTO @CheckIdProject,@CheckIdPhase,@CheckIdWP,@IdCurrency,@CurrencyCode,@YearMonth
			
		END
		CLOSE BudgetCursor
		DEALLOCATE BudgetCursor
	END

	DECLARE @UseHourlyRates BIT
	SET @UseHourlyRates = case when @Version IN ('P','C') then 0 else 1 end

	SELECT
	BPT.IdProject 						AS 'IdProject',
	BPT.IdPhase 						AS 'IdPhase',
	BPT.IdWP	 						AS 'IdWP',
	CC.Id 								AS 'IdCostCenter',
	DP.Name+'-'+IL.Code+'-'+CC.Code		AS 'CostCenterName',
	dbo.fnGetRevisedBudgetHoursQty(BPT.IdProject, @CurrentGeneration, BPT.IdPhase, BPT.IdWP, MAX(BRD_CURRENT.IdCostCenter), @IdAssociate) AS 'CurrentHours',
	CAST(0 as int)						AS 'UpdateHours',
	dbo.fnGetRevisedBudgetHoursQty(BPT.IdProject, @LastGeneration, BPT.IdPhase, BPT.IdWP, MAX(BRD_NEW.IdCostCenter), @IdAssociate) AS 'NewHours',	
	dbo.fnGetRevisedBudgetHoursVal(BPT.IdProject, @CurrentGeneration, BPT.IdPhase, BPT.IdWP, MAX(BRD_CURRENT.IdCostCenter), @IdAssociate, 0, @IsAssociateCurrency | @CurrencyDisplayBit, @AssociateCurrency) AS 'CurrentVal',
	CAST(0 as Decimal(18,2))			AS 'UpdateVal',
	dbo.fnGetRevisedBudgetHoursVal(BPT.IdProject, @LastGeneration, BPT.IdPhase, BPT.IdWP, MAX(BRD_NEW.IdCostCenter), @IdAssociate, @UseHourlyRates, @IsAssociateCurrency | @CurrencyDisplayBit, @AssociateCurrency) AS 'NewVal',
	CURR.Id								AS 'IdCurrency',
	CURR.Code							AS 'CurrencyCode',
	DP.Rank								AS 'DeptRank'
	INTO #BUDGET_REVISED_DETAIL_TEMP
	FROM #BUDGET_PRESELECTION_TEMP AS BPT
	LEFT JOIN BUDGET_REVISED_DETAIL AS BRD_NEW
		ON BRD_NEW.IdProject = BPT.IdProject
		AND BRD_NEW.IdGeneration = @LastGeneration
		AND BRD_NEW.IdPhase = BPT.IdPhase
		AND BRD_NEW.IdWorkPackage = BPT.IdWP  
		AND BRD_NEW.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BRD_NEW.IdAssociate ELSE @IdAssociate END
	LEFT JOIN BUDGET_REVISED_DETAIL AS BRD_CURRENT
		ON BRD_CURRENT.IdProject = BRD_NEW.IdProject
		AND BRD_CURRENT.IdGeneration = @CurrentGeneration
		AND BRD_CURRENT.IdPhase = BRD_NEW.IdPhase
		AND BRD_CURRENT.IdCostCenter = BRD_NEW.IdCostCenter
		AND BRD_CURRENT.IdWorkPackage = BRD_NEW.IdWorkPackage
		AND BRD_CURRENT.YearMonth = BRD_NEW.YearMonth
		AND BRD_CURRENT.IdAssociate = BRD_NEW.IdAssociate
	INNER JOIN PROJECT_CORE_TEAMS CTM
		ON CTM.IdProject = BRD_NEW.IdProject
		AND CTM.IdAssociate = BRD_NEW.IdAssociate
	INNER JOIN COST_CENTERS AS CC 
		ON CC.Id = BRD_NEW.IdCostCenter
	INNER JOIN DEPARTMENTS DP
		ON DP.Id = CC.IdDepartment
	INNER JOIN INERGY_LOCATIONS AS IL
		ON IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES
		ON COUNTRIES.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR 
		ON CURR.Id=COUNTRIES.IdCurrency
	WHERE  CTM.IsActive = CASE WHEN (@IdAssociate =-1  AND @IsBudgetValidated = 0) THEN 1 ELSE CTM.IsActive END
		AND COUNTRIES.[Id] = CASE WHEN @IdCountry = -1 THEN COUNTRIES.[Id] ELSE @IdCountry END
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, CC.Id, CC.Code, CURR.Id, CURR.Code, DP.Name, Il.Code, DP.Rank

	--update phrase for the differences taking care of cases in which one of the values is null
	UPDATE #BUDGET_REVISED_DETAIL_TEMP
	SET UpdateHours = case when (NewHours IS NULL AND CurrentHours IS NULL) OR @CurrentGeneration IS NULL THEN NULL
					  else ISNULL(NewHours,0) - ISNULL(CurrentHours,0) end,
		UpdateVal = case when (NewVal IS NULL AND CurrentVal IS NULL) OR @CurrentGeneration IS NULL THEN NULL
					  else ISNULL(NewVal,0) - ISNULL(CurrentVal,0) end
	
	--first select with phases
	SELECT
		BPT.IdProject 					AS 'IdProject',
		PP.Id 							AS 'IdPhase',
		PP.Code + ' - ' + PP.Name 		AS 'PhaseName',
		SUM(BRDT.CurrentHours)			AS 'CurrentHours',
		SUM(BRDT.UpdateHours)			AS 'UpdateHours',
		SUM(BRDT.NewHours)				AS 'NewHours',
		SUM(ROUND(BRDT.CurrentVal, 0))	AS 'CurrentVal',
		SUM(ROUND(BRDT.UpdateVal, 0))	AS 'UpdateVal',
		SUM(ROUND(BRDT.NewVal, 0))		AS 'NewVal'
	FROM #BUDGET_PRESELECTION_TEMP AS BPT
	INNER JOIN PROJECT_PHASES AS PP
		ON PP.Id = BPT.IdPhase
	LEFT JOIN #BUDGET_REVISED_DETAIL_TEMP AS BRDT ON 
			BRDT.IdProject = BPT.IdProject AND
			BRDT.IdPhase = BPT.IdPhase AND
			BRDT.IdWP = BPT.IdWP
	GROUP BY BPT.IdProject, PP.Id, PP.Name, PP.Code
	
	-- second select with workpackages
	SELECT
		BPT.IdProject 					AS 'IdProject',
		BPT.IdPhase 					AS 'IdPhase',
		BPT.IdWP	 					AS 'IdWP',
		WP.Code					AS 'WPCode',
		WP.Code + ' - ' + WP.Name 		AS 'WPName',
		WP.StartYearMonth 				AS 'StartYearMonth',
		WP.EndYearMonth 				AS 'EndYearMonth',
		SUM(BRDT.CurrentHours)			AS 'CurrentHours',
		SUM(BRDT.UpdateHours)			AS 'UpdateHours',
		SUM(BRDT.NewHours)				AS 'NewHours',
		SUM(ROUND(BRDT.CurrentVal, 0))	AS 'CurrentVal',
		SUM(ROUND(BRDT.UpdateVal, 0))	AS 'UpdateVal',
		SUM(ROUND(BRDT.NewVal, 0))		AS 'NewVal',
		WP.IsActive						AS 'IsActive'
	FROM #BUDGET_PRESELECTION_TEMP AS BPT
	INNER JOIN WORK_PACKAGES AS WP
		ON WP.IdProject = BPT.IdProject
		AND WP.IdPhase = BPT.IdPhase
		AND WP.Id = BPT.IdWP
	LEFT JOIN #BUDGET_REVISED_DETAIL_TEMP AS BRDT ON 
			BRDT.IdProject = BPT.IdProject AND
			BRDT.IdPhase = BPT.IdPhase AND
			BRDT.IdWP = BPT.IdWP
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, WP.Name, WP.StartYearMonth, WP.EndYearMonth, WP.Code, WP.IsActive
	
	--third select with cost centers
	SELECT
		IdProject,
		IdPhase,
		IdWP,
		IdCostCenter,
		CostCenterName,
		CurrentHours,
		UpdateHours,
		NewHours,
		CurrentVal,
		UpdateVal,
		NewVal,
		IdCurrency,
		CurrencyCode
	FROM #BUDGET_REVISED_DETAIL_TEMP
	ORDER BY DeptRank, CostCenterName

GO

--Drops the Procedure bgtGetRevisedBudgetOtherCosts if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetRevisedBudgetOtherCosts]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetRevisedBudgetOtherCosts
GO

CREATE  PROCEDURE bgtGetRevisedBudgetOtherCosts
	@IdProject				INT,		--The Id of the selected Project
	@IdPhase				INT,		--The Id of a phase from project
	@IdWP					INT,		--The Id of workpackage
	@IdCostCenter			INT,		--The Id of cost center
	@IdAssociate			INT,		--The Id of associate
	@IdAssociateViewer		INT,		--The Id of associate viewing the budget
	@IsAssociateCurrency 	BIT,		--Specifies whether the values will be converted from the cost center
						--currency to the associate currency
	@IdCurrencyDisplay int = 0
AS
BEGIN

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
		RAISERROR('Budget check: key information about at least one of project''s WPs was changed by another user. Return to preselection screen and re-select your WPs.', 16, 1)
		RETURN -1
	END


	DECLARE @CurrentGeneration	INT
	DECLARE @LastGeneration		INT
	
	SELECT @CurrentGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,'C')

	SELECT @LastGeneration = ISNULL(dbo.fnGetRevisedBudgetGeneration(@IdProject,'N'), @CurrentGeneration)

	
	DECLARE @MaxGeneration INT
	SELECT 	@MaxGeneration = MAX(IdGeneration)
	FROM	BUDGET_REVISED_DETAIL BRD
	WHERE 	BRD.IdProject = @IdProject AND
		BRD.IdAssociate = @IdAssociate
	
	IF (@LastGeneration <> @MaxGeneration)
	BEGIN
		SET @LastGeneration = @CurrentGeneration
	END

	
	DECLARE	@AssociateCurrency INT
	DECLARE @AssociateCurrencyCode VARCHAR(10)

	--Find out the associate currency
	if @IdCurrencyDisplay <= 0 
	   begin
	   -- if Currency wasn't specified on the page, then relies on the currency of the viewer
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


	SELECT 	@IdProject									AS 'IdProject',
			@IdPhase									AS 'IdPhase',
			@IdWP										AS 'IdWP',
			@IdCostcenter								AS 'IdCostCenter',
			BCT.[Name]									AS 'OtherCostType',
			BRD_SUM_CURRENT.AllOtherCosts		   		AS 'CurrentCost',
			CASE WHEN (BRD_SUM_NEW.AllOtherCosts IS NULL AND BRD_SUM_CURRENT.AllOtherCosts IS NULL) THEN NULL
				 ELSE ISNULL(BRD_SUM_NEW.AllOtherCosts,0) - ISNULL(BRD_SUM_CURRENT.AllOtherCosts,0)	END	AS 'UpdateCost',
			BRD_SUM_NEW.AllOtherCosts					AS 'NewCost',
			CURR.Id										AS 'IdCurrency',
			CURR.[Name]									AS 'CurrencyName'
	FROM (	SELECT 	BRD.IdProject	AS 'IdProject',
			BRD.IdPhase,
			BRD.IdWorkPackage,
			BRD.IdCostCenter,
			BRD.IdAssociate,
			BRDC.IdCostType,
			SUM(CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN	dbo.fnGetExchangeRate(CURR.Id, @AssociateCurrency, BRDC.YearMonth) ELSE 1	END
				 * BRDC.CostVal)	AS 'AllOtherCosts'
		FROM 	BUDGET_REVISED_DETAIL BRD
			INNER JOIN BUDGET_REVISED_DETAIL_COSTS BRDC
				ON BRDC.IdProject = @IdProject
				AND BRDC.IdGeneration = @LastGeneration
				AND BRDC.IdPhase = @IdPhase
				AND BRDC.IdWorkPackage = @IdWP
				AND BRDC.IdCostCenter = @IdCostCenter
				AND BRDC.IdAssociate = @IdAssociate
				AND BRDC.YearMonth = BRD.YearMonth
			INNER JOIN COST_CENTERS AS CC 
				ON CC.Id = BRD.IdCostCenter
			INNER JOIN INERGY_LOCATIONS AS IL
				ON IL.Id = CC.IdInergyLocation
			INNER JOIN COUNTRIES
				ON COUNTRIES.Id = IL.IdCountry
			INNER JOIN CURRENCIES CURR 
				ON CURR.Id=COUNTRIES.IdCurrency
		WHERE	BRD.IdProject = @IdProject
			AND BRD.IdGeneration = @LastGeneration
			AND BRD.IdPhase = @IdPhase
			AND BRD.IdWorkPackage = @IdWP
			AND BRD.IdCostCenter = @IdCostCenter
			AND BRD.IdAssociate = @IdAssociate
		GROUP BY BRD.IdProject,BRD.IdPhase,BRD.IdWorkPackage,
			BRD.IdCostCenter,BRD.IdAssociate,BRDC.IdCostType			
	)AS BRD_SUM_NEW 
	LEFT JOIN (	SELECT 	BRD.IdProject AS 'IdProject',
			BRD.IdPhase,
			BRD.IdWorkPackage,
			BRD.IdCostCenter,
			BRD.IdAssociate,
			BRDC.IdCostType,
			SUM(CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN	dbo.fnGetExchangeRate(CURR.Id, @AssociateCurrency, BRDC.YearMonth) ELSE 1	END 
					* BRDC.CostVal)	AS 'AllOtherCosts'
		FROM 	BUDGET_REVISED_DETAIL BRD
			INNER JOIN BUDGET_REVISED_DETAIL_COSTS BRDC
				ON BRDC.IdProject = @IdProject
				AND BRDC.IdGeneration = @CurrentGeneration
				AND BRDC.IdPhase = @IdPhase
				AND BRDC.IdWorkPackage = @IdWP
				AND BRDC.IdCostCenter = @IdCostCenter
				AND BRDC.IdAssociate = @IdAssociate
				AND BRDC.YearMonth = BRD.YearMonth
			INNER JOIN COST_CENTERS AS CC 
				ON CC.Id = BRD.IdCostCenter
			INNER JOIN INERGY_LOCATIONS AS IL
				ON IL.Id = CC.IdInergyLocation
			INNER JOIN COUNTRIES
				ON COUNTRIES.Id = IL.IdCountry
			INNER JOIN CURRENCIES CURR 
				ON CURR.Id=COUNTRIES.IdCurrency
		WHERE	BRD.IdProject = @IdProject
			AND BRD.IdGeneration = @CurrentGeneration
			AND BRD.IdPhase = @IdPhase
			AND BRD.IdWorkPackage = @IdWP
			AND BRD.IdCostCenter = @IdCostCenter
			AND BRD.IdAssociate = @IdAssociate
		GROUP BY BRD.IdProject,BRD.IdPhase,BRD.IdWorkPackage,
			BRD.IdCostCenter,BRD.IdAssociate,BRDC.IdCostType			
	)AS BRD_SUM_CURRENT
	ON BRD_SUM_NEW.IdProject = BRD_SUM_CURRENT.IdProject
		AND BRD_SUM_NEW.IdPhase = BRD_SUM_CURRENT.IdPhase
		AND BRD_SUM_NEW.IdWorkPackage = BRD_SUM_CURRENT.IdWorkPackage
		AND BRD_SUM_NEW.IdCostCenter = BRD_SUM_CURRENT.IdCostCenter
		AND BRD_SUM_NEW.IdAssociate = BRD_SUM_CURRENT.IdAssociate
		AND BRD_SUM_NEW.IdCostType = BRD_SUM_CURRENT.IdCostType
	INNER JOIN BUDGET_COST_TYPES AS BCT
		ON BCT.Id = BRD_SUM_NEW.IdCostType
	INNER JOIN COST_CENTERS AS CC 
		ON CC.Id = BRD_SUM_NEW.IdCostCenter
	INNER JOIN INERGY_LOCATIONS AS IL
		ON IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES
		ON COUNTRIES.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR 
		ON CURR.Id=COUNTRIES.IdCurrency

END

GO

--Drops the Procedure bgtGetToCompletionBudgetOtherCostsEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetToCompletionBudgetGrossCostsEvidence]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetToCompletionBudgetGrossCostsEvidence
GO

CREATE  PROCEDURE bgtGetToCompletionBudgetGrossCostsEvidence
	@IdProject 				INT,
	@IdAssociate			INT,
	@IdAssociateViewer		INT,
	@Version				CHAR(1), -- First version of budget
	@IsAssociateCurrency 	BIT,
	@ShowOnlyCCsWithSignificantValues	BIT,
	@IdCountry		INT,
	@IdCurrencyDisplay		int = 0
AS

	if @IdCurrencyDisplay is null
		set @IdCurrencyDisplay = 0

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

	DECLARE @RetVal INT
	
	
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
		RETURN -2
	END

	--Find out the associate currency
	DECLARE	@AssociateCurrency INT
	DECLARE @AssociateCurrencyCode VARCHAR(10)
	
	if @IdCurrencyDisplay <= 0 
		begin
		-- if Currency wasn't specified on the page, then relies on the currency of the viewer
			IF (@IsAssociateCurrency = 1)
			BEGIN
				SELECT @AssociateCurrency = CTR.IdCurrency,
					   @AssociateCurrencyCode = CRR.Code
				FROM ASSOCIATES ASOC
				INNER JOIN COUNTRIES CTR 
					ON CTR.Id = ASOC.IdCountry
				INNER JOIN CURRENCIES CRR 
					ON CRR.Id = CTR.IdCurrency
				WHERE ASOC.Id = @IdAssociateViewer
			END
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
	FROM	BUDGET_TOCOMPLETION
	WHERE	IdProject = @IdProject AND
		IdGeneration = @ToCompletionCurrentGenerationNo

	CREATE TABLE #BUDGET_TOCOMPLETION_DETAIL_TEMP
	(
		Id int identity(1,1),
		IdProject INT NOT NULL,
		IdPhase INT NOT NULL,
		IdWP INT NOT NULL,
		IdCostCenter INT NOT NULL,
		IdAssociate INT NOT NULL,
		YearMonth INT NOT NULL,
		WPName VARCHAR(36),
		CostCenterName VARCHAR(50),
		Previous DECIMAL(21, 6),
		IsPreviousActual BIT NOT NULL,
		CurrentPreviousDiff DECIMAL(21, 6),
		[Current] DECIMAL(21, 6),
		IsCurrentActual BIT NOT NULL,
		NewCurrentDiff DECIMAL(21, 6),
		New DECIMAL(21, 6),
		IsNewActual BIT NOT NULL,
		NewRevisedDiff DECIMAL(21, 6),
		Revised DECIMAL(21, 6),
		PRIMARY KEY (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth)
	)

	INSERT INTO #BUDGET_TOCOMPLETION_DETAIL_TEMP (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth, IsNewActual, IsCurrentActual, IsPreviousActual)
	EXEC bgtGetToCompletionBudgetKeysTable @IdProject = @IdProject, @IdAssociate = @IdAssociate, @Version = @Version

	IF (@IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0)
	BEGIN
		EXEC @RetVal = bgtCheckERForReforcastKeys @IdAssociate = @IdAssociate, @AssociateCurrency = @AssociateCurrency, @AssociateCurrencyCode = @AssociateCurrencyCode
		IF (@@ERROR <> 0 OR @RetVal < 0)
			RETURN -3
	END

	--Set the flag for IsNewActual to 0 if there are no actual data for the previous month 
	UPDATE	BTD
	SET	BTD.IsNewActual = 0
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	WHERE	BTD.YearMonth = dbo.fnGetYearMonthOfPreviousMonth(getdate()) AND
		/*
		COALESCE(dbo.fnGetActualOtherCosts(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, -1),
			 dbo.fnGetActualHoursVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth)
			) IS NULL
		*/
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
	SET 	BTD.New = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
			*
			CASE WHEN (@Version = 'P' OR @Version = 'C')
			THEN
				CASE WHEN (dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionNewGenerationNo, BTD.YearMonth, -1) IS NULL AND
				     BCD.HoursVal IS NULL
				) THEN NULL ELSE 
				(ISNULL(dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionNewGenerationNo, BTD.YearMonth, -1), 0) 
				+ ISNULL(BCD.HoursVal, 0))
			  	END
			ELSE
				CASE WHEN (dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionNewGenerationNo, BTD.YearMonth, -1) IS NULL AND
				     dbo.fnGetValuedHours(BTD.IdCostCenter, BCD.HoursQty, BTD.YearMonth) IS NULL
				) THEN NULL ELSE 
				(ISNULL(dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionNewGenerationNo, BTD.YearMonth, -1), 0) 
				+ ISNULL(dbo.fnGetValuedHours(BTD.IdCostCenter, BCD.HoursQty, BTD.YearMonth), 0))
			  	END
			END
			  
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionNewGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsNewActual = 0

	--Add new values from Actual (for entries that are from actual)

	UPDATE 	BTD
	SET 	BTD.New = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				* (ISNULL(dbo.fnGetActualOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, -1), 0) 
				+ ISNULL(dbo.fnGetActualHoursVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth)	, 0))
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsNewActual = 1

	--Add released values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				*
				  CASE WHEN (dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionCurrentGenerationNo, BTD.YearMonth, -1) IS NULL AND
					     BCD.HoursVal IS NULL
					) THEN NULL ELSE 
					(ISNULL(dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionCurrentGenerationNo, BTD.YearMonth, -1), 0) 
					+ ISNULL(BCD.HoursVal, 0))
				  END
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionCurrentGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE 	BTD.IsCurrentActual = 0

	--Add current values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				* (ISNULL(dbo.fnGetActualOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, -1), 0) 
				+ ISNULL(dbo.fnGetActualHoursVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth)	, 0))
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsCurrentActual = 1

	--Add previous values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Previous] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				*
				  CASE WHEN (dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionPreviousGenerationNo, BTD.YearMonth, -1) IS NULL AND
					     BCD.HoursVal IS NULL
					) THEN NULL ELSE 
					(ISNULL(dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionPreviousGenerationNo, BTD.YearMonth, -1), 0) 
					+ ISNULL(BCD.HoursVal, 0))
				  END
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionPreviousGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	IsPreviousActual = 0

	--Add previous values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.Previous = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				* (ISNULL(dbo.fnGetActualOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, -1), 0) 
				+ ISNULL(dbo.fnGetActualHoursVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth)	, 0))
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsPreviousActual = 1


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

	--Add revised values
	UPDATE 	BTD
	SET 	BTD.Revised = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END 
				* 
			      CASE WHEN dbo.fnGetToCompletionRevisedOtherCosts(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @RevisedGenerationNo, BTD.YearMonth, -1) IS NULL AND
				BRD.HoursVal IS NULL
			      THEN NULL
			      ELSE ISNULL(dbo.fnGetToCompletionRevisedOtherCosts(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @RevisedGenerationNo, BTD.YearMonth, -1), 0) + ISNULL(BRD.HoursVal, 0)
			      END
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_REVISED_DETAIL BRD ON 
		BRD.IdProject = BTD.IdProject AND
		BRD.IdGeneration = @RevisedGenerationNo AND
		BRD.IdPhase = BTD.IdPhase AND
		BRD.IdWorkPackage = BTD.IdWP AND
		BRD.IdCostCenter = BTD.IdCostCenter AND
		BRD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BRD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency

	--Update diff columns
	IF (@ToCompletionNewGenerationNo IS NOT NULL and @ToCompletionCurrentGenerationNo is NOT NULL)
	BEGIN
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	NewCurrentDiff = CASE WHEN New IS NULL AND [Current] IS NULL THEN NULL ELSE ISNULL(ROUND(New, 0), 0) - ISNULL(ROUND([Current], 0), 0) END
	END

	IF (@ToCompletionNewGenerationNo IS NOT NULL)--revised will always have a current version no need to test
	BEGIN
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	NewRevisedDiff = CASE WHEN New IS NULL AND Revised IS NULL THEN NULL ELSE ISNULL(ROUND(New, 0), 0) - ISNULL(ROUND(Revised, 0), 0) END
	END

	IF (@ToCompletionPreviousGenerationNo IS NOT NULL and @ToCompletionCurrentGenerationNo is NOT NULL)	
	BEGIN
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	CurrentPreviousDiff = CASE WHEN [Current] IS NULL AND Previous IS NULL THEN NULL ELSE ISNULL(ROUND([Current], 0), 0) - ISNULL(ROUND(Previous, 0), 0) END	
	END


	CREATE TABLE #CC_TABLE
	(
		IdProject		INT,
		IdPhase			INT,
		IdWP			INT,
		IdCostCenter		INT,
		CostCenterName		VARCHAR(50),
		Previous		DECIMAL(21, 6),
		CurrentPreviousDiff	DECIMAL(21, 6),
		[Current]		DECIMAL(21, 6),
		NewCurrentDiff		DECIMAL(21, 6),
		New			DECIMAL(21, 6),
		NewRevisedDiff		DECIMAL(21, 6),
		Revised			DECIMAL(21, 6),
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
			SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
			SUM(ROUND(BTD.CurrentPreviousDiff, 0)) 	AS	'CurrentPreviousDiff',
			SUM(ROUND(BTD.[Current], 0))		AS 	'Current',
			SUM(ROUND(BTD.NewCurrentDiff, 0))	AS	'NewCurrentDiff',
			SUM(ROUND(BTD.New, 0))			AS	'New',
			SUM(ROUND(BTD.NewRevisedDiff, 0))	AS	'NewRevisedDiff',
			SUM(ROUND(BTD.Revised, 0))		AS 	'Revised',
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
			SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
			SUM(ROUND(BTD.CurrentPreviousDiff, 0)) 	AS	'CurrentPreviousDiff',
			SUM(ROUND(BTD.[Current], 0))		AS 	'Current',
			SUM(ROUND(BTD.NewCurrentDiff, 0))	AS	'NewCurrentDiff',
			SUM(ROUND(BTD.New, 0))			AS	'New',
			SUM(ROUND(BTD.NewRevisedDiff, 0))	AS	'NewRevisedDiff',
			SUM(ROUND(BTD.Revised, 0))		AS 	'Revised',
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



	--Select the first table
	SELECT 	BPT.IdProject 			AS	'IdProject',
		BPT.IdPhase			AS	'IdPhase',
		BPT.IdWP			AS	'IdWP',
		WP.Code				AS	'PhaseWPCode',
		WP.Code + ' - ' + WP.Name	AS	'PhaseWPName',
		CASE WHEN @IdAssociate = -1 THEN dbo.fnGetWeightedAveragePercent(BPT.IdProject, @ToCompletionNewGenerationNo, BPT.IdPhase, BPT.IdWP, @IdAssociate) 
		     ELSE MAX(BCP.[Percent]) END AS 	'Progress',
		WP.StartYearMonth		AS	'StartYearMonth',
		WP.EndYearMonth			AS	'EndYearMonth',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.Previous, 0), 0)) ELSE NULL END		AS	'Previous',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.CurrentPreviousDiff, 0), 0)) ELSE NULL END 	AS	'CurrentPreviousDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.[Current], 0), 0)) ELSE NULL END		AS 	'Current',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.NewCurrentDiff, 0), 0)) ELSE NULL END	AS	'NewCurrentDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.New, 0), 0)) ELSE NULL END			AS	'New',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.NewRevisedDiff, 0), 0)) ELSE NULL END	AS	'NewRevisedDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.Revised, 0), 0)) ELSE NULL END		AS 	'Revised',
		WP.IsActive			AS 	'IsActive'
	FROM 	#BUDGET_PRESELECTION_TEMP BPT
	LEFT JOIN BUDGET_TOCOMPLETION_PROGRESS BCP ON 
		BCP.IdProject = BPT.IdProject AND
		BCP.IdGeneration = @ToCompletionNewGenerationNo AND
		BCP.IdPhase = BPT.IdPhase AND
		BCP.IdWorkPackage = BPT.IdWP AND
		BCP.IdAssociate = @IdAssociate
	LEFT JOIN #CC_TABLE CC ON
		CC.IdProject = BPT.IdProject AND
		CC.IdPhase = BPT.IdPhase AND
		CC.IdWP = BPT.IdWP
	INNER JOIN WORK_PACKAGES AS WP ON
		WP.IdProject = BPT.IdProject AND
		WP.IdPhase = BPT.IdPhase AND
		WP.[Id] = BPT.IdWP
	INNER JOIN PROJECT_PHASES PH ON
		PH.Id = WP.IdPhase
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, BCP.[Percent], WP.StartYearMonth, WP.EndYearMonth, WP.IsActive, PH.Code, WP.Code, WP.Name
	ORDER BY PH.Code


	--Select the second table
	SELECT IdProject, IdPhase, IdWP, IdCostCenter, CostCenterName, Previous, CurrentPreviousDiff, [Current],
		NewCurrentDiff, New, NewRevisedDiff, Revised, IdCurrency, CurrencyCode
	FROM #CC_TABLE


	--Select the third table
	SELECT	BTD.IdProject		AS	'IdProject',
		BTD.IdPhase			AS	'IdPhase',
		BTD.IdWP			AS	'IdWP',
		BTD.IdCostCenter		AS	'IdCostCenter',
		BTD.YearMonth		AS	'YearMonth',
		SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
		BTD.IsPreviousActual	AS	'IsPreviousActual',
		SUM(ROUND(BTD.CurrentPreviousDiff, 0))	AS	'CurrentPreviousDiff',
		SUM(ROUND(BTD.[Current], 0))		AS	'Current',
		BTD.IsCurrentActual		AS	'IsCurrentActual',
		SUM(ROUND(BTD.NewCurrentDiff, 0))		AS	'NewCurrentDiff',
		SUM(ROUND(BTD.New, 0))			AS	'New',
		BTD.IsNewActual		AS	'IsNewActual',
		SUM(ROUND(BTD.NewRevisedDiff, 0))		AS	'NewRevisedDiff',
		SUM(ROUND(BTD.Revised, 0))			AS	'Revised'
	FROM #BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	GROUP BY BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, BTD.IsPreviousActual, BTD.IsCurrentActual, BTD.IsNewActual
	ORDER BY BTD.YearMonth

GO

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

--Drops the Procedure bgtGetToCompletionBudgetNetCostsEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetToCompletionBudgetNetCostsEvidence]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetToCompletionBudgetNetCostsEvidence
GO

CREATE  PROCEDURE bgtGetToCompletionBudgetNetCostsEvidence
	@IdProject 				INT,
	@IdAssociate			INT,
	@IdAssociateViewer		INT,
	@IsAssociateCurrency 	BIT,
	@Version				CHAR(1), -- version of budget
	@ShowOnlyCCsWithSignificantValues	BIT,
	@IdCountry		INT,
	@IdCurrencyDisplay		int = 0
AS

	if @IdCurrencyDisplay is null
		set @IdCurrencyDisplay = 0

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

	DECLARE @RetVal INT
	

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

	--Find out the associate currency
	DECLARE	@AssociateCurrency INT
	DECLARE @AssociateCurrencyCode VARCHAR(10)

	if @IdCurrencyDisplay <= 0 
		begin
		-- if Currency wasn't specified on the page, then relies on the currency of the viewer
			IF (@IsAssociateCurrency = 1)
			BEGIN
				SELECT @AssociateCurrency = CTR.IdCurrency,
					   @AssociateCurrencyCode = CRR.Code
				FROM ASSOCIATES AS ASOC
				INNER JOIN COUNTRIES AS CTR 
					ON CTR.Id = ASOC.IdCountry
				INNER JOIN CURRENCIES AS CRR 
					ON CRR.Id = CTR.IdCurrency
				WHERE ASOC.Id = @IdAssociateViewer
			END
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
	FROM	BUDGET_TOCOMPLETION
	WHERE	IdProject = @IdProject AND
		IdGeneration = @ToCompletionCurrentGenerationNo


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
		Previous DECIMAL(21, 6),
		IsPreviousActual BIT NOT NULL,
		CurrentPreviousDiff DECIMAL(21, 6),
		[Current] DECIMAL(21, 6),
		IsCurrentActual BIT NOT NULL,
		NewCurrentDiff DECIMAL(21, 6),
		New DECIMAL(21, 6),
		IsNewActual BIT NOT NULL,
		NewRevisedDiff DECIMAL(21, 6),
		Revised DECIMAL(21, 6),
		PRIMARY KEY (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth)
	)

	INSERT INTO #BUDGET_TOCOMPLETION_DETAIL_TEMP (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth, IsNewActual, IsCurrentActual, IsPreviousActual)
	EXEC bgtGetToCompletionBudgetKeysTable @IdProject = @IdProject, @IdAssociate = @IdAssociate, @Version = @Version

	IF (@IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0)
	BEGIN
		EXEC @RetVal = bgtCheckERForReforcastKeys @IdAssociate = @IdAssociate, @AssociateCurrency = @AssociateCurrency, @AssociateCurrencyCode = @AssociateCurrencyCode
		IF (@@ERROR <> 0 OR @RetVal < 0)
			RETURN -2
	END

	--Set the flag for IsNewActual to 0 if there are no actual data for the previous month 
	UPDATE	BTD
	SET	BTD.IsNewActual = 0
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	WHERE	BTD.YearMonth = dbo.fnGetYearMonthOfPreviousMonth(getdate()) AND
		/*
		COALESCE(dbo.fnGetActualOtherCosts(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, -1),
			 dbo.fnGetActualHoursVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth),
			 dbo.fnGetActualSalesVal (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth)
			) IS NULL
		*/
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
	SET 	BTD.New = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
			*
			CASE WHEN (@Version = 'P' OR @Version = 'C')
			THEN
				CASE WHEN (dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionNewGenerationNo, BTD.YearMonth, -1) IS NULL AND
				     BCD.HoursVal IS NULL AND BCD.SalesVal IS NULL
				) THEN NULL ELSE 
				(ISNULL(dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionNewGenerationNo, BTD.YearMonth, -1), 0) 
				+ ISNULL(BCD.HoursVal, 0) + ISNULL(BCD.SalesVal, 0))
			  	END
			ELSE
				CASE WHEN (dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionNewGenerationNo, BTD.YearMonth, -1) IS NULL AND
				     dbo.fnGetValuedHours(BTD.IdCostCenter, BCD.HoursQty, BTD.YearMonth) IS NULL AND BCD.SalesVal IS NULL
				) THEN NULL ELSE 
				(ISNULL(dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionNewGenerationNo, BTD.YearMonth, -1), 0) 
				+ ISNULL(dbo.fnGetValuedHours(BTD.IdCostCenter, BCD.HoursQty, BTD.YearMonth), 0) + ISNULL(BCD.SalesVal, 0))
			  	END
			END
			  
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionNewGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsNewActual = 0

	--Add new values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.New = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
					*	(ISNULL(dbo.fnGetActualOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, -1), 0) 
						+ ISNULL(dbo.fnGetActualHoursVal (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth), 0) 
						+ ISNULL(dbo.fnGetActualSalesVal (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth), 0))
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsNewActual = 1

	--Add released values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				*
				  CASE WHEN (dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionCurrentGenerationNo, BTD.YearMonth, -1) IS NULL AND
					     BCD.HoursVal IS NULL AND BCD.SalesVal IS NULL
					) THEN NULL ELSE 
					(ISNULL(dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionCurrentGenerationNo, BTD.YearMonth, -1), 0) 
					+ ISNULL(BCD.HoursVal, 0) + ISNULL(BCD.SalesVal, 0))
				  END
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionCurrentGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE 	BTD.IsCurrentActual = 0

	--Add current values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
					*	(ISNULL(dbo.fnGetActualOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, -1), 0) 
						+ ISNULL(dbo.fnGetActualHoursVal (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth), 0) 
						+ ISNULL(dbo.fnGetActualSalesVal (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth), 0))
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsCurrentActual = 1

	--Add previous values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Previous] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				*
				  CASE WHEN (dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionPreviousGenerationNo, BTD.YearMonth, -1) IS NULL AND
					     BCD.HoursVal IS NULL AND BCD.SalesVal IS NULL
					) THEN NULL ELSE 
					(ISNULL(dbo.fnGetToCompletionOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @ToCompletionPreviousGenerationNo, BTD.YearMonth, -1), 0) 
					+ ISNULL(BCD.HoursVal, 0) + ISNULL(BCD.SalesVal, 0))
				  END
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionPreviousGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	IsPreviousActual = 0

	--Add previous values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.Previous = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
					*	(ISNULL(dbo.fnGetActualOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, -1), 0) 
						+ ISNULL(dbo.fnGetActualHoursVal (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth), 0) 
						+ ISNULL(dbo.fnGetActualSalesVal (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth), 0))
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsPreviousActual = 1

	--Add revised values
	UPDATE 	BTD
	SET 	BTD.Revised = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END 
				* 
			      CASE WHEN dbo.fnGetToCompletionRevisedOtherCosts(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @RevisedGenerationNo, BTD.YearMonth, -1) IS NULL AND
				BRD.HoursVal IS NULL AND BRD.SalesVal IS NULL
			      THEN NULL
			      ELSE ISNULL(dbo.fnGetToCompletionRevisedOtherCosts(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @RevisedGenerationNo, BTD.YearMonth, -1), 0) 
			 	+ ISNULL(BRD.HoursVal, 0) + ISNULL(BRD.SalesVal, 0)
			      END
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_REVISED_DETAIL BRD ON 
		BRD.IdProject = BTD.IdProject AND
		BRD.IdGeneration = @RevisedGenerationNo AND
		BRD.IdPhase = BTD.IdPhase AND
		BRD.IdWorkPackage = BTD.IdWP AND
		BRD.IdCostCenter = BTD.IdCostCenter AND
		BRD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BRD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency

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
		SET 	NewCurrentDiff = CASE WHEN New IS NULL AND [Current] IS NULL THEN NULL ELSE ISNULL(ROUND(New, 0), 0) - ISNULL(ROUND([Current], 0), 0) END
	END

	IF (@ToCompletionNewGenerationNo IS NOT NULL)--revised will always have a current version no need to test
	BEGIN
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	NewRevisedDiff = CASE WHEN New IS NULL AND Revised IS NULL THEN NULL ELSE ISNULL(ROUND(New, 0), 0) - ISNULL(ROUND(Revised, 0), 0) END
	END

	IF (@ToCompletionPreviousGenerationNo IS NOT NULL and @ToCompletionCurrentGenerationNo is NOT NULL)	
	BEGIN
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	CurrentPreviousDiff = CASE WHEN [Current] IS NULL AND Previous IS NULL THEN NULL ELSE ISNULL(ROUND([Current], 0), 0) - ISNULL(ROUND(Previous, 0), 0) END	
	END


	CREATE TABLE #CC_TABLE
	(
		IdProject		INT,
		IdPhase			INT,
		IdWP			INT,
		IdCostCenter		INT,
		CostCenterName		VARCHAR(50),
		Previous		DECIMAL(21, 6),
		CurrentPreviousDiff	DECIMAL(21, 6),
		[Current]		DECIMAL(21, 6),
		NewCurrentDiff		DECIMAL(21, 6),
		New			DECIMAL(21, 6),
		NewRevisedDiff		DECIMAL(21, 6),
		Revised			DECIMAL(21, 6),
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
			SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
			SUM(ROUND(BTD.CurrentPreviousDiff, 0)) 	AS	'CurrentPreviousDiff',
			SUM(ROUND(BTD.[Current], 0))		AS 	'Current',
			SUM(ROUND(BTD.NewCurrentDiff, 0))	AS	'NewCurrentDiff',
			SUM(ROUND(BTD.New, 0))			AS	'New',
			SUM(ROUND(BTD.NewRevisedDiff, 0))	AS	'NewRevisedDiff',
			SUM(ROUND(BTD.Revised, 0))		AS 	'Revised',
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
			SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
			SUM(ROUND(BTD.CurrentPreviousDiff, 0)) 	AS	'CurrentPreviousDiff',
			SUM(ROUND(BTD.[Current], 0))		AS 	'Current',
			SUM(ROUND(BTD.NewCurrentDiff, 0))	AS	'NewCurrentDiff',
			SUM(ROUND(BTD.New, 0))			AS	'New',
			SUM(ROUND(BTD.NewRevisedDiff, 0))	AS	'NewRevisedDiff',
			SUM(ROUND(BTD.Revised, 0))		AS 	'Revised',
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



	--Select the first table
	SELECT 	BPT.IdProject 			AS	'IdProject',
		BPT.IdPhase			AS	'IdPhase',
		BPT.IdWP			AS	'IdWP',
		WP.Code				AS	'PhaseWPCode', 
		WP.Code + ' - ' + WP.Name	AS	'PhaseWPName',
		CASE WHEN @IdAssociate = -1 THEN dbo.fnGetWeightedAveragePercent(BPT.IdProject, @ToCompletionNewGenerationNo, BPT.IdPhase, BPT.IdWP, @IdAssociate) 
		     ELSE MAX(BCP.[Percent]) END AS 	'Progress',
		WP.StartYearMonth		AS	'StartYearMonth',
		WP.EndYearMonth			AS	'EndYearMonth',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.Previous, 0), 0)) ELSE NULL END		AS	'Previous',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.CurrentPreviousDiff, 0), 0)) ELSE NULL END 	AS	'CurrentPreviousDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.[Current], 0), 0)) ELSE NULL END		AS 	'Current',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.NewCurrentDiff, 0), 0)) ELSE NULL END	AS	'NewCurrentDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.New, 0), 0)) ELSE NULL END			AS	'New',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.NewRevisedDiff, 0), 0)) ELSE NULL END	AS	'NewRevisedDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.Revised, 0), 0)) ELSE NULL END		AS 	'Revised',
		WP.IsActive			AS 	'IsActive'
	FROM 	#BUDGET_PRESELECTION_TEMP BPT
	LEFT JOIN BUDGET_TOCOMPLETION_PROGRESS BCP ON 
		BCP.IdProject = BPT.IdProject AND
		BCP.IdGeneration = @ToCompletionNewGenerationNo AND
		BCP.IdPhase = BPT.IdPhase AND
		BCP.IdWorkPackage = BPT.IdWP AND
		BCP.IdAssociate = @IdAssociate
	LEFT JOIN #CC_TABLE CC ON
		CC.IdProject = BPT.IdProject AND
		CC.IdPhase = BPT.IdPhase AND
		CC.IdWP = BPT.IdWP
	INNER JOIN WORK_PACKAGES AS WP ON
		WP.IdProject = BPT.IdProject AND
		WP.IdPhase = BPT.IdPhase AND
		WP.[Id] = BPT.IdWP
	INNER JOIN PROJECT_PHASES PH ON
		PH.Id = WP.IdPhase
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, BCP.[Percent], WP.StartYearMonth, WP.EndYearMonth, WP.IsActive, PH.Code, WP.Code, WP.Name
	ORDER BY PH.Code


	--Select the second table
	SELECT IdProject, IdPhase, IdWP, IdCostCenter, CostCenterName, Previous, CurrentPreviousDiff, [Current],
		NewCurrentDiff, New, NewRevisedDiff, Revised, IdCurrency, CurrencyCode
	FROM #CC_TABLE


	--Select the third table
	SELECT	BTD.IdProject		AS	'IdProject',
		BTD.IdPhase			AS	'IdPhase',
		BTD.IdWP			AS	'IdWP',
		BTD.IdCostCenter		AS	'IdCostCenter',
		BTD.YearMonth		AS	'YearMonth',
		SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
		BTD.IsPreviousActual	AS	'IsPreviousActual',
		SUM(ROUND(BTD.CurrentPreviousDiff, 0))	AS	'CurrentPreviousDiff',
		SUM(ROUND(BTD.[Current], 0))		AS	'Current',
		BTD.IsCurrentActual		AS	'IsCurrentActual',
		SUM(ROUND(BTD.NewCurrentDiff, 0))		AS	'NewCurrentDiff',
		SUM(ROUND(BTD.New, 0))			AS	'New',
		BTD.IsNewActual		AS	'IsNewActual',
		SUM(ROUND(BTD.NewRevisedDiff, 0))		AS	'NewRevisedDiff',
		SUM(ROUND(BTD.Revised, 0))			AS	'Revised'
	FROM #BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	GROUP BY BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, BTD.IsPreviousActual, BTD.IsCurrentActual, BTD.IsNewActual
	ORDER BY BTD.YearMonth


GO

--Drops the Procedure bgtGetToCompletionBudgetOtherCostsEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetToCompletionBudgetOtherCostsEvidence]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetToCompletionBudgetOtherCostsEvidence
GO

CREATE  PROCEDURE bgtGetToCompletionBudgetOtherCostsEvidence
	@IdProject				INT,
	@IdAssociate			INT,
	@IdAssociateViewer		INT,
	@IsAssociateCurrency 	BIT,
	@Version				CHAR(1), -- First version of budget
	@IdCostType				INT,
	@ShowOnlyCCsWithSignificantValues	BIT,
	@IdCountry		INT,
	@IdCurrencyDisplay		int = 0
AS

	if @IdCurrencyDisplay is null
		set @IdCurrencyDisplay = 0

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

	DECLARE @RetVal INT
	

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
		RETURN -2
	END

	--Find out the associate currency
	DECLARE	@AssociateCurrency INT
	DECLARE @AssociateCurrencyCode VARCHAR(10)

	if @IdCurrencyDisplay <= 0 
		begin
		-- if Currency wasn't specified on the page, then relies on the currency of the viewer
			IF (@IsAssociateCurrency = 1)
			BEGIN
				SELECT @AssociateCurrency = CTR.IdCurrency,
					   @AssociateCurrencyCode = CRR.Code
				FROM ASSOCIATES AS ASOC
				INNER JOIN COUNTRIES AS CTR 
					ON CTR.Id = ASOC.IdCountry
				INNER JOIN CURRENCIES AS CRR 
					ON CRR.Id = CTR.IdCurrency
				WHERE ASOC.Id = @IdAssociateViewer
			END
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
	FROM	BUDGET_TOCOMPLETION
	WHERE	IdProject = @IdProject AND
			IdGeneration = @ToCompletionCurrentGenerationNo

	
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
		Previous DECIMAL(22, 6),
		IsPreviousActual BIT NOT NULL,
		CurrentPreviousDiff DECIMAL(22, 6),
		[Current] DECIMAL(22, 6),
		IsCurrentActual BIT NOT NULL,
		NewCurrentDiff DECIMAL(22, 6),
		New DECIMAL(22, 6),
		IsNewActual BIT NOT NULL,
		NewRevisedDiff DECIMAL(22, 6),
		Revised DECIMAL(22, 6),
		PRIMARY KEY (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth)
	)

	INSERT INTO #BUDGET_TOCOMPLETION_DETAIL_TEMP (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth, IsNewActual, IsCurrentActual, IsPreviousActual)
	EXEC bgtGetToCompletionBudgetKeysTable @IdProject = @IdProject, @IdAssociate = @IdAssociate, @Version = @Version

	IF (@IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0)
	BEGIN
		EXEC @RetVal = bgtCheckERForReforcastKeys @IdAssociate = @IdAssociate, @AssociateCurrency = @AssociateCurrency, @AssociateCurrencyCode = @AssociateCurrencyCode
		IF (@@ERROR <> 0 OR @RetVal < 0)
			RETURN -3
	END

	--Set the flag for IsNewActual to 0 if there are no actual data for the previous month 
	UPDATE	BTD
	SET	BTD.IsNewActual = 0
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	WHERE	BTD.YearMonth = dbo.fnGetYearMonthOfPreviousMonth(getdate()) AND
		--dbo.fnGetActualOtherCosts(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, -1) IS NULL
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
	SET 	BTD.New = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
			* dbo.fnGetToCompletionOtherCosts(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END,
			@ToCompletionNewGenerationNo, BTD.YearMonth, @IdCostType)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionNewGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsNewActual = 0

	--Add new values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.New = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
			* ISNULL(dbo.fnGetActualOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, @IdCostType),0)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsNewActual = 1

	--Add released values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				* dbo.fnGetToCompletionOtherCosts(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END,
				@ToCompletionCurrentGenerationNo, BTD.YearMonth, @IdCostType)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionCurrentGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE 	BTD.IsCurrentActual = 0

	--Add current values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				* ISNULL(dbo.fnGetActualOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, @IdCostType),0)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsCurrentActual = 1

	--Add previous values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Previous] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				* dbo.fnGetToCompletionOtherCosts(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END,
				@ToCompletionPreviousGenerationNo, BTD.YearMonth, @IdCostType)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionPreviousGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	IsPreviousActual = 0

	--Add previous values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.Previous = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				* ISNULL(dbo.fnGetActualOtherCosts (BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, @IdCostType),0)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsPreviousActual = 1

	--Add revised values
	UPDATE 	BTD
	SET 	BTD.Revised = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END 
				* dbo.fnGetToCompletionRevisedOtherCosts(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter,
				CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END, @RevisedGenerationNo, BTD.YearMonth,
				@IdCostType)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_REVISED_DETAIL BRD ON 
		BRD.IdProject = BTD.IdProject AND
		BRD.IdGeneration = @RevisedGenerationNo AND
		BRD.IdPhase = BTD.IdPhase AND
		BRD.IdWorkPackage = BTD.IdWP AND
		BRD.IdCostCenter = BTD.IdCostCenter AND
		BRD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BRD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency

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
		SET 	NewCurrentDiff = CASE WHEN New IS NULL AND [Current] IS NULL THEN NULL ELSE ISNULL(ROUND(New, 0), 0) - ISNULL(ROUND([Current], 0), 0) END
	END

	IF (@ToCompletionNewGenerationNo IS NOT NULL)--revised will always have a current version no need to test
	BEGIN
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	NewRevisedDiff = CASE WHEN New IS NULL AND Revised IS NULL THEN NULL ELSE ISNULL(ROUND(New, 0), 0) - ISNULL(ROUND(Revised, 0), 0) END
	END

	IF (@ToCompletionPreviousGenerationNo IS NOT NULL and @ToCompletionCurrentGenerationNo is NOT NULL)	
	BEGIN
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	CurrentPreviousDiff = CASE WHEN [Current] IS NULL AND Previous IS NULL THEN NULL ELSE ISNULL(ROUND([Current], 0), 0) - ISNULL(ROUND(Previous, 0), 0) END	
	END


	CREATE TABLE #CC_TABLE
	(
		IdProject		INT,
		IdPhase			INT,
		IdWP			INT,
		IdCostCenter		INT,
		CostCenterName		VARCHAR(50),
		Previous		DECIMAL(22, 6),
		CurrentPreviousDiff	DECIMAL(22, 6),
		[Current]		DECIMAL(22, 6),
		NewCurrentDiff		DECIMAL(22, 6),
		New			DECIMAL(22, 6),
		NewRevisedDiff		DECIMAL(22, 6),
		Revised			DECIMAL(22, 6),
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
			SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
			SUM(ROUND(BTD.CurrentPreviousDiff, 0)) 	AS	'CurrentPreviousDiff',
			SUM(ROUND(BTD.[Current], 0))		AS 	'Current',
			SUM(ROUND(BTD.NewCurrentDiff, 0))	AS	'NewCurrentDiff',
			SUM(ROUND(BTD.New, 0))			AS	'New',
			SUM(ROUND(BTD.NewRevisedDiff, 0))	AS	'NewRevisedDiff',
			SUM(ROUND(BTD.Revised, 0))		AS 	'Revised',
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
			SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
			SUM(ROUND(BTD.CurrentPreviousDiff, 0)) 	AS	'CurrentPreviousDiff',
			SUM(ROUND(BTD.[Current], 0))		AS 	'Current',
			SUM(ROUND(BTD.NewCurrentDiff, 0))	AS	'NewCurrentDiff',
			SUM(ROUND(BTD.New, 0))			AS	'New',
			SUM(ROUND(BTD.NewRevisedDiff, 0))	AS	'NewRevisedDiff',
			SUM(ROUND(BTD.Revised, 0))		AS 	'Revised',
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



	--Select the first table
	SELECT 	BPT.IdProject 			AS	'IdProject',
		BPT.IdPhase			AS	'IdPhase',
		BPT.IdWP			AS	'IdWP',
		WP.Code				AS	'PhaseWPCode',
		WP.Code + ' - ' + WP.Name	AS	'PhaseWPName',
		CASE WHEN @IdAssociate = -1 THEN dbo.fnGetWeightedAveragePercent(BPT.IdProject, @ToCompletionNewGenerationNo, BPT.IdPhase, BPT.IdWP, @IdAssociate) 
		     ELSE MAX(BCP.[Percent]) END AS 	'Progress',
		WP.StartYearMonth		AS	'StartYearMonth',
		WP.EndYearMonth			AS	'EndYearMonth',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.Previous, 0), 0)) ELSE NULL END		AS	'Previous',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.CurrentPreviousDiff, 0), 0)) ELSE NULL END 	AS	'CurrentPreviousDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.[Current], 0), 0)) ELSE NULL END		AS 	'Current',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.NewCurrentDiff, 0), 0)) ELSE NULL END	AS	'NewCurrentDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.New, 0), 0)) ELSE NULL END			AS	'New',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.NewRevisedDiff, 0), 0)) ELSE NULL END	AS	'NewRevisedDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.Revised, 0), 0)) ELSE NULL END		AS 	'Revised',
		WP.IsActive			AS 	'IsActive'
	FROM 	#BUDGET_PRESELECTION_TEMP BPT
	LEFT JOIN BUDGET_TOCOMPLETION_PROGRESS BCP ON 
		BCP.IdProject = BPT.IdProject AND
		BCP.IdGeneration = @ToCompletionNewGenerationNo AND
		BCP.IdPhase = BPT.IdPhase AND
		BCP.IdWorkPackage = BPT.IdWP AND
		BCP.IdAssociate = @IdAssociate
	LEFT JOIN #CC_TABLE CC ON
		CC.IdProject = BPT.IdProject AND
		CC.IdPhase = BPT.IdPhase AND
		CC.IdWP = BPT.IdWP
	INNER JOIN WORK_PACKAGES AS WP ON
		WP.IdProject = BPT.IdProject AND
		WP.IdPhase = BPT.IdPhase AND
		WP.[Id] = BPT.IdWP
	INNER JOIN PROJECT_PHASES PH ON
		PH.Id = WP.IdPhase
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, BCP.[Percent], WP.StartYearMonth, WP.EndYearMonth, WP.IsActive, PH.Code, WP.Code, WP.Name
	ORDER BY PH.Code


	--Select the second table
	SELECT IdProject, IdPhase, IdWP, IdCostCenter, CostCenterName, Previous, CurrentPreviousDiff, [Current],
		NewCurrentDiff, New, NewRevisedDiff, Revised, IdCurrency, CurrencyCode
	FROM #CC_TABLE


	--Select the third table
	SELECT	BTD.IdProject		AS	'IdProject',
		BTD.IdPhase			AS	'IdPhase',
		BTD.IdWP			AS	'IdWP',
		BTD.IdCostCenter		AS	'IdCostCenter',
		BTD.YearMonth		AS	'YearMonth',
		SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
		BTD.IsPreviousActual	AS	'IsPreviousActual',
		SUM(ROUND(BTD.CurrentPreviousDiff, 0))	AS	'CurrentPreviousDiff',
		SUM(ROUND(BTD.[Current], 0))		AS	'Current',
		BTD.IsCurrentActual		AS	'IsCurrentActual',
		SUM(ROUND(BTD.NewCurrentDiff, 0))		AS	'NewCurrentDiff',
		SUM(ROUND(BTD.New, 0))			AS	'New',
		BTD.IsNewActual		AS	'IsNewActual',
		SUM(ROUND(BTD.NewRevisedDiff, 0))		AS	'NewRevisedDiff',
		SUM(ROUND(BTD.Revised, 0))			AS	'Revised'
	FROM #BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	GROUP BY BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, BTD.IsPreviousActual, BTD.IsCurrentActual, BTD.IsNewActual
	ORDER BY BTD.YearMonth

GO

--Drops the Procedure bgtGetToCompletionBudgetSalesEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetToCompletionBudgetSalesEvidence]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetToCompletionBudgetSalesEvidence
GO

CREATE  PROCEDURE bgtGetToCompletionBudgetSalesEvidence
	@IdProject				INT,
	@IdAssociate			INT,
	@IdAssociateViewer		INT,
	@IsAssociateCurrency 	BIT,
	@Version				CHAR(1), -- Version of budget
	@ShowOnlyCCsWithSignificantValues	BIT,
	@IdCountry		INT,
	@IdCurrencyDisplay		int = 0
AS
	
	if @IdCurrencyDisplay is null
		set @IdCurrencyDisplay = 0

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

	DECLARE @RetVal INT
	

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
		Previous DECIMAL(20, 6),
		IsPreviousActual BIT NOT NULL,
		CurrentPreviousDiff DECIMAL(20, 6),
		[Current] DECIMAL(20, 6),
		IsCurrentActual BIT NOT NULL,
		NewCurrentDiff DECIMAL(20, 6),
		New DECIMAL(20, 6),
		IsNewActual BIT NOT NULL,
		NewRevisedDiff DECIMAL(20, 6),
		Revised DECIMAL(20, 6),
		PRIMARY KEY (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth)
	)

	INSERT INTO #BUDGET_TOCOMPLETION_DETAIL_TEMP (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth, IsNewActual, IsCurrentActual, IsPreviousActual)
	EXEC bgtGetToCompletionBudgetKeysTable @IdProject = @IdProject, @IdAssociate = @IdAssociate, @Version = @Version



--Find out the associate currency
	DECLARE	@AssociateCurrency INT
	DECLARE @AssociateCurrencyCode VARCHAR(10)
	
	if @IdCurrencyDisplay <= 0
	   begin
	   -- if Currency wasn't specified on the page, then relies on the currency of the viewer
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

-- check to find if there is exchange rate for every record
	IF (@IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0)
	BEGIN
		EXEC @RetVal = bgtCheckERForReforcastKeys @IdAssociate, @AssociateCurrency, @AssociateCurrencyCode
		IF (@@ERROR <> 0 OR @RetVal < 0)
		BEGIN
			RETURN -2
		END
	END

	--Set the flag for IsNewActual to 0 if there are no actual data for the previous month 
	UPDATE	BTD
	SET	BTD.IsNewActual = 0
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	WHERE	BTD.YearMonth = dbo.fnGetYearMonthOfPreviousMonth(getdate()) AND
		--dbo.fnGetActualSalesVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth) IS NULL	
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
	SET 	BTD.New =
				CASE 	WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0
					THEN 
						dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BCD.YearMonth)
					ELSE
						1
					END 
						* 
					BCD.SalesVal


	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionNewGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = BTD.IdAssociate AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsNewActual = 0

	--Add new values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.New = CASE 	WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN 	dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE	1 END 
						*  ISNULL(dbo.fnGetActualSalesVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth),0)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsNewActual = 1

	--Add released values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = CASE 	WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0
					THEN 
						dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BCD.YearMonth)
					ELSE
						1
					END 
						* 
					BCD.SalesVal


	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionCurrentGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = BTD.IdAssociate AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency

	WHERE 	BTD.IsCurrentActual = 0

	--Add current values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END 
							* ISNULL(dbo.fnGetActualSalesVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth),0)	
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsCurrentActual = 1

	--Add previous values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Previous] = CASE 	WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0
					THEN 
						dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BCD.YearMonth)
					ELSE
						1
					END 
						* 
					BCD.SalesVal


	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionPreviousGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = BTD.IdAssociate AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	IsPreviousActual = 0

	--Add previous values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.Previous = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE	1 END 
							*  ISNULL(dbo.fnGetActualSalesVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth),0)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency

	WHERE	BTD.IsPreviousActual = 1

	--Add revised values
	UPDATE 	BTD
	SET 	BTD.Revised = CASE 	WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0
					THEN 
						dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BRD.YearMonth)
					ELSE
						1
					END 
						* 
					BRD.SalesVal

	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_REVISED_DETAIL BRD ON 
		BRD.IdProject = BTD.IdProject AND
		BRD.IdGeneration = @RevisedGenerationNo AND
		BRD.IdPhase = BTD.IdPhase AND
		BRD.IdWorkPackage = BTD.IdWP AND
		BRD.IdCostCenter = BTD.IdCostCenter AND
		BRD.IdAssociate = BTD.IdAssociate AND
		BRD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency


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


	CREATE TABLE #CC_TABLE
	(
		IdProject		INT,
		IdPhase			INT,
		IdWP			INT,
		IdCostCenter		INT,
		CostCenterName		VARCHAR(50),
		Previous		DECIMAL(20, 6),
		CurrentPreviousDiff	DECIMAL(20, 6),
		[Current]		DECIMAL(20, 6),
		NewCurrentDiff		DECIMAL(20, 6),
		New			DECIMAL(20, 6),
		NewRevisedDiff		DECIMAL(20, 6),
		Revised			DECIMAL(20, 6),
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


	
	--Select the first table
	SELECT 	BPT.IdProject 				AS	'IdProject',
		BPT.IdPhase				AS	'IdPhase',
		BPT.IdWP				AS	'IdWP',
		WP.Code					AS	'PhaseWPCode',
		WP.Code + ' - ' + WP.Name		AS	'PhaseWPName',
		CASE WHEN @IdAssociate = -1 THEN dbo.fnGetWeightedAveragePercent(BPT.IdProject, @ToCompletionNewGenerationNo, BPT.IdPhase, BPT.IdWP, @IdAssociate) 
		     ELSE MAX(BCP.[Percent]) END 	AS 'Progress',
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
	FROM 	#BUDGET_PRESELECTION_TEMP BPT
	LEFT JOIN BUDGET_TOCOMPLETION_PROGRESS BCP ON 
		BCP.IdProject = BPT.IdProject AND
		BCP.IdGeneration = @ToCompletionNewGenerationNo AND
		BCP.IdPhase = BPT.IdPhase AND
		BCP.IdWorkPackage = BPT.IdWP AND
		BCP.IdAssociate = @IdAssociate
	LEFT JOIN #CC_TABLE CC ON
		CC.IdProject = BPT.IdProject AND
		CC.IdPhase = BPT.IdPhase AND
		CC.IdWP = BPT.IdWP
	INNER JOIN WORK_PACKAGES AS WP ON
		WP.IdProject = BPT.IdProject AND
		WP.IdPhase = BPT.IdPhase AND
		WP.[Id] = BPT.IdWP
	INNER JOIN PROJECT_PHASES PH ON
		PH.Id = WP.IdPhase
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, BCP.[Percent], WP.StartYearMonth, WP.EndYearMonth, WP.IsActive, PH.Code, WP.Code, WP.Name
	ORDER BY PH.Code


	--Select the second table
	SELECT IdProject, IdPhase, IdWP, IdCostCenter, CostCenterName, Previous, CurrentPreviousDiff, [Current],
		NewCurrentDiff, New, NewRevisedDiff, Revised, IdCurrency, CurrencyCode
	FROM #CC_TABLE
	

	--Select the third table
	SELECT	BTD.IdProject			AS	'IdProject',
		BTD.IdPhase			AS	'IdPhase',
		BTD.IdWP			AS	'IdWP',
		BTD.IdCostCenter		AS	'IdCostCenter',
		BTD.YearMonth			AS	'YearMonth',
		SUM(BTD.Previous)		AS	'Previous',
		BTD.IsPreviousActual		AS	'IsPreviousActual',
		SUM(BTD.CurrentPreviousDiff)	AS	'CurrentPreviousDiff',
		SUM(BTD.[Current])		AS	'Current',
		BTD.IsCurrentActual		AS	'IsCurrentActual',
		SUM(BTD.NewCurrentDiff)		AS	'NewCurrentDiff',
		SUM(BTD.New)			AS	'New',
		BTD.IsNewActual			AS	'IsNewActual',
		SUM(BTD.NewRevisedDiff)		AS	'NewRevisedDiff',
		SUM(BTD.Revised)		AS	'Revised'
	FROM #BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	GROUP BY BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, BTD.IsPreviousActual, BTD.IsCurrentActual, BTD.IsNewActual
	ORDER BY BTD.YearMonth

GO


	--Drops the Procedure bgtGetToCompletionBudgetValHoursEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetToCompletionBudgetValHoursEvidence]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetToCompletionBudgetValHoursEvidence
GO

CREATE  PROCEDURE bgtGetToCompletionBudgetValHoursEvidence
	@IdProject 				INT,
	@IdAssociate			INT,
	@IdAssociateViewer		INT,
	@Version				CHAR(1), -- First version of budget
	@IsAssociateCurrency 	BIT,
	@ShowOnlyCCsWithSignificantValues	BIT,
	@IdCountry 		INT,
	@IdCurrencyDisplay		int = 0
AS

	if @IdCurrencyDisplay is null
		set @IdCurrencyDisplay = 0

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

	DECLARE @RetVal INT
	

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
		RETURN -2
	END

	--Find out the associate currency
	DECLARE	@AssociateCurrency INT
	DECLARE @AssociateCurrencyCode VARCHAR(10)

	if @IdCurrencyDisplay <= 0 
		begin
		-- if Currency wasn't specified on the page, then relies on the currency of the viewer
			IF (@IsAssociateCurrency = 1)
			BEGIN
				SELECT @AssociateCurrency = CTR.IdCurrency,
					   @AssociateCurrencyCode = CRR.Code
				FROM ASSOCIATES ASOC
				INNER JOIN COUNTRIES CTR 
					ON CTR.Id = ASOC.IdCountry
				INNER JOIN CURRENCIES CRR 
					ON CRR.Id = CTR.IdCurrency
				WHERE ASOC.Id = @IdAssociateViewer
			END
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
	FROM	BUDGET_TOCOMPLETION
	WHERE	IdProject = @IdProject AND
		IdGeneration = @ToCompletionCurrentGenerationNo

 
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
		Previous DECIMAL(20, 6),
		IsPreviousActual BIT NOT NULL,
		CurrentPreviousDiff DECIMAL(20, 6),
		[Current] DECIMAL(20, 6),
		IsCurrentActual BIT NOT NULL,
		NewCurrentDiff DECIMAL(20, 6),
		New DECIMAL(20, 6),
		IsNewActual BIT NOT NULL,
		NewRevisedDiff DECIMAL(20, 6),
		Revised DECIMAL(20, 6),
		PRIMARY KEY (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth)
	)

	INSERT INTO #BUDGET_TOCOMPLETION_DETAIL_TEMP (IdProject, IdPhase, IdWP, IdCostCenter, IdAssociate, YearMonth, IsNewActual, IsCurrentActual, IsPreviousActual)
	EXEC bgtGetToCompletionBudgetKeysTable @IdProject = @IdProject, @IdAssociate = @IdAssociate, @Version = @Version

	IF (@IsAssociateCurrency = 1  or @IdCurrencyDisplay > 0)
	BEGIN
		EXEC @RetVal = bgtCheckERForReforcastKeys @IdAssociate = @IdAssociate, @AssociateCurrency = @AssociateCurrency, @AssociateCurrencyCode = @AssociateCurrencyCode
		IF (@@ERROR <> 0 OR @RetVal < 0)
			RETURN -3
	END

	--Set the flag for IsNewActual to 0 if there are no actual data for the previous month 
	UPDATE	BTD
	SET	BTD.IsNewActual = 0
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	WHERE	BTD.YearMonth = dbo.fnGetYearMonthOfPreviousMonth(getdate()) AND
		--dbo.fnGetActualHoursVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth) IS NULL
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
	SET 	BTD.New = CASE WHEN @IsAssociateCurrency = 1  or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
			*
			CASE WHEN (@Version = 'P' OR @Version = 'C')
			THEN 
				BCD.HoursVal
			ELSE 
				dbo.fnGetValuedHours(BTD.IdCostCenter, BCD.HoursQty, BTD.YearMonth)
			END
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionNewGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsNewActual = 0

	--Add new values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.New = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
						* ISNULL(dbo.fnGetActualHoursVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth),0)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsNewActual = 1

	--Add released values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				* BCD.HoursVal
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionCurrentGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE 	BTD.IsCurrentActual = 0

	--Add current values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.[Current] = CASE WHEN @IsAssociateCurrency = 1  or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				* ISNULL(dbo.fnGetActualHoursVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth),0)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsCurrentActual = 1

	--Add previous values from To Completion (for entries that are not from actual)
	UPDATE 	BTD
	SET 	BTD.[Previous] = CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0  THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				* BCD.HoursVal
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_TOCOMPLETION_DETAIL BCD ON 
		BCD.IdProject = BTD.IdProject AND
		BCD.IdGeneration = @ToCompletionPreviousGenerationNo AND
		BCD.IdPhase = BTD.IdPhase AND
		BCD.IdWorkPackage = BTD.IdWP AND
		BCD.IdCostCenter = BTD.IdCostCenter AND
		BCD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BCD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	IsPreviousActual = 0

	--Add previous values from Actual (for entries that are from actual)
	UPDATE 	BTD
	SET 	BTD.Previous = CASE WHEN @IsAssociateCurrency = 1  or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END
				* ISNULL(dbo.fnGetActualHoursVal(BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth),0)
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency
	WHERE	BTD.IsPreviousActual = 1

	--Add revised values
	UPDATE 	BTD
	SET 	BTD.Revised = CASE WHEN @IsAssociateCurrency = 1  or @IdCurrencyDisplay > 0 THEN dbo.fnGetExchangeRate(CURR.[Id], @AssociateCurrency, BTD.YearMonth) ELSE 1 END 
				* BRD.HoursVal
	FROM 	#BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	INNER	JOIN BUDGET_REVISED_DETAIL BRD ON 
		BRD.IdProject = BTD.IdProject AND
		BRD.IdGeneration = @RevisedGenerationNo AND
		BRD.IdPhase = BTD.IdPhase AND
		BRD.IdWorkPackage = BTD.IdWP AND
		BRD.IdCostCenter = BTD.IdCostCenter AND
		BRD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END AND
		BRD.YearMonth = BTD.YearMonth
	INNER JOIN COST_CENTERS CC ON
		CC.Id = BTD.IdCostCenter
	INNER JOIN INERGY_LOCATIONS IL ON
		IL.Id = CC.IdInergyLocation
	INNER JOIN COUNTRIES C ON
		C.Id = IL.IdCountry
	INNER JOIN CURRENCIES CURR ON
		CURR.Id = C.IdCurrency


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
		SET 	NewCurrentDiff = CASE WHEN New IS NULL AND [Current] IS NULL THEN NULL ELSE ISNULL(ROUND(New, 0), 0) - ISNULL(ROUND([Current], 0), 0) END
	END

	IF (@ToCompletionNewGenerationNo IS NOT NULL)--revised will always have a current version no need to test
	BEGIN
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	NewRevisedDiff = CASE WHEN New IS NULL AND Revised IS NULL THEN NULL ELSE ISNULL(ROUND(New, 0), 0) - ISNULL(ROUND(Revised, 0), 0) END
	END

	IF (@ToCompletionPreviousGenerationNo IS NOT NULL and @ToCompletionCurrentGenerationNo is NOT NULL)	
	BEGIN	
		UPDATE 	#BUDGET_TOCOMPLETION_DETAIL_TEMP
		SET 	CurrentPreviousDiff = CASE WHEN [Current] IS NULL AND Previous IS NULL THEN NULL ELSE ISNULL(ROUND([Current], 0), 0) - ISNULL(ROUND(Previous, 0), 0) END
	END


	CREATE TABLE #CC_TABLE
	(
		IdProject		INT,
		IdPhase			INT,
		IdWP			INT,
		IdCostCenter		INT,
		CostCenterName		VARCHAR(50),
		Previous		DECIMAL(20, 6),
		CurrentPreviousDiff	DECIMAL(20, 6),
		[Current]		DECIMAL(20, 6),
		NewCurrentDiff		DECIMAL(20, 6),
		New			DECIMAL(20, 6),
		NewRevisedDiff		DECIMAL(20, 6),
		Revised			DECIMAL(20, 6),
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
			SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
			SUM(ROUND(BTD.CurrentPreviousDiff, 0)) 	AS	'CurrentPreviousDiff',
			SUM(ROUND(BTD.[Current], 0))		AS 	'Current',
			SUM(ROUND(BTD.NewCurrentDiff, 0))	AS	'NewCurrentDiff',
			SUM(ROUND(BTD.New, 0))			AS	'New',
			SUM(ROUND(BTD.NewRevisedDiff, 0))	AS	'NewRevisedDiff',
			SUM(ROUND(BTD.Revised, 0))		AS 	'Revised',
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
			SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
			SUM(ROUND(BTD.CurrentPreviousDiff, 0)) 	AS	'CurrentPreviousDiff',
			SUM(ROUND(BTD.[Current], 0))		AS 	'Current',
			SUM(ROUND(BTD.NewCurrentDiff, 0))	AS	'NewCurrentDiff',
			SUM(ROUND(BTD.New, 0))			AS	'New',
			SUM(ROUND(BTD.NewRevisedDiff, 0))	AS	'NewRevisedDiff',
			SUM(ROUND(BTD.Revised, 0))		AS 	'Revised',
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



	--Select the first table
	SELECT 	BPT.IdProject 			AS	'IdProject',
		BPT.IdPhase			AS	'IdPhase',
		BPT.IdWP			AS	'IdWP',
		WP.Code				AS	'PhaseWPCode',
		WP.Code + ' - ' + WP.Name	AS	'PhaseWPName',
		CASE WHEN @IdAssociate = -1 THEN dbo.fnGetWeightedAveragePercent(BPT.IdProject, @ToCompletionNewGenerationNo, BPT.IdPhase, BPT.IdWP, @IdAssociate) 
		     ELSE MAX(BCP.[Percent]) END AS 	'Progress',
		WP.StartYearMonth		AS	'StartYearMonth',
		WP.EndYearMonth			AS	'EndYearMonth',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.Previous, 0), 0)) ELSE NULL END		AS	'Previous',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.CurrentPreviousDiff, 0), 0)) ELSE NULL END 	AS	'CurrentPreviousDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.[Current], 0), 0)) ELSE NULL END		AS 	'Current',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.NewCurrentDiff, 0), 0)) ELSE NULL END	AS	'NewCurrentDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.New, 0), 0)) ELSE NULL END			AS	'New',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.NewRevisedDiff, 0), 0)) ELSE NULL END	AS	'NewRevisedDiff',
		CASE WHEN @IsAssociateCurrency = 1 or @IdCurrencyDisplay > 0 THEN SUM(ROUND(ISNULL(CC.Revised, 0), 0)) ELSE NULL END		AS 	'Revised',
		WP.IsActive			AS 	'IsActive'
	FROM 	#BUDGET_PRESELECTION_TEMP BPT
	LEFT JOIN BUDGET_TOCOMPLETION_PROGRESS BCP ON 
		BCP.IdProject = BPT.IdProject AND
		BCP.IdGeneration = @ToCompletionNewGenerationNo AND
		BCP.IdPhase = BPT.IdPhase AND
		BCP.IdWorkPackage = BPT.IdWP AND
		BCP.IdAssociate = @IdAssociate
	LEFT JOIN #CC_TABLE CC ON
		CC.IdProject = BPT.IdProject AND
		CC.IdPhase = BPT.IdPhase AND
		CC.IdWP = BPT.IdWP
	INNER JOIN WORK_PACKAGES AS WP ON
		WP.IdProject = BPT.IdProject AND
		WP.IdPhase = BPT.IdPhase AND
		WP.[Id] = BPT.IdWP
	INNER JOIN PROJECT_PHASES PH ON
		PH.Id = WP.IdPhase
	GROUP BY BPT.IdProject, BPT.IdPhase, BPT.IdWP, BCP.[Percent], WP.StartYearMonth, WP.EndYearMonth, WP.IsActive, PH.Code, WP.Code, WP.Name
	ORDER BY PH.Code


	--Select the second table
	SELECT IdProject, IdPhase, IdWP, IdCostCenter, CostCenterName, Previous, CurrentPreviousDiff, [Current],
		NewCurrentDiff, New, NewRevisedDiff, Revised, IdCurrency, CurrencyCode
	FROM #CC_TABLE


	--Select the third table
	SELECT	BTD.IdProject				AS	'IdProject',
		BTD.IdPhase				AS	'IdPhase',
		BTD.IdWP				AS	'IdWP',
		BTD.IdCostCenter			AS	'IdCostCenter',
		BTD.YearMonth				AS	'YearMonth',
		SUM(ROUND(BTD.Previous, 0))		AS	'Previous',
		BTD.IsPreviousActual			AS	'IsPreviousActual',
		SUM(ROUND(BTD.CurrentPreviousDiff, 0))	AS	'CurrentPreviousDiff',
		SUM(ROUND(BTD.[Current], 0))		AS	'Current',
		BTD.IsCurrentActual			AS	'IsCurrentActual',
		SUM(ROUND(BTD.NewCurrentDiff, 0))	AS	'NewCurrentDiff',
		SUM(ROUND(BTD.New, 0))			AS	'New',
		BTD.IsNewActual				AS	'IsNewActual',
		SUM(ROUND(BTD.NewRevisedDiff, 0))	AS	'NewRevisedDiff',
		SUM(ROUND(BTD.Revised, 0))		AS	'Revised'
	FROM #BUDGET_TOCOMPLETION_DETAIL_TEMP BTD
	GROUP BY BTD.IdProject, BTD.IdPhase, BTD.IdWP, BTD.IdCostCenter, BTD.YearMonth, BTD.IsPreviousActual, BTD.IsCurrentActual, BTD.IsNewActual
	ORDER BY BTD.YearMonth

GO

--Drops the Procedure bgtMoveRevisedBudgetReleasedVersion if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtMoveRevisedBudgetReleasedVersion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtMoveRevisedBudgetReleasedVersion
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[bgtMoveRevisedBudgetReleasedVersion]
	@IdProject			INT,
	@IdAssociateLM			INT, -- LM: member that leaves the project
	@IdAssociateNM			INT,  -- NM: new member, that takes over the budget from LM
	@IdAssociateMovingBudget		INT,  -- the member that moves the budget from LM (leaving member) to NM (new member)
	@ExecuteMoveReforecastBudget int = 1 -- if = 1 Reforecast budget will be moved too
AS


DECLARE @IdGeneration int

SELECT @IdGeneration = MAX(IdGeneration) 
FROM BUDGET_REVISED TABLOCKX
WHERE 	IdProject = @IdProject AND IsValidated = 1

if(
	(SELECT count(*)
	 FROM BUDGET_REVISED_DETAIL
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociateLM)
	
	+
	(SELECT count(*)
	 FROM BUDGET_REVISED_DETAIL_COSTS
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociateLM) = 0)
BEGIN	
	RAISERROR('There is no data to transfer', 16, 1)
	RETURN -2
END

-- delete any existing revised data for this generation

	delete BUDGET_REVISED_DETAIL_COSTS
	where IdProject = @IdProject
	and IdGeneration = @IdGeneration
	and IdAssociate = @IdAssociateNM


	delete BUDGET_REVISED_DETAIL
	where IdProject = @IdProject
	and IdGeneration = @IdGeneration
	and IdAssociate = @IdAssociateNM


-- insert data for the new member
INSERT INTO BUDGET_REVISED_DETAIL
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales)
SELECT IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, @IdAssociateNM, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales
FROM BUDGET_REVISED_DETAIL
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM

INSERT INTO BUDGET_REVISED_DETAIL_COSTS
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount)
SELECT IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, @IdAssociateNM, YearMonth, IdCostType, CostVal, IdCountry, IdAccount
FROM BUDGET_REVISED_DETAIL_COSTS
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM
  
-- insert data into the logs table
INSERT INTO BUDGET_REVISED_MOVE_OPERATIONS
	VALUES(@IdProject, @IdGeneration, GETDATE(), @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget)

	-- set to 0 old member data
update BUDGET_REVISED_DETAIL_COSTS
set CostVal = 0
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM

update BUDGET_REVISED_DETAIL
set HoursQty = 0, HoursVal = 0, SalesVal = 0
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM

  
update BUDGET_REVISED_STATES
set [State] = 'N'
WHERE IdProject = @IdProject 
  AND IdGeneration = @IdGeneration 
  AND IdAssociate = @IdAssociateLM  



if exists(select * from BUDGET_REVISED_STATES
						WHERE IdProject = @IdProject 
						AND IdGeneration = @IdGeneration 
						AND IdAssociate = @IdAssociateNM)
   
   update BUDGET_REVISED_STATES
	set [State] = 'V'
	WHERE IdProject = @IdProject 
	AND IdGeneration = @IdGeneration 
	AND IdAssociate = @IdAssociateNM
else
	insert into  BUDGET_REVISED_STATES
	(IdProject, IdGeneration, IdAssociate, [State], StateDate)
	select @IdProject, @IdGeneration, @IdAssociateNM, 'V', getdate()

if @ExecuteMoveReforecastBudget = 1 
   begin
		declare @ReforecastIsReleasedTable table (ReforecastReleased int)

		insert into @ReforecastIsReleasedTable
		exec [bgtGetLastValidatedReforecastVersion] @IdProject

		if (select ReforecastReleased from @ReforecastIsReleasedTable)  > 0
		  begin
			-- Reforecast has Released version
			exec [bgtMoveToCompletionBudgetReleasedVersion] @IdProject, @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget, 0
		  end
		else
		   begin
			 declare @IdVersionProgress int
			-- check if status is in Progress
				select @IdVersionProgress = dbo.fnGetToCompletionBudgetGeneration(@IdProject,'N')
				if @IdVersionProgress is not null
				  -- it exists an InProgressVersion, we call "normal" move budget
				    begin
						exec bgtMoveToCompletionBudget @IdProject, @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget
					end
		   end

   end

go
--Drops the Procedure bgtMoveToCompletionBudgetReleasedVersion if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtMoveToCompletionBudgetReleasedVersion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtMoveToCompletionBudgetReleasedVersion
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[bgtMoveToCompletionBudgetReleasedVersion]
	@IdProject		INT,
	@IdAssociateLM		INT, -- LM: member that leaves the project
	@IdAssociateNM		INT,  -- NM: new member, that takes over the budget from LM
	@IdAssociateMovingBudget		INT,  -- the member that moves the budget from LM (leaving member) to NM (new member)
	@ExecuteMoveRevisedBudget int = 1 -- if =1, RevisedBudget is moved too
AS

DECLARE @IdGeneration int

SELECT @IdGeneration = MAX(IdGeneration) 
FROM BUDGET_TOCOMPLETION TABLOCKX
WHERE 	IdProject = @IdProject AND IsValidated = 1


if(
	(SELECT count(*)
	 FROM BUDGET_TOCOMPLETION_DETAIL
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociateLM)
	
	+
	(SELECT count(*)
	 FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociateLM) = 0)
BEGIN	
	RAISERROR('There is no data to transfer', 16, 1)
	RETURN -2
END

-- delete any existing reforecast data for this generation
	delete BUDGET_TOCOMPLETION_DETAIL_COSTS
	where IdProject = @IdProject
	and IdGeneration = @IdGeneration
	and IdAssociate = @IdAssociateNM


	delete BUDGET_TOCOMPLETION_DETAIL
	where IdProject = @IdProject
	and IdGeneration = @IdGeneration
	and IdAssociate = @IdAssociateNM

	delete BUDGET_TOCOMPLETION_PROGRESS
	WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociateNM

-- insert data for the new member

INSERT INTO BUDGET_TOCOMPLETION_PROGRESS 
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdAssociate, [Percent])
SELECT IdProject, IdGeneration, IdPhase, IdWorkPackage, @IdAssociateNM, [Percent]
FROM BUDGET_TOCOMPLETION_PROGRESS
WHERE IdProject = @IdProject
	AND IdGeneration = @IdGeneration
	AND IdAssociate = @IdAssociateLM

update BUDGET_TOCOMPLETION_PROGRESS
set [Percent] = 0
WHERE IdProject = @IdProject
	AND IdGeneration = @IdGeneration
	AND IdAssociate = @IdAssociateLM  

INSERT INTO BUDGET_TOCOMPLETION_DETAIL
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales)
SELECT IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, @IdAssociateNM, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales
FROM BUDGET_TOCOMPLETION_DETAIL
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM


INSERT INTO BUDGET_TOCOMPLETION_DETAIL_COSTS
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount)
SELECT IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, @IdAssociateNM, YearMonth, IdCostType, CostVal, IdCountry, IdAccount
FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM

-- set 0 to the values for the old member
update BUDGET_TOCOMPLETION_DETAIL
set HoursQty = 0, HoursVal = 0, SalesVal = 0
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM


update BUDGET_TOCOMPLETION_DETAIL_COSTS
set CostVal = 0
FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
WHERE IdProject = @IdProject
  AND IdGeneration = @IdGeneration
  AND IdAssociate = @IdAssociateLM


--insert data into the logs table
INSERT INTO BUDGET_TOCOMPLETION_MOVE_OPERATIONS
VALUES(@IdProject, @IdGeneration, GETDATE(), @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget)

declare @State_AssociateLM varchar(1)

select @State_AssociateLM = [State] from BUDGET_TOCOMPLETION_STATES
	WHERE IdProject = @IdProject 
		AND IdGeneration = @IdGeneration 
		AND IdAssociate = @IdAssociateLM 

select @State_AssociateLM = isnull(@State_AssociateLM,'N')

update BUDGET_TOCOMPLETION_STATES
set [State] = 'N'
WHERE IdProject = @IdProject 
  AND IdGeneration = @IdGeneration 
  AND IdAssociate = @IdAssociateLM	


if exists(select * from BUDGET_TOCOMPLETION_STATES
						WHERE IdProject = @IdProject 
						AND IdGeneration = @IdGeneration 
						AND IdAssociate = @IdAssociateNM)
   
   update BUDGET_TOCOMPLETION_STATES
	set [State] = 'V'
	WHERE IdProject = @IdProject 
	AND IdGeneration = @IdGeneration 
	AND IdAssociate = @IdAssociateNM
else
	insert into  BUDGET_TOCOMPLETION_STATES
	(IdProject, IdGeneration, IdAssociate, [State], StateDate)
	select @IdProject, @IdGeneration, @IdAssociateNM, @State_AssociateLM, getdate()


if @ExecuteMoveRevisedBudget = 1 
   begin
		declare @RevisedIsReleasedTable table (RevisedIsReleased int)

		insert into @RevisedIsReleasedTable
		exec [bgtGetLastValidatedRevisedVersion]  @IdProject

		if (select RevisedIsReleased from  @RevisedIsReleasedTable) > 0
		  begin
			-- Revised has Released version
			exec [bgtMoveRevisedBudgetReleasedVersion] @IdProject, @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget, 0
		  end
		else
		   begin
			 declare @IdVersionProgress int
			-- check if status is in Progress
				select @IdVersionProgress = dbo.fnGetRevisedBudgetGeneration(@IdProject,'N')
				if @IdVersionProgress is not null
				  -- it exists an InProgressVersion, we call "normal" move budget
				    begin
						exec bgtMoveRevisedBudget @IdProject, @IdAssociateLM, @IdAssociateNM, @IdAssociateMovingBudget
					end
		   end
   end

GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnGetExchangeRate]'))
	DROP FUNCTION fnGetExchangeRate
GO

CREATE FUNCTION fnGetExchangeRate
	(@CurrencyFrom	AS INT,	--The CurrencyFrom of the selected Exchange Rate
	@CurrencyTo	AS INT, --The CurrencyTo of the selected Exchange Rate
	@YearMonth	AS INT)	--The Year and Month of the selected Exchange Rate
RETURNS DECIMAL(18,6)
AS
BEGIN



DECLARE @IdCategoryFrom	 	AS INT,
	@IdCategoryTo	 	AS INT,
	@ExchangeRateFrom 	AS DECIMAL(18,6),
	@ExchangeRateTo	 	AS DECIMAL(18,6),
	@ConversionRate  	AS DECIMAL(18,6),
	@YearMonthFrom		AS INT,
	@YearMonthTo		AS INT
	--This procedure returns the exchange rate for the selected Currency and YearMonth as follows: 
	--If @YearMonth is a positive integer then it will return for it, if it is -1 then the last exchange rate filled in the application for 
	--the selected Currency will be used
	--If Exchange Rate Category 'Actual' is <> 0, then this is used
	--If Exchange Rate Category 'Budget' is <> 0, then this is used
	--If 'Business Plan' is <> 0, then this is used
	--If all above are 0, then an exception is thrown
	
	if (@CurrencyFrom is NULL OR @CurrencyTo is NULL OR @YearMonth is NULL)
		return NULL
	
	IF (@CurrencyFrom = @CurrencyTo)
		RETURN 1
	
	IF (@CurrencyFrom <> dbo.fnGetEuroId())
	BEGIN
		SELECT 	@YearMonthFrom = MAX(ER.YearMonth)
		FROM 	EXCHANGE_RATES ER(nolock)
		WHERE 	ER.IdCurrencyTo = @CurrencyFrom AND
			ER.YearMonth <= @YearMonth

		IF (@YearMonthFrom IS NULL)
			RETURN NULL
		
		SELECT 	@IdCategoryFrom = MIN(ER.IdCategory)
		FROM 	EXCHANGE_RATES ER(nolock)
		WHERE 	ER.IdCurrencyTo = @CurrencyFrom AND
			ER.YearMonth = @YearMonthFrom

		SELECT 	@ExchangeRateFrom = ER.ConversionRate
		FROM 	EXCHANGE_RATES ER(nolock)
		WHERE 	ER.IdCategory = @IdCategoryFrom AND
			ER.IdCurrencyTo = @CurrencyFrom AND
			ER.YearMonth = @YearMonthFrom 
			
		if isnull(@ExchangeRateFrom,0) = 0
			return null

	END
	ELSE
	BEGIN
		SET @ExchangeRateFrom = 1
	END

	IF (@CurrencyTo <> dbo.fnGetEuroId())
	BEGIN
		SELECT 	@YearMonthTo = MAX(ER.YearMonth)
		FROM 	EXCHANGE_RATES ER(nolock)
		WHERE 	ER.IdCurrencyTo = @CurrencyTo AND
			ER.YearMonth <= @YearMonth

		IF (@YearMonthTo IS NULL)
			RETURN NULL
		
		SELECT 	@IdCategoryTo = MIN(ER.IdCategory)
		FROM 	EXCHANGE_RATES ER(nolock)
		WHERE 	ER.IdCurrencyTo = @CurrencyTo AND
			ER.YearMonth = @YearMonthTo

		SELECT 	@ExchangeRateTo = ER.ConversionRate
		FROM 	EXCHANGE_RATES ER(nolock)
		WHERE 	ER.IdCategory = @IdCategoryTo AND
			ER.IdCurrencyTo = @CurrencyTo AND
			ER.YearMonth = @YearMonthTo
			
		if @ExchangeRateTo is null
			return null

	END
	ELSE
	BEGIN
		SET @ExchangeRateTo = 1
	END

		
	SET @ConversionRate = @ExchangeRateTo / @ExchangeRateFrom
	RETURN @ConversionRate
END
GO

