--select dbo.fnIsAssociatePMOnProject(690, 479)
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnIsAssociatePMOnProject]'))
	DROP FUNCTION fnIsAssociatePMOnProject
GO

CREATE FUNCTION fnIsAssociatePMOnProject
(
	@IdProject	AS INT,
	@IdAssociate	AS INT
	
)	
RETURNS BIT
AS
BEGIN
	DECLARE @IdFunction	INT,
		@IsAssociatePM	BIT

	SET @IsAssociatePM = 0

	SELECT  @IdFunction = IdFunction
	FROM	PROJECT_CORE_TEAMS AS PCT
	WHERE	PCT.IdProject = @IdProject AND
		PCT.IdAssociate = @IdAssociate AND
		PCT.IsActive = 1

	IF @IdFunction IN (1, 7) --PM, Program assistant
		SET @IsAssociatePM = 1

	RETURN @IsAssociatePM
END
GO

