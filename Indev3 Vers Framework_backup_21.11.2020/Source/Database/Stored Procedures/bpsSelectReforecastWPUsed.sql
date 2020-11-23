--Drops the Procedure bpsSelectReforecastWPUsed if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bpsSelectReforecastWPUsed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bpsSelectReforecastWPUsed
GO
CREATE PROCEDURE bpsSelectReforecastWPUsed
	@IdProject 			AS INT, 	--The Id of the Project
	@BudgetVersion		AS CHAR(1),	-- @BudgetVersion will be 'P', 'C' or 'N'
	@IdAssociate 		AS INT,
	@ActiveState		AS CHAR(1)
AS
BEGIN
	DECLARE @BudgetGeneration INT
	
	IF (@BudgetVersion <> 'N')
	BEGIN
		SET @BudgetGeneration = dbo.fnGetToCompletionBudgetGeneration (@IdProject, @BudgetVersion)
	END
	ELSE
	BEGIN
		SELECT 	@BudgetGeneration = MAX(IdGeneration)
		FROM 	BUDGET_TOCOMPLETION_STATES BTS
		WHERE 	IdProject = @IdProject AND
			IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTS.IdAssociate
							   ELSE @IdAssociate END AND
			State <> 'V'

		--If no InProgress generation was found, get the Released generation
		IF (@BudgetGeneration IS NULL)
		BEGIN
			SELECT 	@BudgetGeneration = MAX(IdGeneration)
			FROM 	BUDGET_TOCOMPLETION_STATES BTS
			WHERE 	IdProject = @IdProject AND
				IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTS.IdAssociate 
								   ELSE @IdAssociate END AND
				State = 'V'
		END
		
		--If the budget generation is still null (when no released version exists for the given user, because he
		--was added to the project at this moment and he has no budget whatsoever), get the generation using
		--dbo.fnGetToCompletionBudgetGeneration function
		IF (@BudgetGeneration IS NULL)
		BEGIN
			SET @BudgetGeneration = ISNULL(dbo.fnGetToCompletionBudgetGeneration (@IdProject, @BudgetVersion), dbo.fnGetToCompletionBudgetGeneration (@IdProject, 'C'))
		END
	END		

	IF (@BudgetGeneration IS NULL)
	BEGIN
		RAISERROR('Budget version %s does not exist.', 16, 1, @BudgetVersion)
		RETURN
	END

	
	DECLARE @RevisedCurrentGeneration INT
	SET @RevisedCurrentGeneration = dbo.fnGetRevisedBudgetGeneration (@IdProject, 'C')
	
	
	SELECT DISTINCT
		PH.Id							AS	'IdPhase',
		PH.Code + ' - ' + PH.Name		AS	'PhaseName'
	FROM WORK_PACKAGES AS WP
	INNER JOIN PROJECT_PHASES PH 
		ON WP.IdPhase = PH.Id
	left JOIN BUDGET_TOCOMPLETION_DETAIL AS BTD ON --This join is used to get the phases of the work packages for which data exists in the revised budget
		WP.IdProject = BTD.IdProject AND
		WP.IdPhase = BTD.IdPhase AND
		WP.Id = BTD.IdWorkPackage
	LEFT JOIN BUDGET_TOCOMPLETION_DETAIL_COSTS AS BTDC ON
		BTDC.IdProject = BTD.IdProject AND
		BTDC.IdGeneration = BTD.IdGeneration AND
		BTDC.IdPhase = BTD.IdPhase AND
		BTDC.IdWorkPackage = BTD.IdWorkPackage AND
		BTDC.IdCostCenter = BTD.IdCostCenter AND
		BTDC.IdAssociate = BTD.IdAssociate AND
		BTDC.YearMonth = BTD.YearMonth
	WHERE 	WP.IdProject = @IdProject AND
			WP.IsActive = CASE WHEN @ActiveState = 'A' THEN	1
								WHEN @ActiveState = 'I' THEN 0
								WHEN @ActiveState = 'L' THEN WP.IsActive END AND
			--BTD.IdGeneration = @BudgetGeneration  AND
			isnull(BTD.IdAssociate,-1) = CASE WHEN @IdAssociate = -1 THEN isnull(BTD.IdAssociate,-1)
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
		CAST (CASE 
			WHEN (PJI.PercentAffected IS NOT NULL AND
						 WP.StartYearMonth IS NOT NULL AND
						 WP.EndYearMonth IS NOT NULL)
			 THEN 1
			ELSE 0		
		END AS BIT)		AS	'HasPeriodAndInterco',
		CAST (1 AS BIT)		AS 	'HasBudget',
		CASE WHEN  (
			EXISTS
			(
				SELECT 	IdProject
				FROM	ACTUAL_DATA_DETAILS_HOURS
				WHERE	IdProject = WP.IdProject AND
					IdPhase = WP.IdPhase AND
					IdWorkPackage = WP.Id
			)
			OR
			EXISTS
			(
				SELECT 	IdProject
				FROM	ACTUAL_DATA_DETAILS_SALES
				WHERE	IdProject = WP.IdProject AND
					IdPhase = WP.IdPhase AND
					IdWorkPackage = WP.Id
			)
			OR
			EXISTS
			(
				SELECT 	IdProject
				FROM	ACTUAL_DATA_DETAILS_COSTS
				WHERE	IdProject = WP.IdProject AND
					IdPhase = WP.IdPhase AND
					IdWorkPackage = WP.Id
			)
			OR
			EXISTS
			(
				SELECT 	IdProject
				FROM 	BUDGET_REVISED_DETAIL
				WHERE	IdProject = WP.IdProject AND
					IdGeneration = @RevisedCurrentGeneration AND
					IdPhase = WP.IdPhase AND
					IdWorkPackage = WP.Id AND
					IdAssociate = @IdAssociate
			)
		)
			THEN 
				CAST (1 AS BIT)
			ELSE
				CAST (0 AS BIT)
			END		 AS 	'HasActualOrRevisedData'
	FROM WORK_PACKAGES AS WP
	INNER JOIN PROJECT_PHASES PH 
		ON WP.IdPhase = PH.Id
	left JOIN BUDGET_TOCOMPLETION_DETAIL AS BTD ON --This join is used to get the work packages for which data exists in the revised budget
		WP.IdProject = BTD.IdProject AND
		WP.IdPhase = BTD.IdPhase AND
		WP.Id = BTD.IdWorkPackage
	LEFT JOIN BUDGET_TOCOMPLETION_DETAIL_COSTS AS BTDC ON
		BTDC.IdProject = BTD.IdProject AND
		BTDC.IdGeneration = BTD.IdGeneration AND
		BTDC.IdPhase = BTD.IdPhase AND
		BTDC.IdWorkPackage = BTD.IdWorkPackage AND
		BTDC.IdCostCenter = BTD.IdCostCenter AND
		BTDC.IdAssociate = BTD.IdAssociate AND
		BTDC.YearMonth = BTD.YearMonth
	LEFT JOIN PROJECTS_INTERCO AS PJI 
		ON 	PJI.IdProject = WP.IdProject AND
			PJI.IdPhase = WP.IdPhase AND
			PJI.IdWorkPackage = WP.Id 
	WHERE 	WP.IdProject = @IdProject AND 
			WP.IsActive = CASE WHEN @ActiveState = 'A' THEN	1
								WHEN @ActiveState = 'I' THEN 0
								WHEN @ActiveState = 'L' THEN WP.IsActive END AND
			--BTD.IdGeneration = @BudgetGeneration AND
			isnull(BTD.IdAssociate,-1) = CASE WHEN @IdAssociate = -1 THEN isnull(BTD.IdAssociate,-1)
									ELSE @IdAssociate END 
END	
GO