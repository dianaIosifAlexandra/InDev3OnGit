--Drops the Procedure bgtUpdateRevisedWPPeriod if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateRevisedWPPeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateRevisedWPPeriod
GO
CREATE PROCEDURE bgtUpdateRevisedWPPeriod
	@IdProjectParam	INT,		--The Id of the project
	@IdPhaseParam 	INT,		--The Id of the phase
	@IdWP		INT,		--The Id of the selected WorkPackage
	@StartYearMonth INT,		--The new startyearmonth of the workpackage
	@EndYearMonth	INT		--The new endyearmonth of the workpackage
AS
	--Create totals table (without costs)
	CREATE TABLE #Totals
	(
		IdProject 		INT NOT NULL,
		IdGeneration		INT NOT NULL,
		IdPhase 		INT NOT NULL,
		IdWorkPackage		INT NOT NULL,
		IdCostCenter		INT NOT NULL,
		IdAssociate		INT NOT NULL,
		HoursQty		INT,
		HoursVal		INT,
		SalesVal		INT,
		IdCountry		INT NOT NULL,
		IdAccountHours		INT NOT NULL,
		IdAccountSales		INT NOT NULL
		PRIMARY KEY (IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate)
	)

	--Create total costs table
	CREATE TABLE #TotalCosts
	(
		IdProject 		INT NOT NULL,
		IdGeneration		INT NOT NULL,
		IdPhase 		INT NOT NULL,
		IdWorkPackage		INT NOT NULL,
		IdCostCenter		INT NOT NULL,
		IdAssociate		INT NOT NULL,
		IdCostType 		INT NOT NULL,
		CostVal			INT,
		IdCountry 		INT NOT NULL,
		IdAccount		INT NOT NULL
		PRIMARY KEY (IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCostType)
	)

	INSERT INTO #Totals
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales)
	SELECT 	BRD.IdProject,
		BRD.IdGeneration,
		IdPhase,
		IdWorkPackage,
		IdCostCenter,
		IdAssociate,
		SUM(HoursQty),
		SUM(HoursVal),
		SUM(SalesVal),
		IdCountry,
		IdAccountHours,
		IdAccountSales
	FROM 	BUDGET_REVISED_DETAIL BRD
	INNER JOIN BUDGET_REVISED BR
		on BRD.IdProject = BR.IDProject and
		   BRD.IdGeneration = BR.IdGeneration
	WHERE 	BRD.IdProject = @IdProjectParam AND
			BRD.IdPhase = @IdPhaseParam AND
			BRD.IdWorkPackage = @IdWP AND
			BR.IsValidated = 0 --only change in non validated versions
	GROUP BY BRD.IdProject, BRD.IdGeneration, BRD.IdPhase, BRD.IdWorkPackage, BRD.IdCostCenter, BRD.IdAssociate, BRD.IdCountry, BRD.IdAccountHours, BRD.IdAccountSales

	INSERT INTO #TotalCosts
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCostType, CostVal, IdCountry, IdAccount)
	SELECT 	BRDC.IdProject,
		BRDC.IdGeneration,
		IdPhase,
		IdWorkPackage,
		IdCostCenter,
		IdAssociate,
		IdCostType,
		SUM(CostVal),
		IdCountry,
		IdAccount
	FROM	BUDGET_REVISED_DETAIL_COSTS BRDC
	INNER JOIN BUDGET_REVISED BR
		on BRDC.IdProject = BR.IDProject and
		   BRDC	.IdGeneration = BR.IdGeneration
	WHERE 	BRDC.IdProject = @IdProjectParam AND
			BRDC.IdPhase = @IdPhaseParam AND
			BRDC.IdWorkPackage = @IdWP AND
			BR.IsValidated = 0 --only change in non validated versions			
	GROUP BY BRDC.IdProject, BRDC.IdGeneration, BRDC.IdPhase, BRDC.IdWorkPackage, BRDC.IdCostCenter, BRDC.IdAssociate, BRDC.IdCostType, BRDC.IdCountry, BRDC.IdAccount
	
	DECLARE TotalsCursor CURSOR FAST_FORWARD FOR
		SELECT 	IdProject,
			IdGeneration,
			IdPhase,
			IdWorkPackage,
			IdCostCenter,
			IdAssociate,
			HoursQty,
			HoursVal,
			SalesVal,
			IdCountry,
			IdAccountHours,
			IdAccountSales
		FROM 	#Totals

	OPEN TotalsCursor

	DECLARE @IdProject 	INT
	DECLARE @IdGeneration 	INT
	DECLARE @IdPhase 	INT
	DECLARE @IdWorkPackage 	INT
	DECLARE @IdCostCenter	INT
	DECLARE @IdAssociate	INT
	DECLARE @TotalHoursQty	INT
	DECLARE @TotalHoursVal	INT
	DECLARE @TotalSalesVal 	INT
	DECLARE @TotalCostVal	INT
	DECLARE @TotalIdCountry INT
	DECLARE @TotalIdAccountHours INT
	DECLARE @TotalIdAccountSales INT
	DECLARE @TotalCostIdCountry INT
	DECLARE @TotalIdAccount INT

	DECLARE @EndYear	SMALLINT	
	DECLARE @EndMonth	SMALLINT
	DECLARE @StartMonth	SMALLINT
	DECLARE @StartYear	SMALLINT

	--Update work package period in revised budget
	FETCH NEXT FROM TotalsCursor INTO @IdProject, @IdGeneration, @IdPhase, @IdWorkPackage, @IdCostCenter,
		@IdAssociate, @TotalHoursQty, @TotalHoursVal, @TotalSalesVal, @TotalIdCountry, @TotalIdAccountHours, @TotalIdAccountSales
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Delete the old data
		DELETE FROM BUDGET_REVISED_DETAIL_COSTS
		WHERE 	IdProject = @IdProject AND
			IdGeneration = @IdGeneration AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWorkPackage AND
			IdCostCenter = @IdCostCenter AND
			IdAssociate = @IdAssociate
		
		DELETE FROM BUDGET_REVISED_DETAIL
		WHERE	IdProject = @IdProject AND
			IdGeneration = @IdGeneration AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWorkPackage AND
			IdCostCenter = @IdCostCenter AND
			IdAssociate = @IdAssociate

		SET @StartYear = @StartYearMonth / 100
		SET @StartMonth = @StartYearMonth % 100
		SET @EndYear = @EndYearMonth / 100
		SET @EndMonth = @EndYearMonth % 100
		
		WHILE ((@StartYear < @EndYear) OR (@StartYear = @EndYear AND @StartMonth <= @EndMonth))
		BEGIN
			DECLARE @Date INT
			SET @Date = @StartYear * 100 + @StartMonth

			DECLARE @CurrentHoursQty INT
			DECLARE @CurrentHoursVal INT
			DECLARE @CurrentSalesVal INT

			SET @CurrentHoursQty = dbo.fnGetSplittedValue(@TotalHoursQty, @Date, @StartYearMonth, @EndYearMonth)
			SET @CurrentHoursVal = dbo.fnGetSplittedValue(@TotalHoursVal, @Date, @StartYearMonth, @EndYearMonth)
			SET @CurrentSalesVal = dbo.fnGetSplittedValue(@TotalSalesVal, @Date, @StartYearMonth, @EndYearMonth)

			INSERT INTO BUDGET_REVISED_DETAIL
				(IdProject,  IdGeneration,  IdPhase,  IdWorkPackage,  IdCostCenter,  IdAssociate,  YearMonth, HoursQty,         HoursVal, 	   SalesVal, 	     IdCountry, 	IdAccountHours, 	IdAccountSales)
			VALUES 	(@IdProject, @IdGeneration, @IdPhase, @IdWorkPackage, @IdCostCenter, @IdAssociate, @Date,     @CurrentHoursQty, @CurrentHoursVal, @CurrentSalesVal, @TotalIdCountry,	@TotalIdAccountHours,   @TotalIdAccountSales)

			DECLARE @Counter INT
			SET @Counter = 1
			
			WHILE (@Counter <= 5)
			BEGIN
				DECLARE @CurrentCostVal INT
				
				SELECT 	@TotalCostVal = CostVal,
					@TotalCostIdCountry = IdCountry,
					@TotalIdAccount = IdAccount
				FROM 	#TotalCosts
				WHERE 	IdProject = @IdProject AND
					IdGeneration = @IdGeneration AND
					IdPhase = @IdPhase AND
					IdWorkPackage = @IdWorkPackage AND
					IdCostCenter = @IdCostCenter AND
					IdAssociate = @IdAssociate AND
					IdCostType = @Counter

				SET @CurrentCostVal = dbo.fnGetSplittedValue(@TotalCostVal, @Date, @StartYearMonth, @EndYearMonth)
				
				INSERT INTO BUDGET_REVISED_DETAIL_COSTS
					(IdProject,  IdGeneration,  IdPhase,  IdWorkPackage,  IdCostCenter,  IdAssociate,  YearMonth, IdCostType, CostVal,	   IdCountry, 		IdAccount)
				VALUES	(@IdProject, @IdGeneration, @IdPhase, @IdWorkPackage, @IdCostCenter, @IdAssociate, @Date,     @Counter,   @CurrentCostVal,@TotalCostIdCountry, @TotalIdAccount)
				
				SET @Counter = @Counter + 1
			END
		
			IF(@StartMonth = 12)
			BEGIN
				SET @StartYear = @StartYear + 1
				SET @StartMonth = 1
			END
			ELSE
			BEGIN
				SET @StartMonth = @StartMonth + 1
			END

		END


		FETCH NEXT FROM TotalsCursor INTO @IdProject, @IdGeneration, @IdPhase, @IdWorkPackage, @IdCostCenter,
		@IdAssociate, @TotalHoursQty, @TotalHoursVal, @TotalSalesVal, @TotalIdCountry, @TotalIdAccountHours, @TotalIdAccountSales
	END

	CLOSE TotalsCursor
	DEALLOCATE TotalsCursor
GO

