IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.OLAP_FACTTABLE_EXCHANGE_RATES') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_FACTTABLE_EXCHANGE_RATES
GO

CREATE VIEW OLAP_FACTTABLE_EXCHANGE_RATES
AS

SELECT 	OP.YearMonthKey as YearMonthKey,
	CFROM.Id as CurrencyIdFromKey,
	CTO.Id as CurrencyIdToKey,
	CAST(dbo.fnGetExchangeRate(CFROM.Id, CTO.Id, OP.YearMonthKey) AS DECIMAL(18,2)) AS ExchangeRate
FROM OLAP_PERIODS OP
CROSS JOIN
OLAP_CURRENCIES CFROM
CROSS JOIN
OLAP_CURRENCIES CTO

GO

