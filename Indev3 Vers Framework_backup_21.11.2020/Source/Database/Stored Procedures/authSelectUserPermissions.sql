--Drops the Procedure bgtUpdateProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authSelectUserPermissions]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authSelectUserPermissions
GO
CREATE PROCEDURE authSelectUserPermissions
	@IdUser		INT	--The login name used to log into the application
AS
	SELECT 		AROLES.IdRole 		AS 'IdRole',
			ROLES.[Name]		AS 'RoleName'
	FROM		ASSOCIATE_ROLES		AS AROLES
	INNER JOIN	ROLES
	ON		AROLES.IdRole = ROLES.[Id]
	WHERE		AROLES.IdAssociate = @IdUser

	SELECT 		RRIGHTS.[CodeModule]	AS 'ModuleCode',
			RRIGHTS.IdOperation	AS 'IdOperation',
			RRIGHTS.[IdPermission]	AS 'IdPermission'
	FROM		ASSOCIATE_ROLES 	AS AROLES
	INNER JOIN 	ROLE_RIGHTS 		AS RRIGHTS
	ON 		AROLES.IdRole = RRIGHTS.IdRole
	WHERE		AROLES.IdAssociate = @IdUser
GO

