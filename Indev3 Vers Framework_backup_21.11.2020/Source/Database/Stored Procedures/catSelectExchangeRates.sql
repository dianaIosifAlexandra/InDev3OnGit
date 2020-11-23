--Drops the Procedure catSelectExchangeRates if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectExchangeRates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectExchangeRates
GO
CREATE PROCEDURE catSelectExchangeRates
	@Year AS INT
AS

		CREATE TABLE #TempExchangeRates
	(
		IdCurrency int,
		Currency varchar(3),
		BudgetExchangeRate decimal(9,4),
		January decimal(9,4),
		February decimal(9,4),
		March decimal(9,4),
		April decimal(9,4),
		May decimal(9,4),
		June decimal(9,4),
		July decimal(9,4),
		August decimal(9,4),
		September decimal(9,4),
		October decimal(9,4),
		November decimal(9,4),
		December decimal(9,4)
	)

	INSERT INTO #TempExchangeRates
	SELECT
		C.Id as IdCurrency,
		C.Code AS Currency,	
		0 as 'BudgetExchangeRate',			  	  
		0 AS  'January',
		0 AS  'February',
		0 AS  'March',
		0 AS  'April',
		0 AS  'May',
		0 AS  'June',
		0 AS  'July',
		0 AS  'August',
		0 AS  'September',
		0 AS  'October',
		0 AS  'November',
		0 AS  'December'
	FROM CURRENCIES C

	UPDATE T
	SET T.BudgetExchangeRate = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 2 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 1

	UPDATE T
	SET T.January = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 1

	UPDATE T
	SET T.February = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 2

	UPDATE T
	SET T.March = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 3

	UPDATE T
	SET T.April = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 4

	UPDATE T
	SET T.May = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 5

	UPDATE T
	SET T.June = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 6

	UPDATE T
	SET T.July = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 7

	UPDATE T
	SET T.August = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 8

	UPDATE T
	SET T.September = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 9

	UPDATE T
	SET T.October = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 10

	UPDATE T
	SET T.November = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 11

	UPDATE T
	SET T.December = ER.ConversionRate
	FROM #TempExchangeRates T
	INNER JOIN EXCHANGE_RATES ER ON ER.IdCurrencyTo = T.IdCurrency
	WHERE 	ER.IdCategory = 1 AND
		ER.YearMonth / 100 = @Year AND
		ER.YearMonth % 100 = 12			
	
	SELECT IdCurrency,
		   Currency,
		   BudgetExchangeRate,
		   January,
		   February,
		   March,
		   April,
		   May,
		   June,
		   July,
		   August,
		   September,
		   October,
		   November,
		   December
	FROM #TempExchangeRates
	ORDER BY Currency

GO

