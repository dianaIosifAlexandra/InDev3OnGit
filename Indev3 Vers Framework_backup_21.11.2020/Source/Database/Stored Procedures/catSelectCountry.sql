--Drops the Procedure catSelectCountry if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectCountry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectCountry
GO
CREATE PROCEDURE catSelectCountry
	@Id AS INT 	--The Id of the selected Country
AS
	--If @Id has the value -1, it will return all Countries
	--if @id has the value -2 it will return new rank
IF @Id=-1
BEGIN
	SELECT 	
		C.Code		AS 'Code',
		C.Name		AS 'Name',
		R.Name		AS 'RegionName',
		CR.Name		AS 'CurrencyName',
		C.Email		AS 'Email',
		C.Rank		AS 'Rank',
		C.Id		AS 'Id',
		C.IdRegion	AS 'IdRegion',
		C.IdCurrency	AS 'IdCurrency'
		
	FROM COUNTRIES AS C(nolock)
	INNER JOIN CURRENCIES AS CR(nolock)
		ON C.IdCurrency = CR.Id
	LEFT JOIN REGIONS AS R(nolock)
		ON C.IdRegion = R.Id
	ORDER BY C.Rank
END
IF @Id=-2
BEGIN
	SELECT 	
		CAST(NULL AS VARCHAR(3))	AS 'Code',
		CAST(NULL AS VARCHAR(30))	AS 'Name',
		CAST(NULL AS VARCHAR(30))	AS 'RegionName',
		CAST(NULL AS VARCHAR(30))	AS 'CurrencyName',
		CAST(NULL AS INT)		AS 'Id',
		CAST(NULL AS INT)		AS 'IdRegion',
		CAST(NULL AS INT)		AS 'IdCurrency',
		CAST(NULL AS VARCHAR(30))	AS 'Email',
		ISNULL(MAX(C.Rank),0)+1		AS 'Rank'
	FROM COUNTRIES AS C(nolock)
	INNER JOIN CURRENCIES AS CR(nolock)
		ON C.IdCurrency = CR.Id
	LEFT JOIN REGIONS AS R(nolock)
		ON C.IdRegion = R.Id
	
END

IF @ID>0
BEGIN
	SELECT 	
		C.Code		AS 'Code',
		C.Name		AS 'Name',
		R.Name		AS 'RegionName',
		CR.Name		AS 'CurrencyName',
		C.Email		AS 'Email',
		C.Rank		AS 'Rank',
		C.Id		AS 'Id',
		C.IdRegion	AS 'IdRegion',
		C.IdCurrency	AS 'IdCurrency'
				
	FROM COUNTRIES AS C(nolock)
	INNER JOIN CURRENCIES AS CR(nolock)
		ON C.IdCurrency = CR.Id
	LEFT JOIN REGIONS AS R(nolock)
		ON C.IdRegion = R.Id
	WHERE C.Id =  @Id
END

GO

