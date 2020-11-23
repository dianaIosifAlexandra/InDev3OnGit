--Drops the Procedure catUpdateHourlyRate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateHourlyRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateHourlyRate
GO
CREATE PROCEDURE catUpdateHourlyRate
 	@IdCostCenter	INT,		--The Id of the Cost Center that is connected to the Hourly Rate you want to insert 	
	@YearMonth	INT,		--The Year and Month of the Hourly Rate you want to Insert
	@Value		DECIMAL(12,2)	--The Value of the Hourly Rate you want to Insert	
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

DECLARE @Rowcount 		INT,
	@ValidateLogicKey	BIT,
	@LogicalKey		VARCHAR(40)
	
	SET @LogicalKey = 'Year, Month, Cost Center'

	IF EXISTS( SELECT *
	FROM HOURLY_RATES AS HR
	WHERE 	HR.YearMonth = @YearMonth AND
		HR.IdCostCenter = @IdCostCenter ) 
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2
	END

	IF(@IdCostCenter IS NULL OR 
	   @YearMonth IS NULL OR 
	   @Value IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -3	
	END

	UPDATE HOURLY_RATES 	
	SET  HourlyRate = @Value
	WHERE 	YearMonth = @YearMonth AND
		IdCostCenter = @IdCostCenter

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

