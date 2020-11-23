--Drops the Procedure catDeleteProgram if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteProgram]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteProgram
GO
CREATE PROCEDURE catDeleteProgram
	@Id AS INT 	--The Id of the selected Program
AS
DECLARE @Rowcount 	INT,
	@CountDep 	INT,
	@ChildName	VARCHAR(50),
	@MasterName	VARCHAR(50),
	@ErrorMessage	VARCHAR(255)

	SET @ChildName	= 'Program'
	SET @MasterName = 'Project'

	SELECT 	@CountDep = P.IdProgram
	FROM PROJECTS AS P
	WHERE P.IdProgram = @Id
	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	DECLARE @Rank INT
	SELECT @Rank = Rank from PROGRAMS WHERE [ID] = @Id	

	DELETE FROM PROGRAMS
	WHERE [Id] = @Id
	SET @Rowcount = @@ROWCOUNT

	exec catUpdateCatalogRank 'PROGRAMS', @Rank, 0, NULL

	RETURN @Rowcount
GO

