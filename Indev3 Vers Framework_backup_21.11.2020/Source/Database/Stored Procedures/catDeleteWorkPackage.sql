--Drops the Procedure catDeleteWorkPackage if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteWorkPackage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteWorkPackage
GO
CREATE PROCEDURE catDeleteWorkPackage
	@IdProject	AS INT, --The Id representing the Project connected to the selected Work Package
	@IdPhase	AS INT,	--The Id representing the Phase connected to the selected Work Package
	@Id 		AS INT 	--The Id of the selected Work Package
AS


DECLARE @Rowcount 	INT,
	@CountInterco 	INT,
	@ChildName	VARCHAR(50),
	@MasterName	VARCHAR(50),
	@ErrorMessage	VARCHAR(255)

	SET @ChildName	= 'Projects Interco'
	SET @MasterName = 'Work packages'
	
	SELECT 	@CountInterco = COUNT([PI].IdCountry)
	FROM PROJECTS_INTERCO AS [PI]
	WHERE 	([PI].IdProject = @IdProject) AND
		([PI].IdPhase = @IdPhase) AND
		([PI].IdWorkPackage = @Id)
		
	IF (@CountInterco > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @MasterName,@Parameter2 = @ChildName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	DECLARE @WPName VARCHAR(34)

	IF 
	(
		EXISTS
		(
			SELECT 	IdProject
			FROM 	ACTUAL_DATA_DETAILS_HOURS
			WHERE 	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @Id
		)
		OR
		EXISTS
		(
			SELECT 	IdProject
			FROM 	ACTUAL_DATA_DETAILS_SALES
			WHERE 	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @Id
		)
		OR
		EXISTS
		(
			SELECT 	IdProject
			FROM 	ACTUAL_DATA_DETAILS_COSTS
			WHERE 	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @Id
		)
	)
	BEGIN
		SELECT 	@WPName = WP.Code + '-' + WP.Name
		FROM 	WORK_PACKAGES WP
		WHERE 	WP.IdProject = @IdProject AND
			WP.IdPhase = @IdPhase AND
			WP.Id = @Id
		RAISERROR('Work package %s cannot be deleted because it has existing actual data.', 16, 1, @WPName)
		RETURN -2
	END

	IF 
	(
		EXISTS
		(
			SELECT 	IdProject
			FROM 	ANNUAL_BUDGET_DATA_DETAILS_HOURS
			WHERE 	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @Id
		)
		OR
		EXISTS
		(
			SELECT 	IdProject
			FROM 	ANNUAL_BUDGET_DATA_DETAILS_SALES
			WHERE 	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @Id
		)
		OR
		EXISTS
		(
			SELECT 	IdProject
			FROM 	ANNUAL_BUDGET_DATA_DETAILS_COSTS
			WHERE 	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @Id
		)
	)
	BEGIN
		SELECT 	@WPName = WP.Code + '-' + WP.Name
		FROM 	WORK_PACKAGES WP
		WHERE 	WP.IdProject = @IdProject AND
			WP.IdPhase = @IdPhase AND
			WP.Id = @Id
		RAISERROR('Work package %s cannot be deleted because it is used in annual budget.', 16, 1, @WPName)
		RETURN -3
	END

	DECLARE @Rank INT
	SELECT @Rank = Rank from WORK_PACKAGES WHERE [IdProject] = @IdProject AND IdPhase = @IdPhase AND [ID] = @Id

	DELETE FROM WORK_PACKAGES
	WHERE 	IdProject = @IdProject AND
		IdPhase = @IdPhase AND
		[Id] = @Id
	SET @Rowcount = @@ROWCOUNT
	exec catUpdateWorkPackageRank 'WORK_PACKAGES', @Rank, 0, NULL, @IdProject, @IdPhase

	
	RETURN @Rowcount
GO

