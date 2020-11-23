--Drops the Procedure catSelectExchangeRate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectExchangeRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectExchangeRate
GO
CREATE PROCEDURE catSelectExchangeRate
	@Id AS INT 	--The Id of the selected Exchange Rate
AS
	--If @Id has the value -1, it will return all Exchange Rates
	IF (@Id = -1)
	BEGIN 
		SELECT 	
			ER.[Year]				AS 'Year',
			ER.[Month]				AS 'Month',
			CAST(ER.ConversionRate AS DECIMAL(9,2))	AS 'ConversionRate',
			C.[Name]				AS 'Currency',
			CAT.[Name]				AS 'Category',
			ER.[Id]					AS 'Id',
			ER.IdCurrencyTo				AS 'IdCurrencyTo'
		FROM EXCHANGE_RATES ER(nolock)
		INNER JOIN CURRENCIES C(nolock)
			ON ER.IdCurrencyTo = C.[Id]	
		INNER JOIN CATEGORIES CAT(nolock)
			ON ER.IdCategory = CAT.[Id]

		RETURN
	END

	--If @Id doesn't have the value -1 it will return the selected Exchange Rates
	SELECT 	ER.[Id]					AS 'Id',
		ER.[Year]				AS 'Year',
		ER.[Month]				AS 'Month',
		ER.IdCurrencyTo				AS 'IdCurrencyTo',
		CAST(ER.ConversionRate AS DECIMAL(9,2))	AS 'ConversionRate',
		C.[Name]				AS 'Currency',
		CAT.[Name]				AS 'Category'
	FROM EXCHANGE_RATES ER(nolock)
	INNER JOIN CURRENCIES C(nolock)
		ON ER.IdCurrencyTo = C.[Id]	
	INNER JOIN CATEGORIES CAT(nolock)
		ON ER.IdCategory = CAT.[Id]
	WHERE ER.[Id] = @Id
GO

