--Drops the Procedure bgtUpdateProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authSelectRolePermissions]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authSelectRolePermissions
GO
CREATE PROCEDURE authSelectRolePermissions
	@IdRole		INT	--The login name used to log into the application
AS
	SELECT 	RRIGHTS.[CodeModule]	AS 'ModuleCode',
		RRIGHTS.IdOperation	AS 'IdOperation',
		RRIGHTS.[IdPermission]	AS 'IdPermission'
	FROM 	ROLE_RIGHTS 		AS RRIGHTS
	WHERE	RRIGHTS.IdRole = @IdRole
GO

