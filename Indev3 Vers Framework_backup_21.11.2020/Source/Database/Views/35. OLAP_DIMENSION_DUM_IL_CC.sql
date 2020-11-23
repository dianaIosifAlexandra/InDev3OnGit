IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_DUM_IL_CC]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_DUM_IL_CC
GO

CREATE VIEW OLAP_DIMENSION_DUM_IL_CC

AS

SELECT DISTINCT TOP 100 PERCENT
	OT.Name				AS OwnerTypeName,
	OT.Id				AS OwnerTypeIdKey,
	IL.Name 			AS InergyLocationName,
	IL.Id	 			AS InergyLocationIdKey,
	IL.Rank				AS InergyLocationRank,
	O.Name				AS OwnerName,
	O.Id				AS OwnerIdKey,
	PRG.Code + ' - ' + PRG.Name 	AS ProgramName,
	PRG.Id 				AS ProgramIdKey,
	O.Rank				AS OwnerRank, -- appear in the select list because when using DISTINCT with ORDER BY, all columns
	PRG.Rank			AS ProgramRank -- in the ORDER BY must appear in the SELECT list
FROM OWNER_TYPES OT
INNER JOIN OWNERS O
	ON O.IdOwnerType = OT.Id
INNER JOIN PROGRAMS PRG
	ON O.Id = PRG.IdOwner
INNER JOIN Projects PRJ
	ON PRG.Id = PRJ.IdProgram
INNER JOIN OLAP_CC_WP_FROM OCW
	ON PRJ.Id = OCW.IdProject
INNER JOIN COST_CENTERS CC
	ON OCW.IdCostCenter = CC.Id
INNER JOIN INERGY_LOCATIONS IL	
	ON CC.IdInergyLocation = IL.Id
ORDER BY IL.Id, O.Rank, PRG.Rank
GO

