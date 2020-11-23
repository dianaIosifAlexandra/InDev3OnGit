--Drops the Procedure bgtValidateInitialBudget if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtValidateInitialBudget]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtValidateInitialBudget
GO


CREATE    PROCEDURE bgtValidateInitialBudget
	@IdProject 	INT 	--Id of the Project
AS

	Declare @IsValidated bit

	--read the validation date from OS
	DECLARE @ValidationDate smalldatetime
	SET @ValidationDate = GETDATE()

	IF (@IdProject < 0 )
	BEGIN 
		RAISERROR('No project has been selected.',16,1)		
		RETURN -1
	END 

	--check if the project is already validated - read the state for one of the associates
	SELECT @IsValidated = IsValidated 
	FROM BUDGET_INITIAL (tablockx)
	WHERE IdProject = @IdProject

	IF (@IsValidated = 1)
	BEGIN 
		RAISERROR('Initial budget is already validated.',16,1)		
		RETURN -2
	END 

	--Delete the data of the core team members that have worked on the budget but are now inactive (so
	--that their data won't be copied to revised and reforecast)
	DELETE BIDC 
	FROM BUDGET_INITIAL_DETAIL_COSTS BIDC
	INNER JOIN PROJECT_CORE_TEAMS PCT 
		ON	BIDC.IdProject = PCT.IdProject AND
			BIDC.IdAssociate = PCT.IdAssociate
	WHERE 	BIDC.IdProject = @IdProject AND
			PCT.IsActive = 0

	DELETE BID 
	FROM BUDGET_INITIAL_DETAIL BID
	INNER JOIN PROJECT_CORE_TEAMS PCT 
		ON	BID.IdProject = PCT.IdProject AND
			BID.IdAssociate = PCT.IdAssociate
	WHERE 	BID.IdProject = @IdProject AND
			PCT.IsActive = 0

	DELETE BIS 
	FROM BUDGET_INITIAL_STATES BIS
	INNER JOIN PROJECT_CORE_TEAMS PCT 
		ON	BIS.IdProject = PCT.IdProject AND
			BIS.IdAssociate = PCT.IdAssociate
	WHERE 	BIS.IdProject = @IdProject AND
			PCT.IsActive = 0

	
	--update only existing records with V state
	UPDATE
		BUDGET_INITIAL_STATES
	SET 		
		StateDate = CASE WHEN (ISNULL(State,'N') = 'N' or ISNULL(State,'N') = 'V') then StateDate else @ValidationDate end,
		State = 'V'
	WHERE 	IdProject = @IdProject

	UPDATE
		BUDGET_INITIAL
	SET 	
		IsValidated = 1,
		ValidationDate = @ValidationDate
	WHERE	IdProject = @IdProject



	--COPY BUDGET_INITIAL TO REVISED
	INSERT INTO [BUDGET_REVISED]
	([IdProject], [IdGeneration], [IsValidated], [ValidationDate])
	SELECT BI.[IdProject], 1, BI.[IsValidated], @ValidationDate
	FROM [BUDGET_INITIAL] BI
	WHERE BI.[IdProject]  = @IdProject

	--COPY BUDGET_INITIAL_DETAIL TO REVISED
	INSERT INTO [BUDGET_REVISED_DETAIL]
	(
		[IdProject], [IdGeneration], [IdPhase], 
		[IdWorkPackage], [IdCostCenter], [IdAssociate],
		[YearMonth], [HoursQty], [HoursVal], [SalesVal],
		[IdCountry], [IdAccountHours], [IdAccountSales]
	)
	SELECT   
		BID.[IdProject], 
		1, 
		BID.[IdPhase],
		BID.[IdWorkPackage],
		BID.[IdCostCenter], 
		BID.[IdAssociate],
		BID.[YearMonth],
		BID.[HoursQty], 
		BID.HoursVal, 
		BID.[SalesVal],
		BID.[IdCountry],
		BID.[IdAccountHours],
		BID.[IdAccountSales]
	FROM [BUDGET_INITIAL_DETAIL] BID
	INNER JOIN WORK_PACKAGES WP ON
		BID.IdProject = WP.IdProject AND
		BID.IdPhase = WP.IdPhase AND
		BID.IDWorkPackage = WP.[Id]
	WHERE 	BID.[IdProject] =  @IdProject AND
		WP.IsActive = 1

	--COPY BUDGET_INITIAL_DETAIL_COSTS
	INSERT INTO [BUDGET_REVISED_DETAIL_COSTS]
	(
		 [IdProject], [IdGeneration], [IdPhase],
		 [IdWorkPackage], [IdCostCenter], [IdAssociate],
		 [YearMonth], [IdCostType], [CostVal],
		 [IdCountry], [IdAccount]
	)
	SELECT BIDC.[IdProject], 1, BIDC.[IdPhase],
	       BIDC.[IdWorkPackage], BIDC.[IdCostCenter], BIDC.[IdAssociate],
	       BIDC.[YearMonth], BIDC.[IdCostType], BIDC.[CostVal],
	       BIDC.[IdCountry], BIDC.[IdAccount]
	FROM [BUDGET_INITIAL_DETAIL_COSTS] BIDC
	INNER JOIN WORK_PACKAGES WP ON
		BIDC.IdProject = WP.IdProject AND
		BIDC.IdPhase = WP.IdPhase AND
		BIDC.IDWorkPackage = WP.[Id]
	WHERE 	BIDC.[IdProject] = @IdProject AND
		WP.IsActive = 1


	-- COPY BUDGET_INITIAL_STATES TO REVISED
	INSERT INTO [BUDGET_REVISED_STATES]
	(
		[IdProject], [IdGeneration], [IdAssociate],
		 [State], [StateDate]
	)

	SELECT   BIS.[IdProject],1, BIS.[IdAssociate],
		 BIS.[State], BIS.[StateDate] 
	FROM [BUDGET_INITIAL_STATES] BIS
	WHERE BIS.[IdProject] = @IdProject


	
	-- COPY TO TO COMPLETION BUDGET --------------------------------------------------------------------

	--COPY BUDGET_INITIAL TO TOCOMPLETION
	--YearMonthActualData is on purpose set to null in order to mantain the equality of 
	--INITIAL = VERSION 1 of revised = VERSION 1 of Reforecst
	INSERT INTO BUDGET_TOCOMPLETION
		(IdProject, IdGeneration, IsValidated, ValidationDate, YearMonthActualData)
	SELECT BI.IdProject, 1, BI.IsValidated, BI.ValidationDate, NULL --user must 
	FROM BUDGET_INITIAL AS BI
	WHERE BI.IdProject  = @IdProject

	--INSERT INTO TOCOMPLETION_PREOGRESS
	INSERT INTO BUDGET_TOCOMPLETION_PROGRESS
		(IdProject, IdGeneration, IdPhase, [Percent], IdAssociate, IdWorkPackage)
	SELECT DISTINCT BID.IdProject, 1, BID.IdPhase, NULL, BID.IdAssociate, BID.IdWorkPackage
	FROM BUDGET_INITIAL_DETAIL BID
	INNER JOIN WORK_PACKAGES WP ON
		BID.IdProject = WP.IdProject AND
		BID.IdPhase = WP.IdPhase AND
		BID.IDWorkPackage = WP.[Id]
	WHERE 	BID.IdProject =  @IdProject AND
		WP.IsActive = 1

	--COPY BUDGET_INITIAL_DETAIL TO TO_COMPLETION_DETAIL
	INSERT INTO BUDGET_TOCOMPLETION_DETAIL
	(
		IdProject, IdGeneration, IdPhase, IdWorkPackage, 
		IdCostCenter,      IdAssociate,   YearMonth,
		HoursQty,     HoursVal,     SalesVal,
		[IdCountry], [IdAccountHours], [IdAccountSales]
	)
	SELECT	
		BID.IdProject, 
		1, 
		BID.IdPhase,
		BID.IdWorkPackage,
		BID.IdCostCenter,
		BID.IdAssociate,
		BID.YearMonth,
		BID.HoursQty,
		BID.HoursVal, 
		BID.SalesVal,
		BID.[IdCountry],
		BID.[IdAccountHours],
		BID.[IdAccountSales]
	FROM BUDGET_INITIAL_DETAIL BID
	INNER JOIN WORK_PACKAGES WP ON
		BID.IdProject = WP.IdProject AND
		BID.IdPhase = WP.IdPhase AND
		BID.IDWorkPackage = WP.[Id]
	WHERE 	BID.IdProject =  @IdProject AND
		WP.IsActive = 1

	--COPY BUDGET_INITIAL_DETAIL_COSTS TO TOCOMPLETION_DETAIL_COSTS
	INSERT INTO BUDGET_TOCOMPLETION_DETAIL_COSTS
	(
		IdProject, IdGeneration, IdPhase, IdWorkPackage, 
		IdCostCenter,       IdAssociate,     YearMonth,
		IdCostType,     CostVal, [IdCountry], [IdAccount]
	)
	SELECT 	BIDC.IdProject, 1, BIDC.IdPhase, BIDC.IdWorkPackage, BIDC.IdCostCenter,
		BIDC.IdAssociate, BIDC.YearMonth, BIDC.IdCostType, BIDC.CostVal,
	       	BIDC.[IdCountry], BIDC.[IdAccount]
	FROM BUDGET_INITIAL_DETAIL_COSTS BIDC
	INNER JOIN WORK_PACKAGES WP ON
		BIDC.IdProject = WP.IdProject AND
		BIDC.IdPhase = WP.IdPhase AND
		BIDC.IDWorkPackage = WP.[Id]
	WHERE 	BIDC.IdProject = @IdProject AND
		WP.IsActive = 1

	-- COPY BUDGET_INITIAL_STATES TO TOCOMPLETION
	INSERT INTO BUDGET_TOCOMPLETION_STATES
	(
		IdProject, IdGeneration, IdAssociate, State, StateDate
	)
	SELECT   BIS.IdProject,1, BIS.IdAssociate, BIS.State, BIS.StateDate 
	FROM BUDGET_INITIAL_STATES BIS
	WHERE BIS.[IdProject] = @IdProject
	
GO


