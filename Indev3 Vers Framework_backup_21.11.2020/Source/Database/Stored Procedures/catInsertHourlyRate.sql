--Drops the Procedure catInsertHourlyRate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertHourlyRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertHourlyRate
GO
CREATE PROCEDURE catInsertHourlyRate
 	@IdCostCenter	INT,		--The Id of the Cost Center that is connected to the Hourly Rate you want to insert 	
	@YearMonth	INT,		--The Year and Month of the Hourly Rate you want to Insert
	@Value		DECIMAL(12,2) = NULL	--The Value of the Hourly Rate you want to Insert
AS

	IF NOT EXISTS( SELECT *
	FROM COST_CENTERS AS CC(TABLOCKX)
	WHERE 	CC.[Id] = @IdCostCenter) 
	BEGIN
		RAISERROR('The selected cost center does not exists anymore',16,1)
		RETURN -1
	END
	
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
		RETURN -2
	end
--end validation section

DECLARE @ValidateLogicKey	BIT,
	@LogicalKey		VARCHAR(40)
	
	SET @LogicalKey = 'Year, Month, Cost Center'

	IF EXISTS( SELECT *
	FROM HOURLY_RATES AS HR(TABLOCKX)
	WHERE 	HR.YearMonth = @YearMonth AND
		HR.IdCostCenter = @IdCostCenter)
	SET @ValidateLogicKey = 1
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -3
	END

	IF(@IdCostCenter IS NULL OR 	  
	   @YearMonth IS NULL OR 
	   @Value IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -4		
	END

	INSERT INTO HOURLY_RATES (IdCostCenter,YearMonth,HourlyRate)
	VALUES		   	 (@IdCostCenter,@YearMonth,@Value)
	

GO

