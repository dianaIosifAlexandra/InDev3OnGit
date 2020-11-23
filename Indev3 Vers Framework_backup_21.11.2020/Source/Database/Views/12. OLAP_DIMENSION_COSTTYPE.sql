IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_COSTTYPE]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_COSTTYPE
GO

CREATE VIEW dbo.OLAP_DIMENSION_COSTTYPE
AS

--select associates from all the project core teams
SELECT TOP 100 PERCENT 
	CIT.Id as CostTypeIdKey,
	CIT.Name as CostTypeName,
	CIT.Rank as Rank
FROM COST_INCOME_TYPES CIT
UNION ALL
SELECT TOP 100 PERCENT  
	CAST(-1 AS INT) as CostTypeIdKey,
	'' AS CostTypeName,
	CAST(0 AS INT) AS Rank
ORDER BY Rank

GO
