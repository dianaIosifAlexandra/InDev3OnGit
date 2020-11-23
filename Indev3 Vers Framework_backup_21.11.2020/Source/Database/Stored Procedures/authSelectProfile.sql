--Drops the Procedure bgtSelectProfile if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authSelectProfile]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authSelectProfile
GO
CREATE PROCEDURE authSelectProfile
AS
	--This procedure will return all associates and roles from ASSOCIATE_ROLES table
		SELECT 	A.[Name]	AS 'Associate',
			C.[Name]	AS 'Country',
			A.[InergyLogin] AS 'Inergy Login',
			CASE WHEN (R.[Name] IS NULL) THEN '-' ELSE R.[Name] END AS 'Role'
		FROM ASSOCIATE_ROLES AS AR
		RIGHT JOIN ASSOCIATES AS A
		ON AR.IdAssociate = A.[Id]
		LEFT JOIN ROLES AS R
		ON AR.IdRole = R.[Id]
		LEFT JOIN COUNTRIES C
		ON A.IdCountry = C.Id
		WHERE A.[Id] > 0
		ORDER BY A.[Name]
GO

