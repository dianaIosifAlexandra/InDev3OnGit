--Drops the Procedure bgtCheckERForReforcastKeys if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtCheckERForReforcastKeys]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtCheckERForReforcastKeys
GO

CREATE  PROCEDURE bgtCheckERForReforcastKeys
	@IdAssociate INT,
	@AssociateCurrency INT,
	@AssociateCurrencyCode VARCHAR(10)
	
AS



DECLARE @WpName VARCHAR(30)
DECLARE @StartYM INT
DECLARE @EndYM	INT
DECLARE @YearMonth INT
DECLARE @CurrencyCode VARCHAR(10)


SELECT TOP 1 	@WpName = WP.Code + ' - ' + WP.Name,
	    	@StartYM = WP.StartYearMonth,
	    	@EndYM = WP.EndYearMonth,
	    	@YearMonth = BDT.YearMonth,
	   	@CurrencyCode = CURR.Code
FROM #BUDGET_TOCOMPLETION_DETAIL_TEMP BDT
INNER JOIN WORK_PACKAGES WP
	ON WP.IdProject = BDT.IdProject AND
	   WP.IdPhase = BDT.IdPhase AND
	   WP.Id = BDT.IdWP	
INNER JOIN COST_CENTERS AS CC
	ON CC.[Id] = BDT.IdCostCenter
INNER JOIN INERGY_LOCATIONS AS IL
	ON IL.[Id] = CC.IdInergyLocation
INNER JOIN COUNTRIES
	ON COUNTRIES.[Id] = IL.IdCountry
INNER JOIN CURRENCIES CURR 
	ON CURR.[Id] = COUNTRIES.IdCurrency
WHERE  dbo.fnGetExchangeRate(@AssociateCurrency, CURR.Id, BDT.YearMonth) IS NULL 



IF @WPName IS NOT NULL
BEGIN
	DECLARE @YM VARCHAR(7)
	DECLARE @SYM VARCHAR(7)
	DECLARE @EYM VARCHAR(7)
	SELECT @YM = dbo.fnGetYMStringRepresentation(@YearMonth)
	SELECT @SYM = dbo.fnGetYMStringRepresentation(@StartYM)
	SELECT @EYM = dbo.fnGetYMStringRepresentation(@EndYM)
	
	RAISERROR('No exchange rate found for %s to %s conversion for YearMonth %s (Work Package %s, period %s - %s).',
		16,1, @AssociateCurrencyCode,@CurrencyCode,@YM, @WpName, @SYM, @EYM )
END



GO



