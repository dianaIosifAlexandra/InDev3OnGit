IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_DUM_IL_FCT]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_DUM_IL_FCT
GO

CREATE VIEW OLAP_DIMENSION_DUM_IL_FCT
AS

SELECT TOP 100 PERCENT
	IL.Name as InergyLocationName,
	IL.Id as InergyLocationIdKey,
	IL.Rank AS InergyLocationRank,
	F.Name as FunctionName,
	F.Id as FunctionIdKey,
	F.Rank as FunctionRank,
	D.name as DepartmentName,
	D.Id as DepartmentIdKey,
	D.Rank as DepartmentRank,
	IL.Code + ' - ' + CC.Code as CostCenterCode,
	CC.Id as CostCenterIdKey
FROM COST_CENTERS CC
INNER JOIN INERGY_LOCATIONS IL 
	ON IL.Id = CC.IdInergyLocation
INNER JOIN DEPARTMENTS D
	ON CC.IdDepartment = D.Id
INNER JOIN FUNCTIONS F
	ON D.IdFunction = F.Id
ORDER BY IL.Id, F.Rank, D.Rank, CostCenterCode


GO
