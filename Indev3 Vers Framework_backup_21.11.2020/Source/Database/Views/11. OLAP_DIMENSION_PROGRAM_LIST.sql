IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_PROGRAM_LIST]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_PROGRAM_LIST
GO

CREATE VIEW OLAP_DIMENSION_PROGRAM_LIST
AS


SELECT TOP 100 PERCENT 
	O.Name as OwnerName,
	O.Id as OwnerIdKey,
	O.Rank as OwnerRank,
	PRG.Code + '-' + PRG.Name AS ProgramName, 
	PRG.Id as ProgramIdKey,
	PRG.Rank as ProgramRank,
	PRJ.Code + '-' + PRJ.Name AS ProjectName, 
	PRJ.Id as ProjectIdKey,
	PRJ.Code AS ProjectCode
FROM PROJECTS PRJ (nolock)
INNER JOIN PROGRAMS PRG (nolock)
	ON PRJ.IdProgram = PRG.Id
INNER JOIN OWNERS O (nolock)
	ON PRG.IdOwner = O.Id
ORDER BY O.Name, PRG.Code, PRJ.Code

GO
