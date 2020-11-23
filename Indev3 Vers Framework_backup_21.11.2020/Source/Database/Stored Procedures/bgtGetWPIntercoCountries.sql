--Drops the Procedure catSelectAssociate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetWPIntercoCountries]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetWPIntercoCountries
GO
CREATE PROCEDURE bgtGetWPIntercoCountries
	@IdProject 		AS INT 	--The Id of the selected Associate
AS
	SELECT DISTINCT
		PIL.IdProject 		AS	'IdProject',
		PIL.IdCountry		AS	'IdCountry',
		C.Name 			AS	'CountryName',
		PIL.Position		AS	'Position'
	FROM PROJECTS_INTERCO AS [PI]
	INNER JOIN PROJECTS_INTERCO_LAYOUT PIL ON
		[PI].IdProject = PIL.IdProject AND
		[PI].IdCountry = PIL.IdCountry
	INNER JOIN COUNTRIES AS C ON C.[Id] = [PIL].IdCountry
	INNER JOIN WORK_PACKAGES AS WP ON 	[PI].IdWorkPackage = WP.[Id] AND
						[PI].IdProject = WP.IdProject AND
						[PI].IdPhase = WP.IdPhase
	
	WHERE 	([PI].IdProject = @IdProject) AND
	--The following condition is used to get only the WP that have timing information
		((WP.StartYearMonth IS NOT NULL) AND (WP.EndYearMonth IS NOT NULL)) AND
		([PI].PercentAffected > 0) AND WP.IsActive = 1
	ORDER BY PIL.Position
GO


