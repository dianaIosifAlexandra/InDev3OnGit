--Drops the Procedure catInsertExchangeRate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertExchangeRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertExchangeRate
GO
CREATE PROCEDURE catInsertExchangeRate
 	@IdCurrencyTo	INT,		--The Id of the currency that is connected to the Exchange Rate you want to insert
	@YearMonth	INT,		--The Year and Month of the Exchange Rate you want to Insert
	@ConversionRate	DECIMAL(8,4),	--The Conversion Rate of the Exchange Rate you want to Insert,
	@IdCategory	INT		--The Category related to the Exchange rate you want to Insert
AS

--validation yearmonth section
Declare	@ErrorMessage		VARCHAR(255),
	@YMValidationResult	INT

	-- verify if the yearmonth value is valid
	Select @YMValidationResult = ValidationResult,
	       @ErrorMessage = ErrorMessage
	from fnValidateYearMonth(@YearMonth)

	if (@YMValidationResult < 0)
	begin
	 	RAISERROR(@ErrorMessage, 16, 1)
		RETURN -1
	end
--end validation section

	INSERT INTO EXCHANGE_RATES (IdCurrencyTo,[YearMonth],ConversionRate,IdCategory)
	VALUES		   	   (@IdCurrencyTo,@YearMonth,@ConversionRate,@IdCategory)
	
	--there is no unique id to return
	RETURN 1
GO

