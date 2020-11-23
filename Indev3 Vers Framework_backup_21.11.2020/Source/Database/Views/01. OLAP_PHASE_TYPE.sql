IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_PHASE_TYPE]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_PHASE_TYPE
GO

CREATE VIEW OLAP_PHASE_TYPE
AS

SELECT TOP 100 PERCENT
      	(case when PH.Code = '1' then 1
	     when PH.Code IN ('2','3','4','5','6') then 2
	     when PH.Code = '7' then 3
	     when PH.Code IN ('0', 'NA') then 4 end) AS PhaseTypeId,
       (case when PH.Code = '1' then 'Quoting'
	     when PH.Code IN ('2','3','4','5','6') then 'Development'
	     when PH.Code = '7' then 'Serial Life'
	     when PH.Code IN ('0', 'NA') then 'Not Allocated' end) AS PhaseTypeName,
       PH.Id as PhaseId,
       PH.Code as PhaseCode,
       PH.Name as PhaseName
FROM PROJECT_PHASES PH 
ORDER BY PhaseTypeId

GO

