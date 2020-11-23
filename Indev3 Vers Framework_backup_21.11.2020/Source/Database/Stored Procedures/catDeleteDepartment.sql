--Drops the Procedure catDeleteDepartment if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteDepartment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteDepartment
GO
CREATE PROCEDURE catDeleteDepartment
	@Id AS INT 	--The Id of the selected Department
AS
DECLARE @Rowcount 	INT,
	@CountDep 	INT,
	@ChildName	VARCHAR(50),
	@MasterName	VARCHAR(50),
	@ErrorMessage	VARCHAR(255)

	SET @ChildName	= 'Department'
	SET @MasterName = 'Cost Center'

	SELECT 	@CountDep = CC.IdDepartment
	FROM COST_CENTERS AS CC
	WHERE CC.IdDepartment = @Id
	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	DECLARE @Rank INT
	SELECT @Rank = Rank from DEPARTMENTS WHERE [ID] = @Id

	DELETE FROM DEPARTMENTS
	WHERE [Id] = @Id
	SET @Rowcount = @@ROWCOUNT

	exec catUpdateCatalogRank 'DEPARTMENTS', @Rank, 0, NULL

	RETURN @Rowcount
GO

