--Drops the Procedure catDeleteExchangeRate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteExchangeRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteExchangeRate
GO
CREATE PROCEDURE catDeleteExchangeRate
	@IdCategory	AS INT, 	--The IdCategory of the selected Exchange Rate
	@YearMonth	AS INT,		--The Year and Month of the selected Exchange Rate
	@IdCurrencyTo	AS INT		--The IdCurrencyTo of the selected Exchange Rate
AS
DECLARE @Rowcount INT

	DELETE FROM EXCHANGE_RATES
	WHERE 	IdCategory = @IdCategory AND
		YearMonth = @YearMonth AND 
		IdCurrencyTo = @IdCurrencyTo

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

