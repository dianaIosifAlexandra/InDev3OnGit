--Drops the Function fnGetHoursCostTypeID if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetHoursCostTypeID]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetHoursCostTypeID]
GO


CREATE   FUNCTION fnGetHoursCostTypeID
()	
RETURNS INT
AS
BEGIN 
    RETURN 6
END

GO


