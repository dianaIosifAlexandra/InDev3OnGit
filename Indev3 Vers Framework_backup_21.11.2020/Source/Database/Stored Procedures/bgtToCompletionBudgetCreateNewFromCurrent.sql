--Drops the Procedure bgtGetToCompletionBudgetHoursEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtToCompletionBudgetCreateNewFromCurrent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtToCompletionBudgetCreateNewFromCurrent
GO

CREATE  PROCEDURE bgtToCompletionBudgetCreateNewFromCurrent
	@IdProject			INT,
	@NewGeneration		INT,
	@IdAssociate		INT
AS
BEGIN
	DECLARE @retVal		INT

	--If no record for the new generation exists in table BUDGET_TOCOMPLETION_PROGRESS, copy the data from the
	--Released generation into the InProgress generation for this project and this associate
	INSERT INTO BUDGET_TOCOMPLETION_PROGRESS (IdProject,IdGeneration,IdPhase,IdWorkPackage, IdAssociate, [Percent])
	SELECT  BTP.IdProject,
		    BTP.IdGeneration + 1,
		    BTP.IdPhase,
		    BTP.IdWorkPackage,
		    BTP.IdAssociate,
		    BTP.[Percent]
	FROM 	BUDGET_TOCOMPLETION_PROGRESS BTP
	INNER 	JOIN WORK_PACKAGES WP 
		ON	BTP.IdProject = WP.IdProject AND
			BTP.IdPhase = WP.IdPhase AND
			BTP.IdWorkPackage = WP.Id
	INNER 	JOIN PROJECT_CORE_TEAMS PCT 
		ON	PCT.IdProject = BTP.IdProject AND
			PCT.IdAssociate = BTP.IdAssociate
	WHERE	BTP.IdProject = @IdProject AND
			BTP.IdGeneration = @NewGeneration - 1 AND
			BTP.IdAssociate = @IdAssociate AND
			WP.IsActive = 1 AND 	--copy only active work packages
			PCT.IsActive = 1		--copy only the data of the active project core team members

	--If no record for the new generation exists in table BUDGET_TOCOMPLETION_DETAIL, copy the data from the
	--Released generation into the InProgress generation for this project and this associate
	INSERT INTO BUDGET_TOCOMPLETION_DETAIL (IdProject, IdGeneration, IdPhase, IdWorkPackage,
		IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales)
	SELECT  BTD.IdProject,
			BTD.IdGeneration + 1,
			BTD.IdPhase,
			BTD.IdWorkPackage,
			BTD.IdCostCenter,
			BTD.IdAssociate,
			BTD.YearMonth,
			BTD.HoursQty,
			BTD.HoursVal,
			BTD.SalesVal,
			BTD.IdCountry,
			BTD.IdAccountHours,
			BTD.IdAccountSales
	FROM 	BUDGET_TOCOMPLETION_DETAIL BTD
	INNER 	JOIN WORK_PACKAGES WP 
		ON	BTD.IdProject = WP.IdProject AND
			BTD.IdPhase = WP.IdPhase AND
			BTD.IdWorkPackage = WP.[Id]
	INNER 	JOIN PROJECT_CORE_TEAMS AS PCT 
		ON	PCT.IdProject = BTD.IdProject AND
			PCT.IdAssociate = BTD.IdAssociate
	WHERE	BTD.IdProject = @IdProject AND
			BTD.IdGeneration = @NewGeneration - 1 AND
			BTD.IdAssociate = @IdAssociate AND
			WP.IsActive = 1 AND 	--copy only active work packages
			PCT.IsActive = 1 AND	--copy only the data of the active project core team members 
			BTD.YearMonth BETWEEN WP.StartYearMonth and WP.EndYearMonth --this will cut rows in case the WP period has changed

	--If no record for the new generation exists in table BUDGET_TOCOMPLETION_DETAIL_COSTS, copy the data from the
	--Released generation into the InProgress generation for this project and this associate
	INSERT INTO BUDGET_TOCOMPLETION_DETAIL_COSTS (IdProject, IdGeneration, IdPhase, IdWorkPackage,
		IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount)
	SELECT 	BTDC.IdProject,
			BTDC.IdGeneration + 1,
			BTDC.IdPhase,
			BTDC.IdWorkPackage,
			BTDC.IdCostCenter,
			BTDC.IdAssociate,
			BTDC.YearMonth,
			BTDC.IdCostType,
			BTDC.CostVal,
			BTDC.IdCountry,
			BTDC.IdAccount
	FROM 	BUDGET_TOCOMPLETION_DETAIL_COSTS BTDC
	INNER 	JOIN WORK_PACKAGES WP 
		ON	BTDC.IdProject = WP.IdProject AND
			BTDC.IdPhase = WP.IdPhase AND
			BTDC.IdWorkPackage = WP.Id
	INNER 	JOIN PROJECT_CORE_TEAMS PCT 
		ON	PCT.IdProject = BTDC.IdProject AND
			PCT.IdAssociate = BTDC.IdAssociate
	WHERE	BTDC.IdProject = @IdProject AND
			BTDC.IdGeneration = @NewGeneration - 1 AND
			BTDC.IdAssociate = @IdAssociate AND
			WP.IsActive = 1 AND 	--copy only active work packages
			PCT.IsActive = 1 AND	--copy only the data of the active project core team members
			BTDC.YearMonth BETWEEN WP.StartYearMonth and WP.EndYearMonth --this will cut rows in case the WP period has changed

	INSERT INTO BUDGET_TOCOMPLETION_STATES(IdProject, IdGeneration, IdAssociate, State, StateDate)
	SELECT IdProject, IdGeneration+1, IdAssociate, 'N', StateDate
	FROM BUDGET_TOCOMPLETION_STATES
	WHERE IdProject = @IdProject and
		  IdGeneration = @NewGeneration - 1 and 
		  IdAssociate = @IdAssociate

END
GO

