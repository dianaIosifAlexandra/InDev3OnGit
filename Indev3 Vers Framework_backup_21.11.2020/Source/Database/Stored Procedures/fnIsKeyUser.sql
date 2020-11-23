--Drops the Function fnIsKeyUser if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnIsKeyUser]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnIsKeyUser]
GO
create   FUNCTION [dbo].[fnIsKeyUser]
	(@IdAssociate	INT)
RETURNS BIT
AS
BEGIN

	DECLARE @IdRole INT
	
	SELECT @IdRole = IdRole
	FROM ASSOCIATE_ROLES
	WHERE IdAssociate = @IdAssociate
	
	RETURN CASE WHEN (@IdRole = (select ID from ROLES where Name='Key User')) THEN 1 ELSE 0 END


END


GO
