IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extSelectExtractByFunctionFilterCountries]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extSelectExtractByFunctionFilterCountries
GO

CREATE PROCEDURE extSelectExtractByFunctionFilterCountries
		@IdCountry INT
AS
		SELECT  C.Id			AS 'Id',
			C.Name			AS 'Name',
			C.IdRegion		AS 'IdRegion'
		FROM COUNTRIES AS C
		WHERE 	C.IdRegion IS NOT NULL AND -- select only INERGY countries 
			C.Id = CASE WHEN @IdCountry = -1 THEN C.Id ELSE @IdCountry END
		ORDER BY C.Rank

		

GO
