--Drops the Procedure bgtUpdateProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authSelectUserCountries]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authSelectUserCountries
GO
CREATE PROCEDURE authSelectUserCountries
	@InergyLogin	VARCHAR(50)
AS
	SELECT 	A.IdCountry 	AS 'Id',
		C.[Name]	AS 'Name'
	FROM 	ASSOCIATES AS A
	INNER 	JOIN COUNTRIES AS C
		ON A.IdCountry = C.[Id]
	WHERE	A.InergyLogin = @InergyLogin AND
		A.IsActive = 1
	ORDER BY C.[Name]
GO

