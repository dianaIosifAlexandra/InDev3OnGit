
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
	IdAccountSales		INT NOT NULL,
	StartYearMonth		INT NOT NULL,
	EndYearMonth		INT NOT NULL
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

--Declare table with all projects with wrong YearMonth
DECLARE @ProjectsToUpdate TABLE
(
	IdProject 		INT NOT NULL,
	IdGeneration		INT NOT NULL,
	IdPhase 		INT NOT NULL,
	IdWorkPackage		INT NOT NULL
	PRIMARY KEY (IdProject, IdGeneration, IdPhase, IdWorkPackage)
)

INSERT INTO @ProjectsToUpdate (IdProject, IdGeneration, IdPhase, IdWorkPackage)
SELECT 
	BRD.IdProject,
	BRD.IdGeneration,
	BRD.IdPhase,
	BRD.IdWorkPackage
FROM BUDGET_REVISED_DETAIL BRD
INNER JOIN BUDGET_REVISED BR 
	ON BRD.IdProject = BR.IDProject AND
	   BRD.IdGeneration = BR.IdGeneration
INNER JOIN WORK_PACKAGES WP
	ON BRD.IdProject = WP.IdProject AND
	   BRD.IdPhase = WP.IdPhase AND
	   BRD.IdWorkPackage = WP.Id	
GROUP BY BRD.IdProject, BRD.IdGeneration, BRD.IdPhase, BRD.IdWorkPackage, WP.StartYearMonth, WP.EndYearMonth
HAVING MIN(BRD.YearMonth) <> WP.StartYearMonth OR MAX(BRD.YearMonth) <> WP.EndYearMonth




	INSERT INTO #Totals 
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales, StartYearMonth, EndYearMonth)
	SELECT 	BRD.IdProject,
		BRD.IdGeneration,
		BRD.IdPhase,
		BRD.IdWorkPackage,
		BRD.IdCostCenter,
		BRD.IdAssociate,
		SUM(BRD.HoursQty),
		SUM(BRD.HoursVal),
		SUM(BRD.SalesVal),
		BRD.IdCountry,
		BRD.IdAccountHours,
		BRD.IdAccountSales,
		WP.StartYearMonth,
		WP.EndYearMonth
	FROM 	BUDGET_REVISED_DETAIL BRD
	INNER JOIN BUDGET_REVISED BR
		ON BRD.IdProject = BR.IDProject AND
		   BRD.IdGeneration = BR.IdGeneration
	INNER JOIN WORK_PACKAGES WP
		ON BRD.IdProject = WP.IdProject AND
		   BRD.IdPhase = WP.IdPhase AND
		   BRD.IdWorkPackage = WP.Id	
	INNER JOIN @ProjectsToUpdate PU
		ON PU.IdProject = BRD.IDProject AND
		   PU.IdGeneration = BRD.IdGeneration AND
		   PU.IdPhase = BRD.IdPhase AND
		   PU.IdWorkPackage = BRD.IdWorkPackage	
	GROUP BY BRD.IdProject, BRD.IdGeneration, BRD.IdPhase, BRD.IdWorkPackage, BRD.IdCostCenter, BRD.IdAssociate, BRD.IdCountry, BRD.IdAccountHours, BRD.IdAccountSales, WP.StartYearMonth, WP.EndYearMonth


	INSERT INTO #TotalCosts 
	(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, IdCostType, CostVal, IdCountry, IdAccount)
	SELECT 	BRDC.IdProject,
		BRDC.IdGeneration,
		BRDC.IdPhase,
		BRDC.IdWorkPackage,
		BRDC.IdCostCenter,
		BRDC.IdAssociate,
		BRDC.IdCostType,
		SUM(BRDC.CostVal),
		BRDC.IdCountry,
		BRDC.IdAccount
	FROM	BUDGET_REVISED_DETAIL_COSTS BRDC
	INNER JOIN BUDGET_REVISED BR
		ON BRDC.IdProject = BR.IDProject AND
		   BRDC.IdGeneration = BR.IdGeneration
	INNER JOIN @ProjectsToUpdate PU
		ON PU.IdProject = BRDC.IDProject AND
		   PU.IdGeneration = BRDC.IdGeneration AND
		   PU.IdPhase = BRDC.IdPhase AND
		   PU.IdWorkPackage = BRDC.IdWorkPackage	
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
			IdAccountSales,
			StartYearMonth,
			EndYearMonth
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
	DECLARE @StartYearMonth INT
	DECLARE @EndYearMonth INT

	DECLARE @EndYear	SMALLINT	
	DECLARE @EndMonth	SMALLINT
	DECLARE @StartMonth	SMALLINT
	DECLARE @StartYear	SMALLINT

	--Update work package period in revised budget
	FETCH NEXT FROM TotalsCursor INTO @IdProject, @IdGeneration, @IdPhase, @IdWorkPackage, @IdCostCenter,
		@IdAssociate, @TotalHoursQty, @TotalHoursVal, @TotalSalesVal, @TotalIdCountry, @TotalIdAccountHours, @TotalIdAccountSales, @StartYearMonth, @EndYearMonth
	
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
		@IdAssociate, @TotalHoursQty, @TotalHoursVal, @TotalSalesVal, @TotalIdCountry, @TotalIdAccountHours, @TotalIdAccountSales, @StartYearMonth, @EndYearMonth
	END

	CLOSE TotalsCursor
	DEALLOCATE TotalsCursor



