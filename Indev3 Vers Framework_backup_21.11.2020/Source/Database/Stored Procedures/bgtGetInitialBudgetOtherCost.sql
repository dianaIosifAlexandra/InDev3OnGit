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

