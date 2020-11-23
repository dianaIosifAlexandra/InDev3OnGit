--Drops the Function fnDate2String if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnDate2String]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnDate2String]
GO
CREATE   FUNCTION fnDate2String
	(@Date	SMALLDATETIME)
RETURNS VARCHAR(8)
AS
BEGIN

	DECLARE @StringDate VARCHAR(8)

	SET @StringDate = CAST(YEAR(@Date) AS VARCHAR(4)) +
	RIGHT('0'+CAST(MONTH(@Date) AS VARCHAR(2)),2)+
	RIGHT('0'+CAST(DAY(@Date) AS VARCHAR(2)),2)

RETURN @StringDate
END

GO