/* 

* Test if the updated data match the totals
* These 2 selects below should not return any data

*/

SELECT *
FROM #Totals t
INNER JOIN
	(
		SELECT 	BRD.IdProject,
			BRD.IdGeneration,
			BRD.IdPhase,
			BRD.IdWorkPackage,
			BRD.IdCostCenter,
			BRD.IdAssociate,
			SUM(BRD.HoursQty) HoursQtyUpdated,
			SUM(BRD.HoursVal) HoursValUpdated,
			SUM(BRD.SalesVal) SalesValUpdated
		FROM 	BUDGET_REVISED_DETAIL BRD
		GROUP BY BRD.IdProject, BRD.IdGeneration, BRD.IdPhase, BRD.IdWorkPackage, BRD.IdCostCenter, BRD.IdAssociate
	) t1
	ON t.IdProject = t1.IdProject AND
	   t.IdGeneration = t1.IdGeneration AND
	   t.IdPhase = t1.IdPhase AND
	   t.IdWorkPackage = t1.IdWorkPackage AND
	   t.IdCostCenter = t1.IdCostCenter AND
	   t.IdAssociate = t1.IdAssociate
WHERE t.HoursQty <> t1.HoursQtyUpdated OR t.HoursVal <> t1.HoursValUpdated OR t.SalesVal <> t1.SalesValUpdated

SELECT *
FROM #TotalCosts c
INNER JOIN 
	(
		SELECT 	BRDC.IdProject,
			BRDC.IdGeneration,
			BRDC.IdPhase,
			BRDC.IdWorkPackage,
			BRDC.IdCostCenter,
			BRDC.IdAssociate,
			BRDC.IdCostType,
			SUM(BRDC.CostVal) CostValUpdated
		FROM	BUDGET_REVISED_DETAIL_COSTS BRDC
		GROUP BY BRDC.IdProject, BRDC.IdGeneration, BRDC.IdPhase, BRDC.IdWorkPackage, BRDC.IdCostCenter, BRDC.IdAssociate, BRDC.IdCostType
	) c1	
	ON c.IdProject = c1.IdProject AND
	   c.IdGeneration = c1.IdGeneration AND
	   c.IdPhase = c1.IdPhase AND
	   c.IdWorkPackage = c1.IdWorkPackage AND
	   c.IdCostCenter = c1.IdCostCenter AND
	   c.IdAssociate = c1.IdAssociate AND
	   c.IdCostType = c1.IdCostType
WHERE c.CostVal <> c1.CostValUpdated


DROP TABLE #Totals
DROP TABLE #TotalCosts


