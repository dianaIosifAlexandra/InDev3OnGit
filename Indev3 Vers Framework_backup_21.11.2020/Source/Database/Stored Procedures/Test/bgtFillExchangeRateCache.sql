
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

