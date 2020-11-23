--Drops the Procedure bgtDeleteWPTimingAndInterco if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtDeleteWPTimingAndInterco]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtDeleteWPTimingAndInterco
GO
CREATE PROCEDURE bgtDeleteWPTimingAndInterco
	@IdProject	AS INT, --The Id representing the Project connected to the selected Work Package
	@IdPhase	AS INT,	--The Id representing the Phase connected to the selected Work Package
	@Id 		AS INT 	--The Id of the selected Work Package
AS
	DECLARE @Rowcount 	INT,
	@ErrorMessage		VARCHAR(255),
	@MasterName  		VARCHAR(100),
	@ChildName		VARCHAR(100),	
	@ValidationResult	INT

	
	Select @ValidationResult = ValidationResult,
	       @ErrorMessage = ErrorMessage
	from fnCheckWPHasBudgetData(@IdProject, @IdPhase, @Id)

	if (@ValidationResult < 0)
	begin
	 	RAISERROR(@ErrorMessage, 16, 1)
		RETURN -1
	end


	--DELETE first all entries in interco table
	DELETE FROM PROJECTS_INTERCO
	WHERE 	(IdProject = @IdProject) AND
		(IdPhase = @IdPhase) AND
		(IdWorkPackage = @Id)
	SET @Rowcount = @@ROWCOUNT

	IF @Rowcount=0
	BEGIN
		SET @ErrorMessage = 'Key information about at least one of project''s WPs was changed by another user. Please refresh your information.'	
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN -2
	END

	UPDATE WORK_PACKAGES
	SET
		StartYearMonth = NULL,
		EndYearMonth = NULL
	WHERE 	IdProject = @IdProject AND
		IdPhase = @IdPhase AND
		[Id] = @Id
	SET @Rowcount = @@ROWCOUNT
	
	
	
	RETURN @Rowcount
GO

