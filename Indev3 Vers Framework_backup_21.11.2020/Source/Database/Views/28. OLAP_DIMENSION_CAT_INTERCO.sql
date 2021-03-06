IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_CAT_INTERCO]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_CAT_INTERCO
GO

CREATE VIEW OLAP_DIMENSION_CAT_INTERCO
AS

SELECT Id,
       Name,
       Formula
FROM OLAP_CATEGORIES
WHERE Id IN (1,2,3,4,5)

GO

