--Drops the Procedure bgtMassInsertOrUpdateHourlyRate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catMassInsertOrUpdateHourlyRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catMassInsertOrUpdateHourlyRate
GO
CREATE PROCEDURE catMassInsertOrUpdateHourlyRate
 	@IdInergyLocation	INT,			--The Id of the Cost Center that is connected to the Hourly Rate you want to insert 	
	@StartYearMonth		INT,			--The Year and Month of the Hourly Rate you want to Insert
	@EndYearMonth		INT,			--The Year and Month of the Hourly Rate you want to Insert	
	@Value			DECIMAL(12,2) = NULL	--The Value of the Hourly Rate you want to Insert
AS
DECLARE @IdCostCenter		INT,
	@CurrentCostCenter	INT,
	@EndYear		SMALLINT,	
	@EndMonth		SMALLINT,
	@StartMonth		SMALLINT,
	@StartYear		SMALLINT,
	@HourlyRate		DECIMAL(12,2),
	@Date			INT

	DECLARE @RetVal INT

	IF (@StartYearMonth > @EndYearMonth)
	BEGIN
		RAISERROR('Start Date cannot be greater than End Date',16,1)
		RETURN -1
	END

	--validation yearmonth section
	Declare	@ErrorMessage		VARCHAR(255),
		@YMValidationResult	INT
	
	if (@StartYearMonth <> -1)
	BEGIN
		-- verify if the yearmonth value is valid
		Select @YMValidationResult = ValidationResult,
		       @ErrorMessage = ErrorMessage
		from fnValidateYearMonth(@StartYearMonth)
	
		if (@YMValidationResult < 0)
		begin
		 	RAISERROR(@ErrorMessage, 16, 1)
			RETURN -2
		end
	END

	if (@EndYearMonth <> -1)
	begin
		-- verify if the yearmonth value is valid
		Select @YMValidationResult = ValidationResult,
		       @ErrorMessage = ErrorMessage
		from fnValidateYearMonth(@EndYearMonth)
	
		if (@YMValidationResult < 0)
		begin
		 	RAISERROR(@ErrorMessage, 16, 1)
			RETURN -3
		end
	end
--end validation section

	IF NOT EXISTS( SELECT *
	FROM INERGY_LOCATIONS AS IL(TABLOCKX)
	WHERE 	IL.[Id] = @IdInergyLocation) 
	BEGIN
		RAISERROR('The selected Inergy Location does not exist',16,1)
		RETURN -4
	END

	DECLARE @UpdatedCCCount INT
	SELECT 	@UpdatedCCCount = COUNT(CC.[Id])
	FROM 	COST_CENTERS AS CC
	WHERE 	CC.IdInergyLocation = @IdInergyLocation AND
		CC.IsActive = 1

	DECLARE CostCenters CURSOR FAST_FORWARD FOR
	SELECT CC.[Id] 
	FROM COST_CENTERS AS CC
	WHERE 	CC.IdInergyLocation = @IdInergyLocation AND
		CC.IsActive = 1


	OPEN CostCenters
	FETCH NEXT FROM CostCenters 
	INTO @IdCostCenter

	WHILE @@FETCH_STATUS = 0 
	BEGIN

		SET @StartYear = @StartYearMonth / 100
		SET @StartMonth = @StartYearMonth % 100
		SET @EndYear = @EndYearMonth / 100
		SET @EndMonth = @EndYearMonth % 100
	
		WHILE ((@StartYear < @EndYear) OR (@StartYear = @EndYear AND @StartMonth <= @EndMonth))
		BEGIN
			SET @HourlyRate = NULL
			SET @Date = @StartYear * 100 + @StartMonth

			SELECT @HourlyRate = HR.HourlyRate
			FROM HOURLY_RATES AS HR
			WHERE 	HR.IdCostCenter = @IdCostCenter AND 
				HR.YearMonth = @Date 

			IF(ISNULL(@HourlyRate,-1) = -1)
			BEGIN
				EXEC @RetVal = catInsertHourlyRate @IdCostCenter = @IdCostCenter,
							 @YearMonth = @Date, 
							 @Value = @Value 
				IF (@@ERROR<>0 OR @RetVal < 0)
				BEGIN
					CLOSE CostCenters
					DEALLOCATE CostCenters
					RETURN -5
				END
			END
			ELSE 
			BEGIN
				EXEC @RetVal = catUpdateHourlyRate @IdCostCenter = @IdCostCenter,
							 @YearMonth = @Date, 
							 @Value = @Value
				IF (@@ERROR<>0 OR @RetVal < 0)
				BEGIN
					CLOSE CostCenters
					DEALLOCATE CostCenters
					RETURN -6
				END
			END
		
			IF(@StartMonth = 12)
			BEGIN
				SET @StartYear = @StartYear + 1
				SET @StartMonth = 1
			END
			ELSE
			BEGIN
				SET @StartMonth = @StartMonth + 1
			END

		END

		FETCH NEXT FROM CostCenters 
		INTO @IdCostCenter
	END
	CLOSE CostCenters
	DEALLOCATE CostCenters

	RETURN @UpdatedCCCount
GO

