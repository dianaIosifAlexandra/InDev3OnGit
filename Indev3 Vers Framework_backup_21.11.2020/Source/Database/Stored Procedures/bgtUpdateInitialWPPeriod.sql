--Drops the Procedure bgtUpdateInitialWPPeriod if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateInitialWPPeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateInitialWPPeriod
GO
CREATE PROCEDURE bgtUpdateInitialWPPeriod
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
		IdPhase 		INT NOT NULL,
		IdWorkPackage		INT NOT NULL,
		IdCostCenter		INT NOT NULL,
		IdAssociate		INT NOT NULL,
		HoursQty		INT,
		HoursVal		decimal(18,4),
		SalesVal		decimal(18,4),
		IdCountry		INT NOT NULL,
		IdAccountHours		INT NOT NULL,
		IdAccountSales		INT NOT NULL
		PRIMARY KEY (IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate)
	)

	--Create total costs table
	CREATE TABLE #TotalCosts
	(
		IdProject 		INT NOT NULL,
		IdPhase 		INT NOT NULL,
		IdWorkPackage		INT NOT NULL,
		IdCostCenter		INT NOT NULL,
		IdAssociate		INT NOT NULL,
		IdCostType 		INT NOT NULL,
		CostVal			decimal(18,4),
		IdCountry 		INT NOT NULL,
		IdAccount		INT NOT NULL
		PRIMARY KEY (IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCostType)
	)

	INSERT INTO #Totals
	(IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales)
	SELECT	BID.IdProject,
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
	FROM 	BUDGET_INITIAL_DETAIL BID
	INNER JOIN BUDGET_INITIAL BI
		on BID.IdProject = BI.IdProject
	WHERE 	BID.IdProject = @IdProjectParam AND
			BID.IdPhase = @IdPhaseParam AND
			BID.IdWorkPackage = @IdWP AND
			BI.IsValidated = 0 --only for non validated Initial budgets
	GROUP BY BID.IdProject, BID.IdPhase, BID.IdWorkPackage, BID.IdCostCenter, BID.IdAssociate, BID.IdCountry, BID.IdAccountHours, BID.IdAccountSales

	INSERT INTO #TotalCosts
	(IdProject, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCostType, CostVal, IdCountry, IdAccount)
	SELECT 	BIDC.IdProject,
		IdPhase,
		IdWorkPackage,
		IdCostCenter,
		IdAssociate,
		IdCostType,
		SUM(CostVal),
		IdCountry,
		IdAccount
	FROM	BUDGET_INITIAL_DETAIL_COSTS BIDC
	INNER JOIN BUDGET_INITIAL BI
		on BIDC.IdProject = BI.IdProject
	WHERE 	BIDC.IdProject = @IdProjectParam AND
		BIDC.IdPhase = @IdPhaseParam AND
		BIDC.IdWorkPackage = @IdWP AND
			BI.IsValidated = 0 --only for non validated Initial budgets
	GROUP BY BIDC.IdProject, BIDC.IdPhase, BIDC.IdWorkPackage, BIDC.IdCostCenter, BIDC.IdAssociate, BIDC.IdCostType, BIDC.IdCountry, BIDC.IdAccount
	
	DECLARE TotalsCursor CURSOR FAST_FORWARD FOR
		SELECT 	IdProject,
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
	DECLARE @IdPhase 	INT
	DECLARE @IdWorkPackage 	INT
	DECLARE @IdCostCenter	INT
	DECLARE @IdAssociate	INT
	DECLARE @TotalHoursQty	INT
	DECLARE @TotalHoursVal	DECIMAL(18,4)
	DECLARE @TotalSalesVal 	DECIMAL(18,4)
	DECLARE @TotalCostVal	DECIMAL(18,4)
	DECLARE @TotalIdCountry INT
	DECLARE @TotalIdAccountHours INT
	DECLARE @TotalIdAccountSales INT
	DECLARE @TotalCostIdCountry INT
	DECLARE @TotalIdAccount INT

	DECLARE @EndYear	SMALLINT	
	DECLARE @EndMonth	SMALLINT
	DECLARE @StartMonth	SMALLINT
	DECLARE @StartYear	SMALLINT

	--Update work package period in initial budget
	FETCH NEXT FROM TotalsCursor INTO @IdProject, @IdPhase, @IdWorkPackage, @IdCostCenter, @IdAssociate,
		@TotalHoursQty, @TotalHoursVal, @TotalSalesVal, @TotalIdCountry, @TotalIdAccountHours, @TotalIdAccountSales
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Delete the old data
		DELETE FROM BUDGET_INITIAL_DETAIL_COSTS
		WHERE 	IdProject = @IdProject AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWorkPackage AND
			IdCostCenter = @IdCostCenter AND
			IdAssociate = @IdAssociate
		
		DELETE FROM BUDGET_INITIAL_DETAIL
		WHERE	IdProject = @IdProject AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWorkPackage AND
			IdCostCenter = @IdCostCenter AND
			IdAssociate = @IdAssociate

		SET @StartYear = @StartYearMonth / 100
		SET @StartMonth = @StartYearMonth % 100
		SET @EndYear = @EndYearMonth / 100
		SET @EndMonth = @EndYearMonth % 100

		declare @HourlyRate decimal(18,4)
		declare @HourlyRateIsDefinedAndInteger bit = null

		if @TotalHoursQty <> 0
		   begin
			set @HourlyRateIsDefinedAndInteger = 1
			set @HourlyRate = @TotalHoursVal * 1.0 / @TotalHoursQty
			if floor(@HourlyRate) <> @HourlyRate
			    set @HourlyRateIsDefinedAndInteger = 0
		   end
		
		WHILE ((@StartYear < @EndYear) OR (@StartYear = @EndYear AND @StartMonth <= @EndMonth))
		BEGIN
			DECLARE @Date INT
			SET @Date = @StartYear * 100 + @StartMonth

			DECLARE @CurrentHoursQty int
			DECLARE @CurrentHoursVal bigint
			DECLARE @CurrentSalesVal bigint
						
			SET @CurrentHoursQty = dbo.fnGetSplittedValue(@TotalHoursQty, @Date, @StartYearMonth, @EndYearMonth)
			if 	@HourlyRateIsDefinedAndInteger is null
			    begin
					SET @CurrentHoursVal = dbo.fnGetSplittedValue(CAST(@TotalHoursVal AS BIGINT), @Date, @StartYearMonth, @EndYearMonth)
				end
			else if @HourlyRateIsDefinedAndInteger = 0
			    begin 
					-- if HourlyRate is not integer, the last month is calculated differently
					if @Date < @EndYearMonth
						set @CurrentHoursVal = @CurrentHoursQty * floor(@HourlyRate)
					else
					    begin
							set @CurrentHoursVal = @TotalHoursVal -  (select sum(HoursVal)
								from BUDGET_INITIAL_DETAIL
								where IdProject = @IdProject 
								and IdPhase = @IdPhase 
								and IdWorkPackage = @IdWorkPackage
								and IdCostCenter = @IdCostCenter 
								and IdAssociate = @IdAssociate)
						end
				end
			else
				begin
					set @CurrentHoursVal = @CurrentHoursQty * floor(@HourlyRate)
				end

			SET @CurrentSalesVal = dbo.fnGetSplittedValue(CAST(@TotalSalesVal AS BIGINT), @Date, @StartYearMonth, @EndYearMonth)						

			INSERT INTO BUDGET_INITIAL_DETAIL
				(IdProject,  IdPhase,  IdWorkPackage,  IdCostCenter,  IdAssociate,  YearMonth, HoursQty,         HoursVal, 	   SalesVal, 	     IdCountry, 	IdAccountHours, 	IdAccountSales)
			VALUES 	(@IdProject, @IdPhase, @IdWorkPackage, @IdCostCenter, @IdAssociate, @Date,     @CurrentHoursQty, CAST(@CurrentHoursVal AS DECIMAL(18,4)), CAST(@CurrentSalesVal AS DECIMAL(18,4)), @TotalIdCountry,	@TotalIdAccountHours,   @TotalIdAccountSales)

			DECLARE @Counter INT
			SET @Counter = 1
			
			WHILE (@Counter <= 5)
			BEGIN
				DECLARE @CurrentCostVal BIGINT
				
				SELECT 	@TotalCostVal = CostVal,
					@TotalCostIdCountry = IdCountry,
					@TotalIdAccount = IdAccount
				FROM 	#TotalCosts
				WHERE 	IdProject = @IdProject AND
					IdPhase = @IdPhase AND
					IdWorkPackage = @IdWorkPackage AND
					IdCostCenter = @IdCostCenter AND
					IdAssociate = @IdAssociate AND
					IdCostType = @Counter							
				
				SET @CurrentCostVal = dbo.fnGetSplittedValue(CAST(@TotalCostVal AS BIGINT), @Date, @StartYearMonth, @EndYearMonth)
				
				INSERT INTO BUDGET_INITIAL_DETAIL_COSTS
					(IdProject,  IdPhase,  IdWorkPackage,  IdCostCenter,  IdAssociate,  YearMonth, IdCostType, CostVal, IdCountry, IdAccount)
				VALUES	(@IdProject, @IdPhase, @IdWorkPackage, @IdCostCenter, @IdAssociate, @Date,     @Counter,   CAST(@CurrentCostVal AS DECIMAL(18,4)), @TotalCostIdCountry, @TotalIdAccount)
				
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


		FETCH NEXT FROM TotalsCursor INTO @IdProject, @IdPhase, @IdWorkPackage, @IdCostCenter, @IdAssociate,
		@TotalHoursQty, @TotalHoursVal, @TotalSalesVal, @TotalIdCountry, @TotalIdAccountHours, @TotalIdAccountSales
	END

	CLOSE TotalsCursor
	DEALLOCATE TotalsCursor
GO
