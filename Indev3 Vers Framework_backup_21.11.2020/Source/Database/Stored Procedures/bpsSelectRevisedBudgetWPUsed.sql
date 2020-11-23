--Drops the Procedure bgtSelectWPPreselectionUsed if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bpsSelectRevisedBudgetWPUsed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bpsSelectRevisedBudgetWPUsed
GO
CREATE PROCEDURE bpsSelectRevisedBudgetWPUsed
	@IdProject 			AS INT, 	--The Id of the Project
	@BudgetVersion		AS CHAR(1),	-- @BudgetVersion will be 'P', 'C' or 'N'
	@IdAssociate 		AS INT,
	@ActiveState		AS CHAR(1)
AS
BEGIN

	DECLARE @BudgetGeneration INT

	IF (@BudgetVersion <> 'N')
	BEGIN
		SET @BudgetGeneration = dbo.fnGetRevisedBudgetGeneration (@IdProject, @BudgetVersion)
	END
	ELSE
	BEGIN
		SELECT 	@BudgetGeneration = MAX(IdGeneration)
		FROM 	BUDGET_REVISED_STATES BRS
		WHERE 	IdProject = @IdProject AND
			IdAssociate = CASE WHEN @IdAssociate = -1 THEN BRS.IdAssociate
							   ELSE @IdAssociate END AND
			State <> 'V'

		--If no InProgress generation was found, get the Released generation
		IF (@BudgetGeneration IS NULL)
		BEGIN
			SELECT 	@BudgetGeneration = MAX(IdGeneration)
			FROM 	BUDGET_REVISED_STATES BRS
			WHERE 	IdProject = @IdProject AND
				IdAssociate = CASE WHEN @IdAssociate = -1 THEN BRS.IdAssociate
								   ELSE @IdAssociate END AND
				State = 'V'
		END

		--If the budget generation is still null (when no released version exists for the given user, because he
		--was added to the project at this moment and he has no budget whatsoever), get the generation using
		--dbo.fnGetRevisedBudgetGeneration function
		IF (@BudgetGeneration IS NULL)
		BEGIN
			SET @BudgetGeneration = ISNULL(dbo.fnGetRevisedBudgetGeneration (@IdProject, @BudgetVersion), dbo.fnGetRevisedBudgetGeneration (@IdProject, 'C'))
		END
	END
	
	IF (@BudgetGeneration IS NULL)
	BEGIN
		RAISERROR('Budget version %s does not exist.', 16, 1, @BudgetVersion)
		RETURN
	END

	--Gets the master table for WP Preselection functionality. This table contains only information
	-- about the phases of the active work packages. 
	SELECT DISTINCT
		PH.Id	AS	'IdPhase',
		PH.Code + ' - ' + PH.Name	AS	'PhaseName'
	FROM WORK_PACKAGES AS WP
	INNER JOIN PROJECT_PHASES PH ON WP.IdPhase = PH.Id
	--This join is used to get the phases of the work packages for which data exists in the revised budget
	INNER JOIN BUDGET_REVISED_DETAIL AS BRD ON
		WP.IdProject = BRD.IdProject AND
		WP.IdPhase = BRD.IdPhase AND
		WP.Id = BRD.IdWorkPackage
	LEFT JOIN BUDGET_REVISED_DETAIL_COSTS AS BRDC ON
		BRDC.IdProject = BRD.IdProject AND
		BRDC.IdGeneration = BRD.IdGeneration AND
		BRDC.IdPhase = BRD.IdPhase AND
		BRDC.IdWorkPackage = BRD.IdWorkPackage AND
		BRDC.IdCostCenter = BRD.IdCostCenter AND
		BRDC.IdAssociate = BRD.IdAssociate AND
		BRDC.YearMonth = BRD.YearMonth
	WHERE 	WP.IdProject = @IdProject AND
			WP.IsActive = CASE 	WHEN @ActiveState = 'A' THEN 1
								WHEN @ActiveState = 'I' THEN 0
								WHEN @ActiveState = 'L' THEN WP.IsActive END AND
			BRD.IdGeneration = @BudgetGeneration  AND
			BRD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BRD.IdAssociate
									ELSE @IdAssociate END 

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
		CAST (1 AS BIT)		AS 	'HasBudget',
		CAST (0 AS BIT) 	AS 	'HasActualOrRevisedData'
	FROM WORK_PACKAGES AS WP
	INNER JOIN PROJECT_PHASES PH
		ON WP.IdPhase = PH.Id
	INNER JOIN BUDGET_REVISED_DETAIL AS BRD ON --This join is used to get the work packages for which data exists in the revised budget
		WP.IdProject = BRD.IdProject AND
		WP.IdPhase = BRD.IdPhase AND
		WP.Id = BRD.IdWorkPackage
	LEFT JOIN BUDGET_REVISED_DETAIL_COSTS AS BRDC ON
		BRDC.IdProject = BRD.IdProject AND
		BRDC.IdGeneration = BRD.IdGeneration AND
		BRDC.IdPhase = BRD.IdPhase AND
		BRDC.IdWorkPackage = BRD.IdWorkPackage AND
		BRDC.IdCostCenter = BRD.IdCostCenter AND
		BRDC.IdAssociate = BRD.IdAssociate AND
		BRDC.YearMonth = BRD.YearMonth
	LEFT JOIN PROJECTS_INTERCO AS PJI
		ON 	PJI.IdProject = WP.IdProject AND
			PJI.IdPhase = WP.IdPhase AND
			PJI.IdWorkPackage = WP.Id
	WHERE 	WP.IdProject = @IdProject AND
			WP.IsActive = CASE WHEN @ActiveState = 'A' THEN 1
								WHEN @ActiveState = 'I' THEN 0
								WHEN @ActiveState = 'L' THEN WP.IsActive END AND
			BRD.IdGeneration = @BudgetGeneration AND
			BRD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BRD.IdAssociate
									ELSE @IdAssociate END 
END
GO

