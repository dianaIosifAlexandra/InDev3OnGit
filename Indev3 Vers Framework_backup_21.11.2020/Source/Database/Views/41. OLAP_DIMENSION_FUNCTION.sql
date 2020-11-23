IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_FUNCTION]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_FUNCTION
GO

CREATE VIEW OLAP_DIMENSION_FUNCTION
AS

SELECT TOP 100 PERCENT
	F.Name AS FunctionName,
	F.Id AS FunctionIdKey,
	F.Rank AS FunctionRank,
	D.Name AS DepartmentName,
	D.Id AS DepartmentIdKey,
	D.Rank AS DepartmentRank
FROM DEPARTMENTS D
INNER JOIN FUNCTIONS F
	ON F.Id = D.IdFunction
ORDER BY F.Rank, D.Rank

GO

