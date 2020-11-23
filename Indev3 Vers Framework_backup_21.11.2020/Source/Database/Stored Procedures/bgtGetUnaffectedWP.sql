--Drops the Procedure bgtGetUnaffectedWP if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetUnaffectedWP]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetUnaffectedWP
GO
CREATE PROCEDURE bgtGetUnaffectedWP
	@IdProject 		AS INT 	--The Id of the Project
AS
	--Gets the unaffecte WP. This are the WP that have the StartYearMonth or EndYearMonth null OR
	--do not have any intrco information associated
	SELECT
		WRP.IdProject			AS		'IdProject',
		WRP.IdPhase			AS		'IdPhase',
		WRP.IdWP			AS		'IdWP',
		PH.Code				AS		'PhaseCode',
		WRP.WPCode + ' - ' + WRP.WPName	AS		'WPCode'
	FROM
		(SELECT DISTINCT
			WP.IdProject	AS		'IdProject',
			WP.IdPhase	AS		'IdPhase',
			WP.[Id]		AS		'IdWP',
			WP.Code		AS		'WPCode',
			WP.Name		AS		'WPName'
		FROM WORK_PACKAGES AS WP
		LEFT JOIN PROJECTS_INTERCO AS PI 
			ON PI.IdProject = WP.IdProject AND
			   PI.IdPhase = WP.IdPhase AND
			   PI.IdWorkPackage = WP.Id 
		WHERE WP.IdProject = @IdProject AND
		      WP.IsActive = 1
		GROUP BY WP.IdProject, WP.IdPhase, WP.Id, WP.StartYearMonth, WP.EndYearMonth, WP.Code, WP.Name
		HAVING (COUNT(PI.IdCountry) = 0) OR ((WP.StartYearMonth IS NULL) OR (WP.EndYearMonth IS NULL))
		) AS WRP
	INNER JOIN PROJECT_PHASES AS PH 
		ON WRP.IdPhase = PH.[Id]
	ORDER BY WRP.WPCode ASC
	
GO
