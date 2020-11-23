IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_ASSOCIATES
GO

CREATE VIEW dbo.OLAP_DIMENSION_ASSOCIATES
AS

--select associates from all the project core teams
SELECT DISTINCT TOP 100 PERCENT
	(case when A.InergyLogin like '%\null' then 'NotAllocated ' + C.Name
	      when A.Name='NULL, NULL' then A.EmployeeNumber 
	      else A.Name end) as AssociateName,
	SRC.IdAssociate as AssociateIdKey,
	(case when A.InergyLogin like '%\null' then 2
	      when A.Name='NULL, NULL' then 1 
	      else 			0 end) as AssociateOrder


FROM    (SELECT DISTINCT 
		PCT.IdAssociate AS IdAssociate
	FROM PROJECT_CORE_TEAMS PCT(nolock)
	-- select the associates from actual data
	UNION ALL
	SELECT DISTINCT 
		AD.IdAssociate AS IdAssociate
	FROM ACTUAL_DATA_DETAILS_HOURS AD(nolock)
	UNION ALL
	SELECT DISTINCT 
		AD.IdAssociate AS IdAssociate
	FROM ACTUAL_DATA_DETAILS_SALES AD(nolock)
	UNION ALL
	SELECT DISTINCT 
		AD.IdAssociate AS IdAssociate
	FROM ACTUAL_DATA_DETAILS_COSTS AD(nolock)) SRC
	INNER JOIN ASSOCIATES A
		on SRC.IdAssociate = A.Id
	INNER JOIN COUNTRIES C
		on A.IdCountry = C.Id
UNION ALL -- for the situation in which the associate is not allocated
SELECT DISTINCT
	'' as AssociateName, 
	(-1) AS IdAssociate,
	4 as AssociateOrder
 

GO

