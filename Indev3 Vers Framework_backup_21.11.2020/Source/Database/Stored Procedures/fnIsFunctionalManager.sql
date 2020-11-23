--Drops the Function fnIsFunctionalManager if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnIsFunctionalManager]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnIsFunctionalManager]
GO
CREATE   FUNCTION fnIsFunctionalManager
	(@IdAssociate	INT)
RETURNS BIT
AS
BEGIN

	DECLARE @IdRole INT
	
	SELECT @IdRole = IdRole
	FROM ASSOCIATE_ROLES
	WHERE IdAssociate = @IdAssociate
	
	RETURN CASE WHEN (@IdRole = 6) THEN 1 ELSE 0 END


END

GO

