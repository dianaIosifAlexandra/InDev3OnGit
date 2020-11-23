--Drops the Procedure catDeleteOwner if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteOwner]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteOwner
GO
CREATE PROCEDURE catDeleteOwner
	@Id AS INT 	--The Id of the selected Owner
AS
DECLARE @Rowcount 	INT,
	@CountDep 	INT,
	@ChildName	VARCHAR(50),
	@MasterName	VARCHAR(50),
	@ErrorMessage	VARCHAR(255)

	SET @ChildName	= 'Owner'
	SET @MasterName = 'Programs'

	SELECT 	@CountDep = P.IdOwner
	FROM PROGRAMS AS P
	WHERE P.IdOwner = @Id
	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	DECLARE @Rank INT
	SELECT @Rank = Rank from OWNERS WHERE [ID] = @Id	

	DELETE FROM OWNERS
	WHERE [Id] = @Id
	SET @Rowcount = @@ROWCOUNT

	exec catUpdateCatalogRank 'OWNERS', @Rank, 0, NULL

	RETURN @Rowcount
GO

