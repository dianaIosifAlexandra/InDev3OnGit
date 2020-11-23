IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_LOCATION
GO

CREATE VIEW OLAP_DIMENSION_LOCATION
AS

SELECT TOP 100 PERCENT
	R.Name AS RegionName,
	R.Id AS RegionIdKey,
	R.Rank AS RegionRank,
	C.Name AS CountryName,
	C.Id AS CountryIdKey,
	C.Rank AS CountryRank,
	IL.Name AS InergyLocationName,
	IL.Id AS InergyLocationIdKey,
	IL.Rank AS InergyLocationRank
FROM INERGY_LOCATIONS IL
INNER JOIN COUNTRIES C
	ON C.Id = IL.IdCountry
INNER JOIN REGIONS R
	ON R.Id = C.IdRegion
ORDER BY R.Rank, C.Rank, IL.Rank

GO

