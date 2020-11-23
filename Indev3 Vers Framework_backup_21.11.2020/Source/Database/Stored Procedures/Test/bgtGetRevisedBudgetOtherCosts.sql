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

