IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_PROJECT_CATEGORY]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_PROJECT_CATEGORY
GO

CREATE VIEW OLAP_DIMENSION_PROJECT_CATEGORY
AS


SELECT TOP 100 PERCENT
	(case when PT.Type = 'Customer' then 'Billable'
             when PT.Type = 'Research' then 'Billable'
             when PT.Type = 'Assistance'  then 'Billable'
             when PT.Type = 'Internal' then 'Billable'
			 when PT.Type = 'Non Billable' then 'Non Billable'
             else 'NotCategorized' end) AS ProjectCategoryType,
	(case when PT.Type = 'Customer' then 1
             when PT.Type = 'Research' then 1
             when PT.Type = 'Assistance'  then 1
             when PT.Type = 'Internal' then 1
			 when PT.Type = 'Non Billable' then 2
             else 3 end) AS ProjectCategoryTypeId,
       PT.Id as ProjectTypeIdKey
FROM PROJECT_TYPES PT 
ORDER BY ProjectCategoryTypeId
GO
