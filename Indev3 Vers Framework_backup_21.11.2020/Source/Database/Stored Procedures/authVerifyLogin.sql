--Drops the Procedure bgtUpdateProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authVerifyLogin]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authVerifyLogin
GO
CREATE PROCEDURE authVerifyLogin
	@InergyLogin	VARCHAR(50),	--The login name used to log into the application
	@IdCountry	INT	--If specified, the select statement will include the IdCountry column in the where clause
AS
	SELECT 		A.[Id] 		AS 'IdAssociate',
			A.[Name]	AS 'AssociateName',
			A.IdCountry 	AS 'IdCountry',
			C.[Name] 	AS 'CountryName',
			CUR.Id		AS 'IdCurrency',
			CUR.Code	AS 'CodeCurrency',
			C.Code		AS 'CountryCode'
	FROM		ASSOCIATES 	AS A
	INNER JOIN 	COUNTRIES 	AS C
		ON 	A.IdCountry = C.Id
	INNER JOIN 	CURRENCIES 	AS CUR
		ON 	CUR.Id = C.IdCurrency
	WHERE		InergyLogin = @InergyLogin AND
			IdCountry = CASE WHEN @IdCountry IS NULL THEN IdCountry ELSE @IdCountry END AND
			IsActive = 1
GO

