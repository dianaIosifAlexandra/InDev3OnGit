--Drops the Function fnIsFinancial if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnIsFinancial]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnIsFinancial]
GO
CREATE   FUNCTION fnIsFinancial
	(@IdAssociate	INT)
RETURNS BIT
AS
BEGIN

	DECLARE @IdRole INT
	
	SELECT @IdRole = IdRole
	FROM ASSOCIATE_ROLES
	WHERE IdAssociate = @IdAssociate
	
	RETURN CASE WHEN (@IdRole = 3) THEN 1 ELSE 0 END


END

GO

