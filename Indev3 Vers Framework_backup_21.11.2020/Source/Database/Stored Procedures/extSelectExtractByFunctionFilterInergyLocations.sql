--Drops the Procedure bgtInergyLocationFilterForCostCenter if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extSelectExtractByFunctionFilterInergyLocations]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extSelectExtractByFunctionFilterInergyLocations
GO
CREATE PROCEDURE extSelectExtractByFunctionFilterInergyLocations
	@IdCountry		INT
AS
		SELECT  IL.Id			AS 'Id',
			IL.Name			AS 'Name',
			C.Id			AS 'IdCountry'
		FROM INERGY_LOCATIONS AS IL
		INNER JOIN COUNTRIES  C
			ON IL.IdCountry = C.[Id]
		WHERE 	IL.IdCountry = CASE WHEN @IdCountry = -1 THEN IL.IdCountry ELSE @IdCountry END
		ORDER BY IL.Rank

		
GO

