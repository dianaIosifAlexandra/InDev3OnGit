--Drops the Function fnGetSplittedValue if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetSplittedValue]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetSplittedValue]
GO
CREATE  FUNCTION fnGetSplittedValue
	(@TotalValue	BIGINT,
	@Date		INT,
	@StartYearMonth	INT,
	@EndYearMonth	INT)
RETURNS BIGINT
AS
BEGIN
	--Return null if total value is null
	IF ((@TotalValue IS NULL) OR (@TotalValue = 0))
	BEGIN
		RETURN @TotalValue
	END

	DECLARE @StartYear INT
	DECLARE @StartMonth INT
	DECLARE @EndYear INT
	DECLARE @EndMonth INT
	DECLARE @NoMonths INT
	DECLARE @CurrentMonthIndex INT 	--the index if the ym given by date between startyearmonth and endyearmonth
					-- (e.g. if start = 200006, end = 200010, then 200006 has index = 1, 200010 has
					-- index = 5, 200008 has index = 3 etc.)

	SET @CurrentMonthIndex = dbo.fnGetMonthIndex(@Date, @StartYearMonth, @EndYearMonth)

	IF (@CurrentMonthIndex = -1)
	BEGIN
		RETURN NULL
	END

	--Calculate the start year, start month, end year, end month
	SET @StartYear = @StartYearMonth / 100
	SET @StartMonth = @StartYearMonth % 100
	SET @EndYear = @EndYearMonth / 100
	SET @EndMonth = @EndYearMonth % 100

	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME
	
	--Convert the given yearmonths to dates
	SET @StartDate = CAST(CAST(@StartYear AS CHAR(4)) + '-' + CAST(@StartMonth AS VARCHAR(2)) + '-1' AS DATETIME)
	SET @EndDate = CAST(CAST(@EndYear AS CHAR(4)) + '-' + CAST(@EndMonth AS VARCHAR(2)) + '-1' AS DATETIME)

	--Get the number of months in the period
	SET @NoMonths = DATEDIFF(m, @StartDate, @EndDate) + 1

	DECLARE @SplittedValue BIGINT
	DECLARE @TotalValueDecimal DECIMAL(18, 4)
	SET @TotalValueDecimal = @TotalValue
	--Rounded value calculation
	SET @SplittedValue = ROUND(@TotalValueDecimal / @NoMonths, 0)

	IF (@SplittedValue = 0)
	BEGIN
		IF (@CurrentMonthIndex < @NoMonths)
		BEGIN
			RETURN 0
		END
		ELSE
		BEGIN
			RETURN @TotalValue
		END
	END	
	ELSE
	BEGIN
		--The number of full months for which, if we add in each month @SplittedValue, we do not get an amount
		--greater than the total (@TotalValue / @SplittedValue)
		DECLARE @NoMonthsTotalReached BIGINT
		SET @NoMonthsTotalReached = @TotalValue / @SplittedValue
	
		IF (@CurrentMonthIndex = @NoMonthsTotalReached + 1)
		BEGIN
			RETURN @TotalValue % @SplittedValue
		END
		IF (@CurrentMonthIndex > @NoMonthsTotalReached + 1)
		BEGIN
			RETURN 0
		END 
	
		IF (@CurrentMonthIndex < @NoMonths)  
		BEGIN
			IF (@CurrentMonthIndex <= @NoMonthsTotalReached)
			BEGIN
				RETURN @SplittedValue
			END
		END
		ELSE
		BEGIN
-- 			IF (@CurrentMonthIndex = @NoMonthsTotalReached)
-- 			BEGIN
				RETURN @TotalValue - @SplittedValue * (@NoMonths - 1) 
-- 			END
		END
	END

	--Normally, the function should have returned by this point
	RETURN 0
	
END

GO


