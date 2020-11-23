--Drops the Procedure catSelectInergyCountry if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectInergyCountry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectInergyCountry
GO
CREATE PROCEDURE catSelectInergyCountry
	@Id AS INT 	--The Id of the selected Country
AS
	--If @Id has the value -1, it will return all Countries
	SELECT 	
		C.Code		AS 'Code',
		C.[Name]	AS 'Name',
		R.[Name]	AS 'RegionName',
		CR.[Name]	AS 'CurrencyName',
		C.[Id]		AS 'Id',
		C.IdRegion	AS 'IdRegion',
		C.IdCurrency	AS 'IdCurrency',
		C.Email		AS 'Email'
	FROM COUNTRIES AS C(nolock)
	INNER JOIN CURRENCIES AS CR(nolock)
		ON C.IdCurrency = CR.[Id]
	INNER JOIN REGIONS AS R(nolock)
		ON C.IdRegion = R.[Id]
	WHERE C.Id = CASE @Id WHEN -1 THEN C.Id ELSE @Id END
	ORDER BY C.Rank
GO

