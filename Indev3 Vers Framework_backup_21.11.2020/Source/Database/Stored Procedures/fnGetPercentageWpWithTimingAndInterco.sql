IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnGetPercentageWpWithTimingAndInterco]'))
	DROP FUNCTION fnGetPercentageWpWithTimingAndInterco
GO

CREATE FUNCTION fnGetPercentageWpWithTimingAndInterco
	( @IdProject INT )

RETURNS INT
AS

BEGIN

DECLARE @ActiveWPs 			INT,
	@ActiveWPsWithTimingInterco 	INT,
	@TimingIntercoPercent 		INT --Percentage of the active WPs that have the Timing & Interco completed
	
	
	SELECT @ActiveWPs = COUNT(*)
	FROM WORK_PACKAGES 
	WHERE IdProject = @IdProject AND 
	      IsActive = 1

	IF (@ActiveWPs = 0)
	RETURN 0

	SELECT @ActiveWPsWithTimingInterco = COUNT(*) 
	FROM WORK_PACKAGES WP
	INNER JOIN 
		(
			SELECT DISTINCT IdProject, IdPhase, IdWorkPackage
			FROM PROJECTS_INTERCO 
			WHERE IdProject = @IdProject
		) P_I
		ON WP.Id = P_I.IdWorkPackage 
		AND WP.IdProject = P_I.IdProject 
		AND WP.IdPhase = P_I.IdPhase
	WHERE WP.IdProject = @IdProject
	AND WP.IsActive = 1
	AND (WP.StartYearMonth IS NOT NULL AND WP.EndYearMonth IS NOT NULL)

	SET @TimingIntercoPercent = round((cast(@ActiveWPsWithTimingInterco as decimal(18,2))/@ActiveWPs)*100 ,0)

	RETURN @TimingIntercoPercent

END
GO

