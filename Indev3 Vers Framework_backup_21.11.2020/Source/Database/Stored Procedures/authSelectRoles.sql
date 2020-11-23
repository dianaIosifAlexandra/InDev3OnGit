--Drops the Procedure bgtUpdateProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authSelectRoles]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authSelectRoles
GO
CREATE PROCEDURE authSelectRoles
	@IdAssociate		INT	--The login name used to log into the application
AS
	IF (@IdAssociate = -1)
	BEGIN
		SELECT 	[Id]	AS 'Id',
			[Name]	AS 'Name'
		FROM 	ROLES
		WHERE 	[Id] IN (1,2,3,6,8)	-- do not select Program Manger or Core team member roles but select Functional Manager
	END
	ELSE
	BEGIN
		SELECT 	[Id]	AS 'Id',
			[Name]	AS 'Name'
		FROM 	ROLES
		INNER JOIN ASSOCIATE_ROLES 
			ON 	ROLES.[Id] = ASSOCIATE_ROLES.IdRole AND
				ASSOCIATE_ROLES.IdAssociate = @IdAssociate
	END

GO


