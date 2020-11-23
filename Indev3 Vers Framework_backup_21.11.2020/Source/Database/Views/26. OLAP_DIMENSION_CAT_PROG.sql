IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_CAT_PROG]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_CAT_PROG
GO

CREATE VIEW OLAP_DIMENSION_CAT_PROG
AS

SELECT Id,
       Name,
       Formula
FROM OLAP_CATEGORIES

GO

