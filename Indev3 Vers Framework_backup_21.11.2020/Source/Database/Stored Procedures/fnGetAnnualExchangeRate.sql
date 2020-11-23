IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetAnnualExchangeRate]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetAnnualExchangeRate]
GO

CREATE FUNCTION [dbo].[fnGetAnnualExchangeRate]
	(@CurrencyFrom	AS INT,	--The CurrencyFrom of the selected Exchange Rate
	@CurrencyTo	AS INT, --The CurrencyTo of the selected Exchange Rate
	@YearMonth	AS INT)	--The YearMonthTo of the selected Exchange Rate
RETURNS DECIMAL(18,6)
AS
BEGIN



DECLARE @IdCategoryFrom	 	AS INT,
	@IdCategoryTo	 	AS INT,
	@ExchangeRateFrom 	AS DECIMAL(18,6),
	@ExchangeRateTo	 	AS DECIMAL(18,6),
	@ConversionRate  	AS DECIMAL(18,6),
	@YearMonthFrom		AS INT,
	@YearMonthTo		AS INT,
	@Message			as varchar(200)
	
	
	--Category is 2, for Annual Budget, and month is January (by default)
	set @IdCategoryFrom = 2
	set @IdCategoryTo = 2
	set @YearMonthFrom = @YearMonth 
	set @YearMonthTo = @YearMonth 
	
	
	--This procedure returns the exchange rate for the selected Currency and YearMonth as follows: 
	--If @YearMonth is a positive integer then it will return for it, if it is -1 then the last exchange rate filled in the application for 
	--the selected Currency will be used
	--If 'Business Plan' is <> 0, then this is used
	--If all above are 0, then an exception is thrown
	
	if (@CurrencyFrom is NULL OR @CurrencyTo is NULL OR @YearMonth is NULL)
		return NULL
	
	IF (@CurrencyFrom = @CurrencyTo)
		RETURN 1
	
	IF (@CurrencyFrom <> dbo.fnGetEuroId())
	BEGIN

		SELECT 	@ExchangeRateFrom = ER.ConversionRate
		FROM 	EXCHANGE_RATES ER(nolock)
		WHERE 	ER.IdCategory = @IdCategoryFrom AND
			ER.IdCurrencyTo = @CurrencyFrom AND
			ER.YearMonth = @YearMonthFrom 
		
	END
	ELSE
	BEGIN
		SET @ExchangeRateFrom = 1
	END

	IF (@CurrencyTo <> dbo.fnGetEuroId())
	BEGIN

		SELECT 	@ExchangeRateTo = ER.ConversionRate
		FROM 	EXCHANGE_RATES ER(nolock)
		WHERE 	ER.IdCategory = @IdCategoryTo AND
			ER.IdCurrencyTo = @CurrencyTo AND
			ER.YearMonth = @YearMonthTo

	END
	ELSE
	BEGIN
		SET @ExchangeRateTo = 1
	END

	
	SET @ConversionRate = @ExchangeRateTo / @ExchangeRateFrom

	IF @ConversionRate IS NULL
		SET	@ConversionRate = (SELECT dbo.fnGetExchangeRate(@CurrencyFrom,@CurrencyTo,@YearMonth))
	
	RETURN @ConversionRate
END

GO

