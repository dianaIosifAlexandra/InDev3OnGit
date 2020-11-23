--Drops the Procedure catDeleteProject if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteProject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteProject
GO
CREATE PROCEDURE catDeleteProject
	@Id AS INT 	--The Id of the selected Project
AS
DECLARE @Rowcount 	INT,
	@CountDep 	INT,
	@ChildName	VARCHAR(50),
	@MasterName	VARCHAR(50),
	@ErrorMessage	VARCHAR(255)

	SET @ChildName	= 'Project'
	SET @MasterName = 'Work package'

	SELECT 	@CountDep = WP.IdProject
	FROM WORK_PACKAGES AS WP
	WHERE WP.IdProject = @Id
	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	SET @ChildName	= 'Project'
	SET @MasterName = 'Core Team'

	SELECT 	@CountDep = PCT.IdProject
	FROM PROJECT_CORE_TEAMS AS PCT
	WHERE PCT.IdProject = @Id
	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END	


	DELETE FROM PROJECTS
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

