--Drops the Function fnGetYearMonthOfPreviousMonth if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetYearMonthOfPreviousMonth]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetYearMonthOfPreviousMonth]
GO
CREATE   FUNCTION fnGetYearMonthOfPreviousMonth
	(@CurrentDate	DATETIME)
RETURNS INT
AS
BEGIN
	DECLARE @YearMonthOfPreviousMonth INT
	Set @YearMonthOfPreviousMonth = (case when datepart (mm, @CurrentDate)=1 then datepart (yy, @CurrentDate)-1 else datepart (yy, @CurrentDate) end) * 100 + 
       						   	    (case when datepart (mm, @CurrentDate)=1 then 12 else datepart (mm, @CurrentDate)-1 end)

	RETURN @YearMonthOfPreviousMonth
END
GO

