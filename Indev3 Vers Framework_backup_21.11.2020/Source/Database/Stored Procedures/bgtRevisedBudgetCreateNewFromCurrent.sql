--Drops the Procedure bgtUpdateRevisedBudgetDetail if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtRevisedBudgetCreateNewFromCurrent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtRevisedBudgetCreateNewFromCurrent
GO

CREATE  PROCEDURE bgtRevisedBudgetCreateNewFromCurrent
	@IdProject 		INT,
	@NewGeneration		INT,
	@IdAssociate		INT
AS
BEGIN
	DECLARE @retVal		INT

	INSERT INTO BUDGET_REVISED_DETAIL (IdProject, IdGeneration, IdPhase, IdWorkPackage,
		IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal,
		IdCountry, IdAccountHours, IdAccountSales)
	SELECT	
		BUDGET_REVISED_DETAIL.IdProject,
		IdGeneration + 1,
		BUDGET_REVISED_DETAIL.IdPhase,
		IdWorkPackage,
		IdCostCenter,
		BUDGET_REVISED_DETAIL.IdAssociate,
		YearMonth,
		HoursQty,
		HoursVal,
		SalesVal,
		IdCountry,
		IdAccountHours,
		IdAccountSales
	FROM 	BUDGET_REVISED_DETAIL
	--copy only active work packages
	INNER 	JOIN WORK_PACKAGES AS WP ON
		BUDGET_REVISED_DETAIL.IdProject = WP.IdProject AND
		BUDGET_REVISED_DETAIL.IdPhase = WP.IdPhase AND
		BUDGET_REVISED_DETAIL.IdWorkPackage = WP.[Id]
	--copy only the data of the active project core team members
	INNER 	JOIN PROJECT_CORE_TEAMS AS PCT ON
		PCT.IdProject = BUDGET_REVISED_DETAIL.IdProject AND
		PCT.IdAssociate = BUDGET_REVISED_DETAIL.IdAssociate
	WHERE 	IdGeneration = @NewGeneration - 1 AND
		BUDGET_REVISED_DETAIL.IdAssociate = @IdAssociate AND
		BUDGET_REVISED_DETAIL.IdProject = @IdProject AND
		WP.IsActive = 1 AND
		PCT.IsActive = 1

	INSERT INTO BUDGET_REVISED_DETAIL_COSTS (IdProject, IdGeneration, IdPhase, IdWorkPackage,
		IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount)
	SELECT	
		BUDGET_REVISED_DETAIL_COSTS.IdProject,
		IdGeneration + 1,
		BUDGET_REVISED_DETAIL_COSTS.IdPhase,
		IdWorkPackage,
		IdCostCenter,
		BUDGET_REVISED_DETAIL_COSTS.IdAssociate,
		YearMonth,
		IdCostType,
		CostVal,
		IdCountry,
		IdAccount
	FROM 	BUDGET_REVISED_DETAIL_COSTS
	--copy only active work packages
	INNER 	JOIN WORK_PACKAGES AS WP ON
		BUDGET_REVISED_DETAIL_COSTS.IdProject = WP.IdProject AND
		BUDGET_REVISED_DETAIL_COSTS.IdPhase = WP.IdPhase AND
		BUDGET_REVISED_DETAIL_COSTS.IdWorkPackage = WP.[Id]
	--copy only the data of the active project core team members
	INNER 	JOIN PROJECT_CORE_TEAMS AS PCT ON
		PCT.IdProject = BUDGET_REVISED_DETAIL_COSTS.IdProject AND
		PCT.IdAssociate = BUDGET_REVISED_DETAIL_COSTS.IdAssociate
	WHERE 	IdGeneration = @NewGeneration -1 AND
		BUDGET_REVISED_DETAIL_COSTS.IdAssociate = @IdAssociate AND
		BUDGET_REVISED_DETAIL_COSTS.IdProject = @IdProject AND
		WP.IsActive = 1 AND
		PCT.IsActive = 1

	--in case the WP Period has been changed from the validation we do the following routine 
	--for all the WP in the project, active or inactive
	DECLARE @IdProjectParam		int, 
		   @IdPhaseParam		int, 
		   @IdWPParam			int, 
		   @StartYearMonth		int, 
		   @EndYearMonth		int
	
	DECLARE WPCursor CURSOR FAST_FORWARD FOR
	SELECT DISTINCT	BRD.IdProject,
					BRD.IdPhase,
					BRD.IdWorkPackage,
					WP.StartYearMonth,
					WP.EndYearMonth
	FROM BUDGET_REVISED_DETAIL BRD
	INNER JOIN WORK_PACKAGES WP
			ON BRD.IdProject =WP.IdProject and
			   BRD.IdPhase = WP.IdPhase and
			   BRD.IdWorkPackage = WP.Id
	WHERE BRD.IdProject = @IdProject and 
		  BRD.IdGeneration = @NewGeneration and
		  BRD.IdAssociate = @IdAssociate and
		  -- check if number of month expected is different from the number of month found	
		  ((WP.EndYearMonth/100 - WP.StartYearMonth/100)*12 + (WP.EndYearMonth%100 - WP.StartYearMonth%100)+1) <> 
		 	 		(select TOP 1 count(*) 
					 from BUDGET_REVISED_DETAIL BRD2 with (nolock)
					 where BRD2.IdProject = BRD.IdProject AND
						   BRD2.IdGeneration = BRD.IdGeneration AND
						   BRD2.IdPhase = BRD.IdPhase AND
						   BRD2.IdWorkPackage = BRD.IdWorkPackage AND
						   BRD2.IdAssociate = BRD.IdAssociate
					 group by IdCostCenter) OR
		  -- check if StartYearMonth of the work package is the same as in the revised budget
		  WP.StartYearMonth <> (select min(BRD2.YearMonth)
					from BUDGET_REVISED_DETAIL BRD2 with (nolock)
					where BRD2.IdProject = BRD.IdProject AND
						   BRD2.IdGeneration = BRD.IdGeneration AND
						   BRD2.IdPhase = BRD.IdPhase AND
						   BRD2.IdWorkPackage = BRD.IdWorkPackage AND
						   BRD2.IdAssociate = BRD.IdAssociate AND
						   BRD2.IdCostCenter = BRD.IdCostCenter) OR
		  -- check if EndYearMonth of the work package is the same as in the revised budget
		  WP.EndYearMonth <> (select max(BRD2.YearMonth)
				      from BUDGET_REVISED_DETAIL BRD2 with (nolock)
				      where BRD2.IdProject = BRD.IdProject AND
						   BRD2.IdGeneration = BRD.IdGeneration AND
						   BRD2.IdPhase = BRD.IdPhase AND
						   BRD2.IdWorkPackage = BRD.IdWorkPackage AND
						   BRD2.IdAssociate = BRD.IdAssociate AND
						   BRD2.IdCostCenter = BRD.IdCostCenter)
	
	
	open WPCursor
	
	FETCH NEXT FROM WPCursor INTO @IdProjectParam, @IdPhaseParam, @IdWPParam, @StartYearMonth, @EndYearMonth
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		EXEC @retVal = bgtUpdateRevisedWPPeriod @IdProjectParam, @IdPhaseParam, @IdWPParam, @StartYearMonth, @EndYearMonth
		IF (@@ERROR <> 0 OR @retVal < 0)
		BEGIN
			CLOSE WPCursor
			DEALLOCATE WPCursor		
			RAISERROR ('There was an error splitting the totals per months for one WP.', 16, 1)
			RETURN -2
		END		
	
		FETCH NEXT FROM WPCursor INTO @IdProjectParam, @IdPhaseParam, @IdWPParam, @StartYearMonth, @EndYearMonth
	END
	
	CLOSE WPCursor
	DEALLOCATE WPCursor


	INSERT INTO BUDGET_REVISED_STATES(IdProject, IdGeneration, IdAssociate, State, StateDate)
	SELECT IdProject, IdGeneration+1, IdAssociate, 'N', StateDate
	FROM BUDGET_REVISED_STATES
	WHERE IdProject = @IdProject and
		  IdGeneration = @NewGeneration - 1 and 
		  IdAssociate = @IdAssociate

END
GO

