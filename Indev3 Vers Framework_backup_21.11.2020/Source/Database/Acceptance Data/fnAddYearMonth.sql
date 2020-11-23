IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnAddYearMonth]'))
	DROP FUNCTION fnAddYearMonth
GO

create function fnAddYearMonth(
	@YearMonth 	   int,
	@MonthsToAdd 	   int
)
returns int
AS
BEGIN
declare @YearMonthNew int,
	@AddedMonths  int,
	@YearNew      int,
	@MonthNew     int

Set @AddedMonths  = (@YearMonth % 100)-1 + @MonthsToAdd
Set @YearNew = FLOOR(@YearMonth/100) + FLOOR(@AddedMonths/12)

Set @MonthNew = @AddedMonths % 12

--return @AddedMonths
--return @MonthNew
--return @YearNew
return @YearNew * 100 + @MonthNew+1
  
END
GO


--select dbo.fnAddYearMonth (200001, 10)
