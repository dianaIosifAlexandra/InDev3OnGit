--Drops the Procedure extSelectExtractByFunctionFilterCountriesForRegion if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extSelectExtractByFunctionFilterCountriesForRegion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extSelectExtractByFunctionFilterCountriesForRegion
GO
CREATE PROCEDURE extSelectExtractByFunctionFilterCountriesForRegion
	@IdRegion AS INT --The Id of the desired region
AS
	IF @IdRegion = -1
		SELECT 	C.[Id]		AS 'Id',		
			C.[Name]	AS 'Name',
			C.IdRegion	AS 'IdRegion'		
		FROM COUNTRIES AS C(nolock)
		WHERE C.IdRegion is not null -- select only INERGY countries
		ORDER BY C.Rank
	ELSE
		SELECT 	C.[Id]		AS 'Id',		
			C.[Name]	AS 'Name',
			C.IdRegion	AS 'IdRegion'		
		FROM COUNTRIES AS C(nolock)	
		WHERE IdRegion = @IdRegion
		ORDER BY C.Rank
GO
