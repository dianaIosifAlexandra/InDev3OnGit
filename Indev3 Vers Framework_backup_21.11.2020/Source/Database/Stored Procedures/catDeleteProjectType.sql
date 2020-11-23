--Drops the Procedure catDeleteProjectType if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteProjectType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteProjectType
GO
CREATE PROCEDURE catDeleteProjectType
	@Id AS INT 	--The Id of the selected Project Type
AS
DECLARE @Rowcount 	INT,
	@CountDep 	INT,
	@ChildName	VARCHAR(50),
	@MasterName	VARCHAR(50),
	@ErrorMessage	VARCHAR(255)

	SET @ChildName	= 'Project Type'
	SET @MasterName = 'Project'

	SELECT 	@CountDep = P.IdProjectType
	FROM PROJECTS AS P
	WHERE P.IdProjectType = @Id
	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END
	
	DECLARE @Rank INT
	SELECT @Rank = Rank from PROJECT_TYPES WHERE [ID] = @Id	

	DELETE FROM PROJECT_TYPES
	WHERE [Id] = @Id
	SET @Rowcount = @@ROWCOUNT

	exec catUpdateCatalogRank 'PROJECT_TYPES', @Rank, 0, NULL

	RETURN @Rowcount
GO

