--Drops the Procedure bgtCheckWPPeriod if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtCheckWPPeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtCheckWPPeriod
GO
CREATE PROCEDURE bgtCheckWPPeriod
	@IdProject 		INT,
	@IdPhase		INT,
	@IdWorkPackage		INT,
	@CachedStartYearMonth 	INT,	--The start ym of the work package, as it has been cached in the application
	@CachedEndYearMonth 	INT	--The end ym of the work package, as it has been cached in the application
AS
	DECLARE @NewStartYearMonth INT
	DECLARE @NewEndYearMonth INT

	SELECT 	@NewStartYearMonth = StartYearMonth,
		@NewEndYearMonth = EndYearMonth
	FROM 	WORK_PACKAGES
	WHERE	IdProject = @IdProject AND
		IdPhase = @IdPhase AND
		[Id] = @IdWorkPackage

	--Check if the cached start ym and end ym have changed and show an error message if this is the case
	IF (@NewStartYearMonth <> @CachedStartYearMonth 
		OR @NewStartYearMonth IS NULL 
			OR @NewEndYearMonth <> @CachedEndYearMonth
				OR @NewEndYearMonth IS NULL)
	BEGIN
		RAISERROR('WP check: key information about at least one of project''s WPs was changed by another user. Return to preselection screen and re-select your WPs.', 16, 1)
	END
GO

