IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_DIMENSION_CUR_NAME]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_DIMENSION_CUR_NAME
GO

CREATE VIEW OLAP_DIMENSION_CUR_NAME
AS

SELECT Id AS CurrencyIdKey,
       Code + '-' + Name AS CurrencyName,
       Code 		 AS CurrencyCode
FROM OLAP_CURRENCIES
GO

