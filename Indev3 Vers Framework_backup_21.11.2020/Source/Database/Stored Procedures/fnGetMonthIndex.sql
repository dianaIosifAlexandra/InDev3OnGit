--Drops the Function fnGetMonthIndex if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetMonthIndex]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetMonthIndex]
GO
CREATE   FUNCTION fnGetMonthIndex
	(@CurrentYM	INT, --the ym whose index is calculated
	@StartYM	INT, --the start ym
	@EndYM		INT) --the end ym
RETURNS INT
AS
BEGIN
	IF (@CurrentYM < @StartYM OR @CurrentYM > @EndYM)
	BEGIN
		RETURN -1
	END

	DECLARE 
	@EndYear		SMALLINT,	
	@EndMonth		SMALLINT,
	@StartMonth		SMALLINT,
	@StartYear		SMALLINT,
	@CurrentDate		INT,
	@Index			INT

	SET @Index = 1
	SET @StartYear = @StartYM / 100
	SET @StartMonth = @StartYM % 100
	SET @EndYear = @EndYM / 100
	SET @EndMonth = @EndYM% 100
	
	WHILE ((@StartYear < @EndYear) OR (@StartYear = @EndYear AND @StartMonth <= @EndMonth))
	BEGIN
		SET @CurrentDate = @StartYear * 100 + @StartMonth

		IF (@CurrentDate = @CurrentYM)
		BEGIN
			RETURN @Index
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
		SET @Index = @Index + 1
	END

	RETURN -1
END
GO

