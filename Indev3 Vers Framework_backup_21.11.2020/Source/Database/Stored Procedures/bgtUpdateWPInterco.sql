--Drops the Procedure bgtUpdateWPInterco if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateWPInterco]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateWPInterco
GO
CREATE PROCEDURE bgtUpdateWPInterco
	@IdProject		INT,		
	@IdPhase		INT,		
	@IdWP			INT,	
	@IdCountry		INT,	
	@Percent		DECIMAL(18,2),
	@WPCode			VARCHAR(3)
AS

	DECLARE	@ErrorMessage		VARCHAR(255)

	IF @WPCode IS NOT NULL AND NOT EXISTS(
			SELECT [Id] 
			FROM WORK_PACKAGES
			WHERE IdProject = @IdProject AND			      
			      IdPhase = @IdPhase AND
			      [Id] = @IdWP AND
			      Code = @WpCode
			)
	BEGIN
	SET @ErrorMessage = 'Key information about WP with code ' + @WPCode + '  has been changed by another user. Please refresh your information.'
	RAISERROR(@ErrorMessage, 16, 1)
		RETURN -1
	END

	DECLARE @CurrentPercent DECIMAL
	SET @CurrentPercent = NULL

	SELECT
		@CurrentPercent = PercentAffected
	FROM PROJECTS_INTERCO
	WHERE 	IdProject= @IdProject AND
		IdPhase = @IdPhase AND
		[IdWorkPackage] = @IdWP AND
		IdCountry = @IdCountry
	
	IF (@CurrentPercent IS NULL) 
	BEGIN
		INSERT INTO PROJECTS_INTERCO 
			(IdProject,  IdPhase,  IdWorkPackage, IdCountry, PercentAffected,LastUpdate)
		VALUES	(@IdProject, @IdPhase, @IdWP,	     @IdCountry, @Percent,       GETDATE())
	END
	ELSE
	BEGIN
		IF (@Percent > 0)
		BEGIN
			UPDATE PROJECTS_INTERCO
			SET
				PercentAffected = @Percent
			WHERE 	IdProject= @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @IdWP AND
				IdCountry = @IdCountry
		END
		ELSE
		BEGIN
			DELETE FROM PROJECTS_INTERCO
			WHERE 	IdProject= @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @IdWP AND
				IdCountry = @IdCountry
		END
	END	
GO
