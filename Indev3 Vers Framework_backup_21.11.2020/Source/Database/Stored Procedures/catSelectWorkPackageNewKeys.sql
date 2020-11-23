--Drops the Procedure catSelecWorkPackageNewKeys if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectWorkPackageNewKeys]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectWorkPackageNewKeys
GO
CREATE PROCEDURE catSelectWorkPackageNewKeys
	@IdProject	AS INT, --The Id representing the Project connected to the selected Work Package
	@CODE 		AS VARCHAR(3)
AS

--SELECT NEW KEYS AFTER UPDATE PROCEDURE BASED ON UNIQUE CONSTRAINT IdProject, Code
	SELECT 	IdProject,
		IdPhase,
		[Id] as 'Id'
	FROM WORK_PACKAGES
	WHERE IdProject = @IdProject AND
	      Code	= @Code

GO


