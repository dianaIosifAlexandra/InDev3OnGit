IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_FCT_CC]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_FCT_CC
GO

CREATE VIEW OLAP_DIMENSION_FCT_CC
AS

SELECT TOP 100 PERCENT
	F.Id AS FunctionIdKey,
	F.Name AS FunctionName,
	F.Rank AS FunctionRank,
	CC.Id AS CostCenterIdKey,
 	D.Name + '-' + IL.Code + '-' + CC.Code AS CostCenterName
FROM COST_CENTERS CC
INNER JOIN DEPARTMENTS D
	ON CC.IdDepartment = D.Id
INNER JOIN INERGY_LOCATIONS IL
	ON CC.IdInergyLocation = IL.Id
INNER JOIN FUNCTIONS F
	ON D.IdFunction = F.Id
ORDER BY IL.Rank,D.Rank,  F.Rank, CC.Code

GO
