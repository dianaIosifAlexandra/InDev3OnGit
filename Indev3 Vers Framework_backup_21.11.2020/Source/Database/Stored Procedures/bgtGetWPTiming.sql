--Drops the Procedure bgtGetWPTiming if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetWPTiming]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetWPTiming
GO
CREATE PROCEDURE bgtGetWPTiming
	@IdProject 		AS INT, 	--The Id of the Project
	@IdPhase		AS INT,
	@IdWP			AS INT,
	@IdAssociate		AS INT
AS
	DECLARE @HasBudget BIT
	SET @HasBudget = 0

	IF
	(
		EXISTS
		(
			SELECT 	IdProject
			FROM	BUDGET_INITIAL_DETAIL
			WHERE	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @IdWP AND
				IdAssociate = @IdAssociate
		)
		OR
		EXISTS
		(
			SELECT 	IdProject
			FROM	BUDGET_REVISED_DETAIL
			WHERE	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @IdWP AND
				IdAssociate = @IdAssociate
		)
		OR
		EXISTS
		(
			SELECT 	IdProject
			FROM	BUDGET_TOCOMPLETION_DETAIL
			WHERE	IdProject = @IdProject AND
				IdPhase = @IdPhase AND
				IdWorkPackage = @IdWP AND
				IdAssociate = @IdAssociate
		)
	)
	BEGIN
		SET @HasBudget = 1
	END
	

	--Gets the detail table for Timing functionality
	SELECT DISTINCT
		[WP].IdProject 		AS	'IdProject',
		[WP].IdPhase		AS	'IdPhase',
		[PH].Code + ' - ' + [PH].Name	AS	'PhaseCode',
		[WP].[Id]		AS	'IdWP',
		WP.Code + ' - ' + WP.Name	AS	'WPCode',
		WP.StartYearMonth	AS	'StartYearMonth',
		WP.EndYearMonth		AS	'EndYearMonth',
		@HasBudget		AS 	'HasBudget'
	FROM WORK_PACKAGES AS WP
	INNER JOIN PROJECT_PHASES PH ON WP.IdPhase = PH.[Id]
	--The following join is used to get only the WP that have interco information
	WHERE 	(WP.IdProject = @IdProject) AND
		(WP.IdPhase = @IdPhase) AND
		(WP.Id = @IdWP)

GO


