--Drops the Procedure bgtGetAffectedWPTiming if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetAffectedWPTiming]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetAffectedWPTiming
GO
CREATE PROCEDURE bgtGetAffectedWPTiming
	@IdProject 		AS INT 	--The Id of the Project
AS
	--Get's the master table for the Timing TAB (from GUI). This table contains only information
	-- about the phases. 
	SELECT DISTINCT
		[WP].IdProject	AS	'IdProject',
		[PH].[Id]	AS	'IdPhase',
		[PH].Code	AS	'PhaseCode',
		[PH].[Name]	AS	'PhaseName',
		NULL		AS	'IdWP',
		NULL		AS	'WPCode',
		NULL		AS	'StartYearMonth',
		NULL		AS	'EndYearMonth'
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
	ORDER BY PH.Code	

	CREATE TABLE #TimingTemp
	(
		IdProject	INT,
		IdPhase		INT,
		PhaseCode	VARCHAR(3),
		IdWP		INT,
		WPCode		VARCHAR(3),
		WPName		VARCHAR(30),
		StartYearMonth	INT,
		EndYearMonth	INT,
		LastUserUpdate	VARCHAR(50),
		LastUpdate	DATETIME,
		HasBudget	BIT DEFAULT 0
		PRIMARY KEY (IdProject,IdPhase,IdWP)
	)

	INSERT INTO #TimingTemp  (IdProject, IdPhase, PhaseCode,IdWP,WPCode,WPName,StartYearMonth,EndYearMonth,LastUserUpdate, LastUpdate)
	--Gets the detail table for Timing functionality
	SELECT DISTINCT
		[WP].IdProject 		AS	'IdProject',
		[WP].IdPhase		AS	'IdPhase',
		[PH].Code		AS	'PhaseCode',
		[WP].[Id]		AS	'IdWP',
		WP.Code			AS	'WPCode',
		WP.[Name]		AS	'WPName',
		WP.StartYearMonth	AS	'StartYearMonth',
		WP.EndYearMonth		AS	'EndYearMonth',
		ASOC.[Name]		AS	'LastUserUpdate',
		WP.LastUpdate		AS	'LastUpdate'
	FROM WORK_PACKAGES AS WP
	INNER JOIN PROJECT_PHASES PH ON WP.IdPhase = PH.[Id]
	--The following join is used to get only the WP that have interco information
	INNER JOIN PROJECTS_INTERCO AS [PI] ON 	([PI].IdProject = WP.IdProject) AND
						([PI].IdPhase = WP.IdPhase) AND
						([PI].IdWorkPackage = WP.[Id])
	INNER JOIN ASSOCIATES AS ASOC ON ASOC.[Id] = WP.LastUserUpdate 
	WHERE 	(WP.IdProject = @IdProject) AND
		--The following condition is used to get only the WP that have timing information
		((WP.StartYearMonth IS NOT NULL) AND (WP.EndYearMonth IS NOT NULL)
		AND WP.IsActive = 1)	
	ORDER BY PH.Code, WP.Code

	UPDATE #TimingTemp 
	SET HasBudget = 1
	WHERE EXISTS
	(
		SELECT TOP 1 IdWorkPackage FROM BUDGET_INITIAL_DETAIL AS BID
		WHERE  	BID.IdProject = #TimingTemp.IdProject AND
			BID.IdPhase = #TimingTemp.IdPhase AND
			BID.IdWorkPackage = #TimingTemp.IdWP
	)

	UPDATE #TimingTemp 
	SET HasBudget = 1
	WHERE EXISTS
	(
		SELECT TOP 1 IdWorkPackage FROM BUDGET_REVISED_DETAIL AS BRD
		WHERE  	BRD.IdProject = #TimingTemp.IdProject AND
			BRD.IdPhase = #TimingTemp.IdPhase AND
			BRD.IdWorkPackage = #TimingTemp.IdWP
	)
	
	UPDATE #TimingTemp 
	SET HasBudget = 1
	WHERE EXISTS
	(
		SELECT TOP 1 IdWorkPackage FROM BUDGET_TOCOMPLETION_DETAIL AS BTD
		WHERE  	BTD.IdProject = #TimingTemp.IdProject AND
			BTD.IdPhase = #TimingTemp.IdPhase AND
			BTD.IdWorkPackage = #TimingTemp.IdWP
	)


	SELECT 
		IdProject 		AS	'IdProject',
		IdPhase			AS	'IdPhase',
		PhaseCode		AS	'PhaseCode',
		IdWP			AS	'IdWP',
		WPCode			AS	'WPCode',
		WPName			AS	'WPName',
		StartYearMonth		AS	'StartYearMonth',
		EndYearMonth		AS	'EndYearMonth',
		LastUserUpdate		AS	'LastUserUpdate',
		LastUpdate		AS	'LastUpdate',
		HasBudget		As	'HasBudget'
	FROM #TimingTemp

	
GO

