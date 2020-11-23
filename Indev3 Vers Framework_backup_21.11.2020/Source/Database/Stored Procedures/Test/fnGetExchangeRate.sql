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

