--Drops the Procedure catDeleteRegion if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteRegion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteRegion
GO
CREATE PROCEDURE catDeleteRegion
	@Id AS INT 	--The Id of the selected Region
AS
DECLARE @Rowcount 	INT,
	@CountDep 	INT,
	@ChildName	VARCHAR(50),
	@MasterName	VARCHAR(50),
	@ErrorMessage	VARCHAR(255)

	SET @ChildName	= 'Region'
	SET @MasterName = 'Country'

	SELECT 	@CountDep = C.IdRegion
	FROM COUNTRIES AS C
	WHERE C.IdRegion = @Id
	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END
	
	DECLARE @Rank INT
	SELECT @Rank = Rank from REGIONS WHERE [ID] = @Id	

	DELETE FROM REGIONS
	WHERE [Id] = @Id
	SET @Rowcount = @@ROWCOUNT

	exec catUpdateCatalogRank 'Regions', @Rank, 0, NULL

	RETURN @Rowcount
GO

