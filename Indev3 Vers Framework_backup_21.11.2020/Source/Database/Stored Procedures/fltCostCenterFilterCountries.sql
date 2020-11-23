IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fltCostCenterFilterCountries]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE fltCostCenterFilterCountries
GO

CREATE PROCEDURE fltCostCenterFilterCountries
		@IdCountry INT
AS
		SELECT  C.Id			AS 'Id',
			C.Name			AS 'Name'
		FROM COUNTRIES AS C
		WHERE 	C.IdRegion is not null AND -- select only INERGY countries 
			C.Id = case when @IdCountry = -1 then C.Id else @IdCountry end
		ORDER BY C.Rank

		

GO
