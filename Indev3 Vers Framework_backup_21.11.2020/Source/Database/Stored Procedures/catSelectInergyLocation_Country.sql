--Drops the Procedure catSelectInergyLocation_Country if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectInergyLocation_Country]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectInergyLocation_Country
GO
CREATE PROCEDURE catSelectInergyLocation_Country
	@Id AS INT 	--The Id of the selected Id Country
AS
	--If @Id has the value -1, it will return all Inergy Locations
	SELECT 	IL.Id		AS 'Id',
		IL.IdCountry	AS 'IdCountry',
		IL.Code		AS 'Code',
		IL.Name		AS 'Name',
		C.Name		AS 'CountryName',
		CURR.Id		As 'IdCurrency',
		CURR.Name	AS 'CurrencyName'
	FROM INERGY_LOCATIONS IL(nolock)
	INNER JOIN COUNTRIES C(nolock)
		ON IL.IdCountry	= C.Id
	LEFT JOIN CURRENCIES CURR ON C.IdCurrency = CURR.Id
	WHERE IL.IdCountry = CASE @Id WHEN -1 THEN IL.IDCountry ELSE @Id END
-- 	WHERE IL.Id = CASE @Id WHEN -1 THEN IL.Id ELSE @Id END
	ORDER BY IL.Name
GO

