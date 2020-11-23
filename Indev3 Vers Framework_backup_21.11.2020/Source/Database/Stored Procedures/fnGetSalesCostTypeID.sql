--Drops the Function fnGetSalesCostTypeID if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetSalesCostTypeID]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetSalesCostTypeID]
GO


CREATE   FUNCTION fnGetSalesCostTypeID
()	
RETURNS INT
AS
BEGIN 
    RETURN 7
END

GO


