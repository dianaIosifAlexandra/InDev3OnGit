--Drops the Procedure bgtUpdateProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authSelectUserProjects]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authSelectUserProjects
GO
CREATE PROCEDURE authSelectUserProjects
	@IdUser		INT	--The login name used to log into the application
AS
	SELECT 	P.Id 		AS 'IdProject',
		P.Name		AS 'ProjectName',
		PCT.IdFunction	AS 'IdFunction',
		PF.Name		AS 'ProjectFunction'
	FROM PROJECTS P (nolock)
	INNER JOIN PROJECT_CORE_TEAMS PCT
		ON P.Id = PCT.IdProject
	INNER JOIN ASSOCIATES A
		ON PCT.IdAssociate = A.[Id]
	INNER JOIN PROJECT_FUNCTIONS PF
		ON PCT.IdFunction = PF.[Id]
	WHERE A.Id = @IdUser AND
	      PCT.IsActive = 1
GO

