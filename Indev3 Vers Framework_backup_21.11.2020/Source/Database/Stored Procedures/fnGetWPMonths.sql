--select * from fnGetWPMonths(194535)
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnGetWPMonths]'))
	DROP FUNCTION fnGetWPMonths
GO

CREATE FUNCTION fnGetWPMonths
(
	@IdProject	AS INT,
	@IdPhase	AS INT,
	@IdWP		AS INT
	
)	
RETURNS @WPMonths TABLE
(	
	IdProject INT,
	IdPhase INT,
	IdWP INT,
	YearMonth INT
) 
AS
BEGIN
	DECLARE @StartYearMonth	INT
	DECLARE @EndYearMonth 	INT
	DECLARE @CurrentYear 	INT
	DECLARE @CurrentMonth 	INT
	DECLARE @CurrentYearMonth INT

	SELECT 
		@StartYearMonth = WP.StartYearMonth,
		@EndYearMonth = WP.EndYearMonth
	FROM WORK_PACKAGES AS WP
	WHERE 
		WP.IdProject = @IdProject AND
		WP.IdPhase = @IdPhase AND
		WP.[Id] = @IdWP

	SET @CurrentYearMonth = @StartYearMonth
	--First insert the months of the wp (between startyearmonth and endyearmonth)
	WHILE (@CurrentYearMonth <= @EndYearMonth)
	BEGIN
		INSERT INTO @WPMonths VALUES(@IdProject, @IdPhase, @IdWP, @CurrentYearMonth)
		SET @CurrentYear = @CurrentYearMonth / 100
		SET @CurrentMonth = @CurrentYearMonth % 100
		IF (@CurrentMonth = 12)
		BEGIN
			SET @CurrentYear = @CurrentYear + 1
			SET @CurrentMonth = 1
		END
		ELSE
		BEGIN
			SET @CurrentMonth = @CurrentMonth + 1
		END

		SET @CurrentYearMonth = @CurrentYear * 100 + @CurrentMonth
	END
	RETURN
END
GO

