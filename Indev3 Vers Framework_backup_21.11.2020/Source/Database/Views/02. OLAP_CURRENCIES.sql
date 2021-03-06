IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.OLAP_CURRENCIES') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_CURRENCIES
GO

CREATE VIEW OLAP_CURRENCIES
AS

SELECT Id, Code, Name 
FROM CURRENCIES
Where Code NOT IN ('GBP', 'IRR', 'SKK')

GO

