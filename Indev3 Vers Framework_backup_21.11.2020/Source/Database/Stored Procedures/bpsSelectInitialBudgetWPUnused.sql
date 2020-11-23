--Drops the Procedure bpsSelectInitialBudgetWPUnused if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bpsSelectInitialBudgetWPUnused]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bpsSelectInitialBudgetWPUnused
GO
CREATE PROCEDURE bpsSelectInitialBudgetWPUnused
	@IdProject 			AS INT, 	--The Id of the Project
	@BudgetVersion		AS CHAR(1),	-- @BudgetVersion will be 'P', 'C' or 'N' only when coming from Follow-up
	@IdAssociate		AS INT,
	@ActiveState		AS CHAR(1)
AS
BEGIN

	SELECT *
	INTO #TempTableIni
	FROM 
		(SELECT DISTINCT
			WP.IdProject 		AS	'IdProjectT1',
			WP.IdPhase			AS	'IdPhaseT1',
			WP.Id				AS	'IdWPT1',
			WP.Code + ' - ' + WP.Name		AS	'WPNameT1'
		FROM WORK_PACKAGES AS WP
		WHERE WP.IdProject = @IdProject AND
	 		WP.IsActive = CASE 	WHEN @ActiveState = 'A' THEN 1
								WHEN @ActiveState = 'I' THEN 0
								WHEN @ActiveState = 'L' THEN WP.IsActive END
			) AS AllWP
		LEFT JOIN 
		(
		--Gets the detail table for WP Preselection functionality
		SELECT DISTINCT
			WP.IdProject 		AS	'IdProjectT2',
			WP.IdPhase		AS	'IdPhaseT2',
			WP.Id		AS	'IdWPT2',
			WP.Code + ' - ' + WP.Name		AS	'WPNameT2'
		FROM WORK_PACKAGES AS WP
		--This join is used to get the work packages for which data exists in the initial budget
		INNER JOIN BUDGET_INITIAL_DETAIL AS BID ON
			WP.IdProject = BID.IdProject AND
			WP.IdPhase = BID.IdPhase AND
			WP.Id = BID.IdWorkPackage
		WHERE WP.IdProject = @IdProject AND
			WP.IsActive = CASE WHEN @ActiveState = 'A' THEN 1
								WHEN @ActiveState = 'I' THEN 0
								WHEN @ActiveState = 'L' THEN WP.IsActive END
			AND BID.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BID.IdAssociate
								ELSE @IdAssociate END
		) AS UsedWP
	ON 	AllWP.IdProjectT1 = UsedWP.IdProjectT2 AND
		AllWP.IdPhaseT1 = UsedWP.IdPhaseT2 AND
		AllWP.IdWPT1 = UsedWP.IdWPT2

	SELECT	IdProjectT1 AS 'IdProject',
			IdPhaseT1 AS 'IdPhase',
			IdWPT1 AS 'IdWP',
			WPNameT1 AS 'WPName'
	FROM 	#TempTableIni
	WHERE	IdProjectT2 IS NULL AND
			IdPhaseT2 IS NULL AND
			IdWPT2 IS NULL		

END
GO

