--Drops the Procedure bpsSelectRevisedBudgetWPUnused if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bpsSelectRevisedBudgetWPUnused]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bpsSelectRevisedBudgetWPUnused
GO
CREATE PROCEDURE bpsSelectRevisedBudgetWPUnused
	@IdProject 			AS INT, 	--The Id of the Project
	@BudgetVersion		AS CHAR(1),	-- @BudgetVersion will be 'P', 'C' or 'N' only when coming from Follow-up
	@IdAssociate		AS INT,
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
			IdAssociate = CASE WHEN @IdAssociate = -1 THEN BRS.IdAssociate ELSE @IdAssociate END AND
			State <> 'V'

		--If no new generation was found, get the released generation
		IF (@BudgetGeneration IS NULL)
		BEGIN
			SELECT 	@BudgetGeneration = MAX(IdGeneration)
			FROM 	BUDGET_REVISED_STATES BRS
			WHERE 	IdProject = @IdProject AND
				IdAssociate = CASE WHEN @IdAssociate = -1 THEN BRS.IdAssociate ELSE @IdAssociate END AND
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

	SELECT * INTO #TempTableRev
	FROM 
		(SELECT DISTINCT
			WP.IdProject 			AS	'IdProjectT1',
			WP.IdPhase				AS	'IdPhaseT1',
			WP.Id					AS	'IdWPT1',
			WP.Code + ' - ' + WP.Name		AS	'WPNameT1'
		FROM WORK_PACKAGES AS WP
		WHERE WP.IdProject = @IdProject AND
			WP.IsActive = CASE WHEN @ActiveState = 'A' THEN	1
								WHEN @ActiveState = 'I' THEN 0
								WHEN @ActiveState = 'L' THEN WP.IsActive END
			) AS AllWP
	LEFT JOIN
	(
		SELECT DISTINCT
			WP.IdProject 			AS	'IdProjectT2',
			WP.IdPhase				AS	'IdPhaseT2',
			WP.Id					AS	'IdWPT2',
			WP.Code + ' - ' + WP.Name		AS	'WPNameT2'
		FROM WORK_PACKAGES AS WP
		--This join is used to get the work packages for which data exists in the revised budget
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
				WP.IsActive = CASE WHEN @ActiveState = 'A' THEN	1
									WHEN @ActiveState = 'I' THEN 0
									WHEN @ActiveState = 'L' THEN WP.IsActive END AND
				BRD.IdGeneration = @BudgetGeneration AND
				BRD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BRD.IdAssociate
								ELSE @IdAssociate END 
	) AS UsedWP
	ON 	AllWP.IdProjectT1 = UsedWP.IdProjectT2 AND
		AllWP.IdPhaseT1 = UsedWP.IdPhaseT2 AND
		AllWP.IdWPT1 = UsedWP.IdWPT2

	SELECT	IdProjectT1 AS 'IdProject',
		IdPhaseT1 AS 'IdPhase',
		IdWPT1 AS 'IdWP',
		WPNameT1 AS 'WPName'
	FROM 	#TempTableRev
	WHERE	IdProjectT2 IS NULL AND
		IdPhaseT2 IS NULL AND
		IdWPT2 IS NULL

END
GO

