--Drops the Procedure catDeleteInergyLocation if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteInergyLocation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteInergyLocation
GO
CREATE PROCEDURE catDeleteInergyLocation
	@Id AS INT 	--The Id of the selected Inergy Location
AS
DECLARE @Rowcount 	INT,
	@CountDep 	INT,
	@ChildName	VARCHAR(50),
	@MasterName	VARCHAR(50),
	@ErrorMessage	VARCHAR(255)

	SET @ChildName	= 'Inergy location'
	SET @MasterName = 'Cost Center'

	SELECT 	@CountDep = CC.IdInergyLocation
	FROM COST_CENTERS AS CC
	WHERE CC.IdInergyLocation = @Id
	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	DECLARE @Rank INT
	SELECT @Rank = Rank from INERGY_LOCATIONS WHERE [ID] = @Id

	DELETE FROM INERGY_LOCATIONS
	WHERE [Id] = @Id
	SET @Rowcount = @@ROWCOUNT
	
	exec catUpdateCatalogRank 'INERGY_LOCATIONS', @Rank, 0, NULL

	RETURN @Rowcount
GO

