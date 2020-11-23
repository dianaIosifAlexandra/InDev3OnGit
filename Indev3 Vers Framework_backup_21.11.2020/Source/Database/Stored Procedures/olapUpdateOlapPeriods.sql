--Drops the Procedure catUpdateCurrency if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[olapUpdateOlapPeriods]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE olapUpdateOlapPeriods
GO
CREATE PROCEDURE olapUpdateOlapPeriods
AS
	DECLARE @PeriodsMaxYM INT
	DECLARE @PeriodsMaxYear INT

	SELECT 	@PeriodsMaxYM = ISNULL(MAX(YearMonthKey), 200201)
	FROM	OLAP_PERIODS	
	
	SET @PeriodsMaxYear = @PeriodsMaxYM / 100

	IF (@PeriodsMaxYear <> Year(GETDATE())+2)
	BEGIN
		DELETE FROM OLAP_PERIODS
		
		INSERT INTO OLAP_PERIODS (YearMonthKey, Month, Year, MonthName)
		SELECT 	Years.Year*100+Months.Month,
			Months.Month,
			Years.Year,
			Months.MonthName + ' ' + CAST(Years.Year AS Char(4))
		FROM OLAP_YEARS Years
		CROSS JOIN
		OLAP_MONTHS Months
		WHERE Year >= 2002 AND
		Year <= Year(GETDATE())+2
		ORDER BY Years.Year, Months.Month 
	END
GO

