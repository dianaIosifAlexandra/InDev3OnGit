--Drops the Procedure bgtGetAffectedWPInterco if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetAffectedWPInterco]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetAffectedWPInterco
GO
CREATE PROCEDURE bgtGetAffectedWPInterco
	@IdProject 		AS INT 	--The Id of the Project
AS
	--TODO: Remove null values
	--Get's the master table for the Period TAB (from GUI). This table contains only information
	-- about the phases. 
	SELECT DISTINCT
		NULL 		AS	'IdProject',
		[PH].[Id]	AS	'IdPhase',
		[PH].Code	AS	'PhaseCode',
		[PH].[Name]	AS	'PhaseName',
		NULL		AS	'IdWP',
		NULL		AS	'WPCode'
	FROM WORK_PACKAGES AS WP
	INNER JOIN PROJECT_PHASES PH ON WP.IdPhase = PH.[Id]
	--The following join is used to get only the WP that have interco information
	INNER JOIN PROJECTS_INTERCO AS [PI] ON 	([PI].IdProject = WP.IdProject) AND
						([PI].IdPhase = WP.IdPhase) AND
						([PI].IdWorkPackage = WP.[Id]) 
	WHERE 	(WP.IdProject = @IdProject) AND
	--The following condition is used to get only the WP that have timing information
		((WP.StartYearMonth IS NOT NULL) AND (WP.EndYearMonth IS NOT NULL)
		AND WP.IsActive = 1)
	ORDER BY [PH].Code	

	CREATE TABLE #IntercoTemp
	(
		IdProject	INT,
		IdPhase		INT,
		IdWP		INT,
		WPCode		VARCHAR(3),
		WPName		VARCHAR(30),
		PhaseCode	VARCHAR(3),
		HasBudget	BIT DEFAULT 0
		PRIMARY KEY (IdProject,IdPhase,IdWP)
	)

	--Get's the base structure of the detail table. This table will have additional columns build
	--on server from the third recordset returned by this procedure
	INSERT INTO #IntercoTemp  (IdProject, IdPhase, IdWP,WPCode,WPName,PhaseCode)
	SELECT DISTINCT
		[WP].IdProject 		AS	'IdProject',
		[WP].IdPhase		AS	'IdPhase',
		[WP].[Id]		AS	'IdWP',
		[WP].Code 		AS	'WPCode',
		[WP].[Name]		AS	'WPName',
		[PH].Code		AS	'PhaseCode'
	FROM WORK_PACKAGES AS WP
	INNER JOIN PROJECT_PHASES PH ON WP.IdPhase = PH.[Id]
	--The following join is used to get only the WP that have interco information
	INNER JOIN PROJECTS_INTERCO AS [PI] ON 	([PI].IdProject = WP.IdProject) AND
						([PI].IdPhase = WP.IdPhase) AND
						([PI].IdWorkPackage = WP.[Id]) 
	WHERE 	(WP.IdProject = @IdProject) AND
		--The following condition is used to get only the WP that have timing information
		((WP.StartYearMonth IS NOT NULL) AND (WP.EndYearMonth IS NOT NULL)
		AND WP.IsActive = 1)	
	--DO NOT modify this ORDER BY as it is used in the upper layers
	ORDER BY PH.[Code], WP.[Id]
	
	UPDATE #IntercoTemp 
	SET HasBudget = 1
	WHERE EXISTS
	(
		SELECT TOP 1 IdWorkPackage FROM BUDGET_INITIAL_DETAIL AS BID
		WHERE  	BID.IdProject = #IntercoTemp.IdProject AND
			BID.IdPhase = #IntercoTemp.IdPhase AND
			BID.IdWorkPackage = #IntercoTemp.IdWP
	)

	UPDATE #IntercoTemp 
	SET HasBudget = 1
	WHERE EXISTS
	(
		SELECT TOP 1 IdWorkPackage FROM BUDGET_REVISED_DETAIL AS BRD
		WHERE  	BRD.IdProject = #IntercoTemp.IdProject AND
			BRD.IdPhase = #IntercoTemp.IdPhase AND
			BRD.IdWorkPackage = #IntercoTemp.IdWP
	)
	
	UPDATE #IntercoTemp 
	SET HasBudget = 1
	WHERE EXISTS
	(
		SELECT TOP 1 IdWorkPackage FROM BUDGET_TOCOMPLETION_DETAIL AS BTD
		WHERE  	BTD.IdProject = #IntercoTemp.IdProject AND
			BTD.IdPhase = #IntercoTemp.IdPhase AND
			BTD.IdWorkPackage = #IntercoTemp.IdWP
	)

	SELECT 
		IdProject 	AS 	'IdProject',
		IdPhase		AS	'IdPhase',
		IdWP		AS	'IdWP',
		WPCode		AS	'WPCode',
		WPName		AS	'WPName',
		PhaseCode	AS	'PhaseCode',
		HasBudget	AS	'HasBudget'
	FROM #IntercoTemp

	--Get's the data from the PROJECTS_INTERCO table needed to create the additional columns for
	--for the detail table
	SELECT
		[PI].IdProject		AS	'IdProject',
		[PI].IdPhase		AS	'IdPhase',
		[PP].Code		AS	'PhaseName',
		[PI].IdWorkPackage	AS	'IdWP',
		[WP].Code		AS	'WPName',
		[PI].IdCountry		AS	'IdCountry',
		[PI].PercentAffected	AS	'Percent'
	FROM PROJECTS_INTERCO AS [PI]
	INNER JOIN PROJECT_PHASES AS PP ON [PI].IdPhase = PP.[Id]
	INNER JOIN WORK_PACKAGES AS WP ON 	[PI].IdWorkPackage = WP.[Id] AND
						[PI].IdProject = WP.IdProject AND
						[PI].IdPhase = WP.IdPhase
	WHERE 	([PI].IdProject = @IdProject) AND
	--The following condition is used to get only the WP that have timing information
		((WP.StartYearMonth IS NOT NULL) AND (WP.EndYearMonth IS NOT NULL)) AND
		([PI].PercentAffected > 0) AND WP.IsActive = 1
	--DO NOT modify this ORDER BY as it is used in the upper layers
	ORDER BY [PI].IdPhase, [PI].IdWorkPackage
GO

