--Drops the Procedure bpsSelectInitialBudgetWPUsed if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bpsSelectInitialBudgetWPUsed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bpsSelectInitialBudgetWPUsed
GO
CREATE PROCEDURE bpsSelectInitialBudgetWPUsed
	@IdProject 			AS INT, 	--The Id of the Project
	@BudgetVersion		AS CHAR(1),	-- @BudgetVersion will be 'P', 'C' or 'N'
	@IdAssociate 		AS INT,		
	@ActiveState		AS CHAR(1)
AS
BEGIN
	
	--Gets the master table for WP Preselection functionality. This table contains only information
	-- about the phases. 
	SELECT DISTINCT
		PH.Id						AS	'IdPhase',
		PH.Code + ' - ' + PH.Name	AS	'PhaseName'
	FROM WORK_PACKAGES AS WP
	INNER JOIN PROJECT_PHASES PH ON WP.IdPhase = PH.Id
	--This join is used to get the phases of the work packages for which data exists in the initial budget
	INNER JOIN BUDGET_INITIAL_DETAIL AS BID ON
		WP.IdProject = BID.IdProject AND
		WP.IdPhase = BID.IdPhase AND
		WP.Id = BID.IdWorkPackage
	WHERE WP.IdProject = @IdProject AND
		WP.IsActive = CASE WHEN @ActiveState = 'A' THEN	1
							WHEN @ActiveState = 'I' THEN 0
							WHEN @ActiveState = 'L' THEN WP.IsActive END AND
		BID.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BID.IdAssociate
						  ELSE @IdAssociate END
	

	--Gets the detail table for WP Preselection functionality
	SELECT DISTINCT
		WP.IdProject 		AS	'IdProject',
		WP.IdPhase		AS	'IdPhase',
		PH.Name		AS	'PhaseName',
		WP.Id		AS	'IdWP',
		WP.Code + ' - ' + WP.Name		AS	'WPName',
		WP.StartYearMonth	AS	'StartYearMonth',
		WP.EndYearMonth	AS	'EndYearMonth',
		WP.IsActive 		AS 	'IsActive',
		CAST (CASE WHEN (PJI.PercentAffected IS NOT NULL AND
						 WP.StartYearMonth IS NOT NULL AND
						 WP.EndYearMonth IS NOT NULL) THEN 1
				   ELSE 0 END AS BIT) AS	'HasPeriodAndInterco',
		CAST (1 AS BIT)			AS 	'HasBudget',
		CAST (0 AS BIT) 		AS 	'HasActualOrRevisedData'
	FROM WORK_PACKAGES AS WP
	INNER JOIN PROJECT_PHASES PH ON WP.IdPhase = PH.Id
	--This join is used to get the work packages for which data exists in the initial budget
	INNER JOIN BUDGET_INITIAL_DETAIL AS BID ON
		WP.IdProject = BID.IdProject AND
		WP.IdPhase = BID.IdPhase AND
		WP.Id = BID.IdWorkPackage
	LEFT JOIN PROJECTS_INTERCO AS PJI 
		ON 	PJI.IdProject = WP.IdProject AND
			PJI.IdPhase = WP.IdPhase AND
			PJI.IdWorkPackage = WP.Id
	WHERE WP.IdProject = @IdProject AND
		WP.IsActive = CASE WHEN @ActiveState = 'A' THEN	1
							WHEN @ActiveState = 'I' THEN 0
							WHEN @ActiveState = 'L' THEN WP.IsActive END AND
		BID.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BID.IdAssociate
								ELSE @IdAssociate END

END
GO

