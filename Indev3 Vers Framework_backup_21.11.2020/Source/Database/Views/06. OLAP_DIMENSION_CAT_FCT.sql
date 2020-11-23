IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_CAT_FCT]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_CAT_FCT
GO

CREATE VIEW OLAP_DIMENSION_CAT_FCT
AS

SELECT Id,
       Name,
       Formula
FROM OLAP_CATEGORIES
WHERE Id IN (1,2,3,4,5,6,7,8,9) 

GO
