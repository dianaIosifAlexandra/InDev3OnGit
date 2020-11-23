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


