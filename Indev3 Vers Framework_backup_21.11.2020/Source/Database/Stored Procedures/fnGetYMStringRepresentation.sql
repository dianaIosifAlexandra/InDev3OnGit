--Drops the Function fnGetValuedHours if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetYMStringRepresentation]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetYMStringRepresentation]
GO

CREATE   FUNCTION fnGetYMStringRepresentation
	( 	
	@YearMonth	INT 
	)
RETURNS CHAR(7)
AS
BEGIN
	DECLARE @Year INT
	DECLARE @Month INT
	SET @Year = @YearMonth / 100
	SET @Month = @YearMonth % 100
	IF (@Month < 10)
		RETURN CAST (@Year AS CHAR(4)) + '/0' + CAST (@Month AS CHAR(1))
	RETURN CAST (@Year AS CHAR(4)) + '/' + CAST (@Month AS CHAR(2))
END
GO


