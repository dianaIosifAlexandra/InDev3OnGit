--Drops the Procedure bpsSelectInitialBudgetWPInfo if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bpsSelectInitialBudgetWPInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bpsSelectInitialBudgetWPInfo
GO
CREATE PROCEDURE bpsSelectInitialBudgetWPInfo
	@IdProject	AS INT, 	--The Id of the Project
	@IdPhase	AS INT,		--The Id of the Phase
	@IdWP		AS INT,		--The Id of the Work Package
	@BudgetVersion	AS CHAR(1) = NULL,	-- @BudgetVersion will be 'P', 'C' or 'N'
	@IdAssociate	AS INT,
	@WPCode		AS VARCHAR(3)
AS

	DECLARE @ErrorMessage varchar(255)
	IF NULLIF(@WPCode, '') IS NOT NULL AND NOT EXISTS (
			SELECT [Id]
			FROM WORK_PACKAGES
			WHERE IdProject = @IdProject AND
			      IdPhase	= @IdPhase AND
			      [Id]	= @IdWP AND
			      Code	= @WPCode
			)
	BEGIN
		SET @ErrorMessage = 'Key information about WP with code '+ @WPCode + ' has been changed by another user. Please refresh your information.'	
		RAISERROR(@ErrorMessage, 16, 1)
	
	END

	DECLARE @BudgetGeneration INT
	DECLARE @HasBudget BIT
	DECLARE @HasActualOrRevisedData BIT

	SET @HasBudget = 0
	SET @HasActualOrRevisedData = 0

	IF EXISTS
	(
		SELECT 	IdProject
		FROM	BUDGET_INITIAL_DETAIL
		WHERE	IdProject = @IdProject AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP
	)
	BEGIN
		SET @HasBudget = 1
	END

	SELECT 	WP.IdProject 						AS 'IdProject',
			WP.IdPhase 							AS 'IdPhase',
			WP.[Id]								AS 'IdWP',
			[PH].[Code] + ' - ' + [PH].[Name]	AS 'PhaseName',
			[WP].Code + ' - ' + [WP].Name		AS 'WPName',
			[WP].Code							AS 'WPCode',
			WP.StartYearMonth					AS 'StartYearMonth',
			WP.EndYearMonth						AS 'EndYearMonth',
			WP.IsActive		 					AS 	'IsActive',
			CAST (CASE 	WHEN (PJI.PercentAffected IS NOT NULL and
							 WP.StartYearMonth IS NOT NULL AND
							 WP.EndYearMonth IS NOT NULL) THEN 1 
				  ELSE 0 END AS BIT)			AS 'HasPeriodAndInterco',
			@HasBudget							AS 'HasBudget',
			@HasActualOrRevisedData				AS 'HasActualOrRevisedData'
			FROM WORK_PACKAGES AS WP
			INNER JOIN PROJECT_PHASES PH 
				ON WP.IdPhase = PH.Id
			LEFT JOIN PROJECTS_INTERCO AS PJI 
				ON 	PJI.IdProject = WP.IdProject AND
					PJI.IdPhase = WP.IdPhase AND
					PJI.IdWorkPackage = WP.Id 
	WHERE 	WP.IdProject = @IdProject AND
			WP.IdPhase = @IdPhase AND
			WP.Id	= @IdWP
GO

