--Drops the Procedure bgtUpdateProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authSelectAssociates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authSelectAssociates
GO
CREATE PROCEDURE authSelectAssociates
AS
	SELECT 	A.[Id]	AS 'Id',
		A.[Name]	AS 'Name',
		A.[InergyLogin] AS 'InergyLogin',
		A.[Name] + ' - '+ C.[Name] AS 'AssociateCountry'
		
	FROM 	ASSOCIATES A
	LEFT JOIN Countries C ON A.[IdCountry] = C.[Id]
	WHERE A.[Id] > 0
	ORDER BY A.[Name]
	
GO

