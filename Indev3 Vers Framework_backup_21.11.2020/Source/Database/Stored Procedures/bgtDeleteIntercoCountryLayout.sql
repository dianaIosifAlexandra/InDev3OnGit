--Drops the Procedure bgtDeleteIntercoCountryLayout if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtDeleteIntercoCountryLayout]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtDeleteIntercoCountryLayout
GO
CREATE PROCEDURE bgtDeleteIntercoCountryLayout
	@IdProject		INT	
AS
	DELETE FROM PROJECTS_INTERCO_LAYOUT
	WHERE 	IdProject = @IdProject AND
		IdCountry IN
	(
		SELECT DISTINCT
			PIL.IdCountry		AS	'IdCountry'
		FROM PROJECTS_INTERCO AS [PI]
		INNER JOIN PROJECTS_INTERCO_LAYOUT PIL ON
			[PI].IdProject = PIL.IdProject AND
			[PI].IdCountry = PIL.IdCountry
		INNER JOIN WORK_PACKAGES AS WP ON 	[PI].IdWorkPackage = WP.[Id] AND
							[PI].IdProject = WP.IdProject AND
							[PI].IdPhase = WP.IdPhase
		
		WHERE 	([PI].IdProject = @IdProject) AND
		--The following condition is used to get only the WP that have timing information
			((WP.StartYearMonth IS NOT NULL) AND (WP.EndYearMonth IS NOT NULL)) AND
			([PI].PercentAffected > 0) AND WP.IsActive = 1
	)
GO

