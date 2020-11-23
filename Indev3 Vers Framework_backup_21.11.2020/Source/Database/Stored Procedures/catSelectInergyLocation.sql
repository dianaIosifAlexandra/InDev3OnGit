--Drops the Procedure catSelectInergyLocation if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectInergyLocation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectInergyLocation
GO
CREATE PROCEDURE catSelectInergyLocation
	@Id AS INT 	--The Id of the selected Inergy Location
AS
	--If @Id has the value -1, it will return all Inergy Locations
IF @Id=-1
BEGIN
	SELECT 	
		IL.Code		AS 'Code',
		IL.Name		AS 'Name',
		C.Name		AS 'CountryName',
		IL.Rank		AS 'Rank',
		CURR.Name	AS 'CurrencyName',
		IL.Id		AS 'Id',
		IL.IdCountry	AS 'IdCountry',
		CURR.Id		As 'IdCurrency'
	FROM INERGY_LOCATIONS IL(nolock)
	INNER JOIN COUNTRIES C(nolock)
		ON IL.IdCountry	= C.Id
	LEFT JOIN CURRENCIES CURR ON C.IdCurrency = CURR.Id
	ORDER BY IL.Rank
END
IF @Id=-2
BEGIN
	SELECT 	
		CAST(NULL AS VARCHAR(8))	AS 'Code',
		CAST(NULL AS VARCHAR(30))	AS 'Name',
		CAST(NULL AS VARCHAR(30))	AS 'CountryName',
		ISNULL(MAX(IL.Rank),0)+1	AS 'Rank',
		CAST(NULL AS VARCHAR(30))	AS 'CurrencyName',
		CAST(NULL AS INT)		AS 'Id',
		CAST(NULL AS INT)		AS 'IdCountry',
		CAST(NULL AS INT)		As 'IdCurrency'
	FROM INERGY_LOCATIONS IL(nolock)
	INNER JOIN COUNTRIES C(nolock)
		ON IL.IdCountry	= C.Id
	LEFT JOIN CURRENCIES CURR ON C.IdCurrency = CURR.Id
	
END

IF @Id>0
BEGIN
	SELECT 	
		IL.Code		AS 'Code',
		IL.Name		AS 'Name',
		C.Name		AS 'CountryName',
		IL.Rank		AS 'Rank',
		CURR.Name	AS 'CurrencyName',
		IL.Id		AS 'Id',
		IL.IdCountry	AS 'IdCountry',
		CURR.Id		As 'IdCurrency'
	FROM INERGY_LOCATIONS IL(nolock)
	INNER JOIN COUNTRIES C(nolock)
		ON IL.IdCountry	= C.Id
	LEFT JOIN CURRENCIES CURR ON C.IdCurrency = CURR.Id
	WHERE IL.Id = @Id
END

GO

