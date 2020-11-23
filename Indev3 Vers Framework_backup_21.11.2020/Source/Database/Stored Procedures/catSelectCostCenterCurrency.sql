--Drops the Procedure catSelectCostCenterCurrency if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectCostCenterCurrency]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectCostCenterCurrency
GO
CREATE PROCEDURE catSelectCostCenterCurrency
	@Id AS INT 	--The Id of the selected Cost Center
AS
	SELECT
		CR.Code		AS	'CurrencyCode',
		CR.Name		AS	'CurrencyName',
		CR.[Id]		AS	'IdCurrency'
	FROM COST_CENTERS AS CC(nolock)
	INNER JOIN INERGY_LOCATIONS AS IL(nolock)
		ON CC.IdInergyLocation = IL.[Id]
	INNER JOIN COUNTRIES AS CT(nolock) 
		ON CT.[Id] = IL.IdCountry
	INNER JOIN CURRENCIES AS CR(nolock) 
		ON CR.[Id] = CT.IdCurrency
	WHERE CC.[Id] = @Id
GO



