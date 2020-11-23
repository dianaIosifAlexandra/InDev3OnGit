--Drops the Procedure bgtSelectExchangeRateForConverter if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtSelectExchangeRateForConverter]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtSelectExchangeRateForConverter
GO
CREATE PROCEDURE bgtSelectExchangeRateForConverter
	@CurrencyFrom	AS INT,	--The CurrencyFrom of the selected Exchange Rate
	@CurrencyTo	AS INT, --The CurrencyTo of the selected Exchange Rate
	@YearMonth	AS INT	--The Year and Month of the selected Exchange Rate
AS
	DECLARE @ConversionRate  	AS DECIMAL(10,4),
		@CurrencyFromName	VARCHAR(30),
		@CurrencyToName 	VARCHAR(30),
		@ErrorMessage		VARCHAR(255),
		@YMValidationResult	INT

	--we validate the YearMonth
	if (@YearMonth <> -1)
	BEGIN

		-- verify if the yearmonth value is valid
		Select @YMValidationResult = ValidationResult,
		       @ErrorMessage = ErrorMessage
		from fnValidateYearMonth(@YearMonth)
	
		if (@YMValidationResult < 0)
		begin
		 	RAISERROR(@ErrorMessage, 16, 1)
			RETURN -1
		end
	END

	--we validate the from and to currencies
	SELECT 	@CurrencyFromName = [Name]
	FROM 	CURRENCIES
	WHERE 	[Id] = @CurrencyFrom

	IF (@CurrencyFromName is NULL)
	BEGIN
		RAISERROR('CurrencyFrom (Id=%d) was not found in the CURRENCIES catalogue. Exchange rate cannot be calculated.', 16, 1, @CurrencyFrom)
		RETURN -2
	END


	SELECT 	@CurrencyToName = [Name]
	FROM 	CURRENCIES
	WHERE 	[Id] = @CurrencyTo

	IF (@CurrencyToName is NULL)
	BEGIN
		RAISERROR('CurrencyTo (Id=%d) was not found in the CURRENCIES catalogue. Exchange rate cannot be calculated.', 16, 1, @CurrencyTo)
		RETURN -3
	END



	--we see what is the exchange rate
	SELECT @ConversionRate = dbo.fnGetExchangeRate(@CurrencyFrom, @CurrencyTo, @YearMonth)
	IF (@ConversionRate IS NULL)
	BEGIN	
		RAISERROR('No exchange rate found for %s to %s conversion for YearMonth %d', 16, 1, @CurrencyFromName, @CurrencyToName, @YearMonth )
		RETURN -4
	END

	SELECT @ConversionRate AS 'ExchangeRate'
GO

