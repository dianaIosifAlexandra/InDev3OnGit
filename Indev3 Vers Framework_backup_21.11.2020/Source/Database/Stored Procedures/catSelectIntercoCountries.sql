--Drops the Procedure catSelectIntercoCountries if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectIntercoCountries]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectIntercoCountries
GO
CREATE PROCEDURE catSelectIntercoCountries
	@IdProject 	AS INT 	--The IdProject of the project
AS
	--Given a project, returns the Countries that have interco for this project
	SELECT 	C.[Id],
		C.[Code],
		C.[Name],
		C.Email
	FROM 	COUNTRIES AS C
	INNER 	JOIN PROJECTS_INTERCO_LAYOUT AS PIL
	ON	C.[Id] = PIL.IdCountry
	WHERE	PIL.IdProject = @IdProject
GO

