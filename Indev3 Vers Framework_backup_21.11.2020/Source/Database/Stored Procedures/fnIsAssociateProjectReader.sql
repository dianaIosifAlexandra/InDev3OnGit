IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnIsAssociateProjectReader]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnIsAssociateProjectReader]
GO

CREATE FUNCTION fnIsAssociateProjectReader
(
	@IdProject	AS INT,
	@IdAssociate	AS INT
	
)	
RETURNS BIT
AS
BEGIN
	DECLARE @IdFunction	INT,
		@IsAssociatePR	BIT

	SET @IsAssociatePR = 0

	SELECT  @IdFunction = IdFunction
	FROM	PROJECT_CORE_TEAMS AS PCT
	WHERE	PCT.IdProject = @IdProject AND
		PCT.IdAssociate = @IdAssociate AND
		PCT.IsActive = 1

	IF @IdFunction = 8 --Project Reader
		SET @IsAssociatePR = 1

	RETURN @IsAssociatePR
END

GO

