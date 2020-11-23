--Drops the Function fnCheckAssociateIsPM if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnCheckAssociateIsPM]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnCheckAssociateIsPM]
GO
CREATE   FUNCTION fnCheckAssociateIsPM
(
	@IdAssociate	INT,
	@IdProject	INT
)
RETURNS BIT
AS
BEGIN

	DECLARE @IsPMProject BIT
	DECLARE @IsActive BIT
	
	SELECT @IsActive = PCT.IsActive
	FROM PROJECT_CORE_TEAMS PCT
	INNER JOIN PROJECT_FUNCTIONS PF
		ON PCT.IdFunction = PF.Id
	INNER JOIN PROJECTS P
		ON PCT.IdProject = P.Id
	WHERE PCT.IdProject = @IdProject AND
	      PCT.IdAssociate = @IdAssociate AND
	      PCT.IsActive = 1 AND
	      PF.Id = 1 AND
	      P.IsActive = 1

	SET @IsPMProject = CASE WHEN @IsActive IS NULL THEN 0 ELSE 1 END
	
	RETURN @IsPMProject

END

GO

