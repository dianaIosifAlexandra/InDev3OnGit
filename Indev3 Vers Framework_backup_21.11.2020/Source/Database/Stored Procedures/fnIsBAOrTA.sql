--Drops the Function fnIsBAOrTA if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnIsBAOrTA]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnIsBAOrTA]
GO
CREATE   FUNCTION fnIsBAOrTA
	(@IdAssociate	INT)
RETURNS BIT
AS
BEGIN

	DECLARE @IdRole INT
	
	SELECT @IdRole = IdRole
	FROM ASSOCIATE_ROLES
	WHERE IdAssociate = @IdAssociate
	
	RETURN CASE WHEN (@IdRole = 1 OR @IdRole = 2) THEN 1 ELSE 0 END


END

GO

