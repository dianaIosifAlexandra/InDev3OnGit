IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnWPHasInterco]'))
	DROP FUNCTION fnWPHasInterco
GO

CREATE FUNCTION fnWPHasInterco
	(@IdProject	AS INT,	--The CurrencyFrom of the selected Exchange Rate
	@IdPhase	AS INT, --The CurrencyTo of the selected Exchange Rate
	@IdWP	AS INT)	--The Year and Month of the selected Exchange Rate
RETURNS BIT
AS
BEGIN
	DECLARE @Id INT
	SELECT @Id = IdWorkPackage 
	FROM PROJECTS_INTERCO AS [PI] 
	WHERE 	([PI].IdProject = @IdProject) AND
		([PI].IdPhase = @IdPhase) AND
		([PI].IdWorkPackage = @IdWP) AND
		[PI].IdCountry = (SELECT MAX(IdCountry) 
				FROM PROJECTS_INTERCO AS [PI2] 
				WHERE 	([PI2].IdProject = [PI].IdProject) AND
					([PI2].IdPhase = [PI].IdPhase) AND
					([PI2].IdWorkPackage = [PI].IdWorkPackage))
	IF (@Id IS NULL)
		RETURN 1
	RETURN 0
END
GO

