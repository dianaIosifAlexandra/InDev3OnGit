--Drops the Procedure catInsertOrUpdateExchangeRate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertOrUpdateExchangeRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertOrUpdateExchangeRate
GO
CREATE PROCEDURE catInsertOrUpdateExchangeRate
	@IdCategory			INT,		--The Category that is connected to the Exchange rate that is to be updated 
 	@CurrencyFrom			VARCHAR(3),	--The Id of the currency that is connected to the Exchange Rate you want to Update
	@Year				INT,		--The Year of the Exchange Rate you want to Update
	@Month				INT,		--The Month of the Exchange Rate you want to Update
	@NewExchangeRate		DECIMAL(9,4)	--The Value of the Exchange Rate you want to Update
	
AS
DECLARE @IdUpdate		INT,
	@IdCurrencyTo		INT,
	@YearMonth		INT,
	@ExchangeRateExists	BIT,
	@ErrorMessage		VARCHAR(255),
	@Rowcount		INT,
	@YMValidationResult	INT,
	@IndevCategoryId	INT
	
	SET @ExchangeRateExists = 0
	SET @YearMonth = @Year*100+@Month

	--verify if we have all the mandatory parameters
	IF(@IdCategory IS NULL OR 
	   @CurrencyFrom IS NULL OR 
	   @YearMonth IS NULL OR 
	   @NewExchangeRate IS NULL )
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN -1		
	END

	--verify if the exchangte rate category exists
	SELECT @IndevCategoryId = ERC.Id
	FROM EXCHANGE_RATE_CATEGORIES AS ERC(nolock)
	WHERE ERC.InFinanceCategoryId = @IdCategory
	
	IF(@IndevCategoryId IS NULL)
	BEGIN
		SET @ErrorMessage = 'The INFinance Exchange Rate Category ' + convert(varchar(10), @IdCategory) + ' does not exists in INDEV Exchange Rate Categories catalogue'
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN -2
	END


	--verify if the currency exists
	SELECT @IdCurrencyTo = C.[Id]
	FROM CURRENCIES AS C(nolock)
	WHERE UPPER(C.Code) = UPPER (@CurrencyFrom)  
	
	IF(@IdCurrencyTo IS NULL)
	BEGIN
		SET @ErrorMessage = 'The Currency ' + @CurrencyFrom + ' does not exists in INDEV Currencies catalogue'
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN -3
	END

	-- verify if the yearmonth value is valid
	Select @YMValidationResult = ValidationResult,
	       @ErrorMessage = ErrorMessage
	from fnValidateYearMonth(@YearMonth)

	if (@YMValidationResult < 0)
	begin
	 	RAISERROR(@ErrorMessage, 16, 1)
		RETURN -4
	end

	-- verify the new exchange rate to be strict positive
	IF(@NewExchangeRate <= 0)
	BEGIN
		SET @ErrorMessage = 'The New Exchange Rate ' + convert(varchar(10), @NewExchangeRate) + ' is not a strict positive value'
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN -5
	END

------------------End validation section -------------------------------



	--decide if we do an insert or update	
	IF EXISTS( SELECT *
	FROM EXCHANGE_RATES AS ER
	WHERE 	ER.IdCategory = @IndevCategoryId AND
		ER.YearMonth = @YearMonth AND
		ER.IdCurrencyTo = @IdCurrencyTo) 
	SET @ExchangeRateExists = 1

	IF (@ExchangeRateExists <> 1)
	BEGIN
		INSERT INTO EXCHANGE_RATES (IdCategory, YearMonth, IdCurrencyTo, ConversionRate)
		VALUES			   (@IndevCategoryId, @YearMonth, @IdCurrencyTo, 1 / @NewExchangeRate) 
	END
	ELSE
	BEGIN
		UPDATE EXCHANGE_RATES 	
		SET ConversionRate = (1 / @NewExchangeRate)	    
		WHERE IdCategory = @IndevCategoryId AND
		      IdCurrencyTo = @IdCurrencyTo AND
		      YearMonth = @YearMonth

	END

	SELECT 1 / @NewExchangeRate
GO
