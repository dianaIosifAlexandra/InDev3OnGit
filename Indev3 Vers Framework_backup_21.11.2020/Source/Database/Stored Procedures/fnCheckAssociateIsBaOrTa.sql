--Drops the Function fnCheckAssociateIsBaOrTa if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnCheckAssociateIsBaOrTa]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnCheckAssociateIsBaOrTa]
GO
CREATE   FUNCTION fnCheckAssociateIsBaOrTa
	(@IdAssociate	INT)
RETURNS BIT
AS
BEGIN

	DECLARE @IsBAOrTA BIT,
		@IdRole INT

	SELECT @IdRole = IdRole
	FROM ASSOCIATE_ROLES
	WHERE IdAssociate = @IdAssociate

	--the Role of BA or TA has special access rights - they may see all the projects
	SET @IsBAOrTA = CASE WHEN (@IdRole = 1 OR @IdRole = 2) THEN 1 ELSE 0 END

RETURN @IsBAOrTA
END

GO

