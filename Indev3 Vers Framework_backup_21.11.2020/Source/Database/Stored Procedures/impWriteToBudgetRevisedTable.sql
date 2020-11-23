IF EXISTS (SELECT * FROM dbo.sysobjects WHERE Id = object_id(N'dbo.impWriteToBudgetRevisedTable') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteToBudgetRevisedTable
GO

CREATE PROCEDURE dbo.impWriteToBudgetRevisedTable
	@IdImport INT,			-- Id of the import	
	@ForceDeleteExistingOpenBudget bit
AS	

	DECLARE @errMsg varchar(255)
	DECLARE @IdProject int

	--Verify if the IdImport exists
	IF NOT EXISTS(
		SELECT IBI.IdImport
		FROM IMPORT_BUDGET_REVISED IBI
		WHERE IBI.IdImport = @IdImport
	)
	BEGIN		
		SET @errMsg ='Import with Id ' + cast (@IdImport as varchar(3)) + ' was not found.' 
		RAISERROR(@errMsg , 16, 1 )
		RETURN -17
	END

	-- Verify preconditions
	IF EXISTS
	(
		SELECT IdImport 
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE IBI.IdImport = @IdImport
		AND		
		(
			--NO Country Code
			(ISNULL(IBI.CountryCode, '' ) = ''
			OR NOT EXISTS
			(
				SELECT C.Id 
				FROM COUNTRIES C
				WHERE C.Code = IBI.CountryCode
			))
			
			-- NO cost center
			OR (ISNULL(IBI.CostCenterCode, '' ) = '' 
			OR NOT EXISTS
			(
				SELECT CC.Id 
				FROM COST_CENTERS CC 
				INNER JOIN INERGY_LOCATIONS IL 
					ON CC.IdInergyLocation = IL.Id 
				INNER JOIN Countries C 
					ON IL.IdCountry = C.Id
				WHERE CC.CODE=IBI.CostCenterCode 
				AND C.Code = IBI.CountryCode
				AND CC.IsActive = 1
			))
			--NO project code
			OR (ISNULL(IBI.ProjectCode, '' ) = '' 
				OR NOT EXISTS
				(
					SELECT Id 
					FROM PROJECTS 
					WHERE CODE=IBI.ProjectCode 
				)
			)
			--NO WP code
			OR (IBI.WPCode IS NULL  OR 
			NOT EXISTS(SELECT TOP 1  WP.Code 
				   FROM WORK_PACKAGES WP
			      	   INNER JOIN PROJECTS P
					ON P.Id	= WP.IdProject 
					AND P.Code = IBI.ProjectCode				
			  	   WHERE WP.CODE = IBI.WPCode AND
					 WP.IsActive = 1))		
			--NO match between Currency_Code and Cost_Center_Code
			OR ISNULL(IBI.CurrencyCode, '' ) = '' 
			OR NOT EXISTS
			(
				SELECT * 
				FROM COUNTRIES C
				INNER JOIN CURRENCIES CURR
					ON C.IdCurrency = CURR.Id
				WHERE C.Code = IBI.CountryCode
		  		      AND CURR.Code = IBI.CurrencyCode
			)	
			--NO Account Number
			OR (ISNULL(IBI.AssociateNumber, '' ) = ''   
			OR NOT EXISTS
			   (
				SELECT A.Id 
				FROM ASSOCIATES A 
				WHERE A.EmployeeNumber = IBI.AssociateNumber 
			    )
			  )
			--Employee Number is dupplicate
			OR 
			(
				(SELECT COUNT(A.Id) 
				FROM ASSOCIATES A 
				WHERE A.EmployeeNumber = IBI.AssociateNumber) > 1
			) 
			
			--NO Project ready for Revised Budget
			OR NOT EXISTS
			(
				SELECT 
					P.Id 
				FROM 
					PROJECTS P
					INNER JOIN WORK_PACKAGES WP 
						ON P.Id =  WP.IdProject
					INNER JOIN PROJECTS_INTERCO PIN 
						ON P.Id = PIN.IdProject
				WHERE 
					P.CODE = IBI.ProjectCode 
					AND P.IsActive = 1
					AND WP.Code = IBI.WPCode
					AND WP.IsActive = 1
					AND WP.StartYearMonth IS NOT NULL 
					AND WP.EndYearMonth IS NOT NULL
				GROUP BY P.Id
			)
			--CHECK IF THE KEY ( ProjectCode, AssociateNumber, WPCode, CostCenterCode ) already exists 
			OR EXISTS
			(
				SELECT  BID.ProjectCode
				FROM IMPORT_BUDGET_REVISED_DETAILS BID 
				WHERE	IBI.ProjectCode = BID.ProjectCode AND
					IBI.WPCode = BID.WPCode AND
					BID.AssociateNumber = IBI.AssociateNumber AND
					BID.CountryCode = IBI.CountryCode AND
					BID.CostCenterCode = IBI.CostCenterCode
				group by  BID.ProjectCode, BID.WPCode, BID.AssociateNumber, BID.CountryCode, BID.CostCenterCode
				having count(*) > 1
			)
			OR NOT EXISTS
			(
				--CHECK CORE TEAM Members are active and not Project Readers
				SELECT 
					P.Id 
				FROM 
					PROJECTS P
					INNER JOIN PROJECT_CORE_TEAMS  PT 
						ON P.Id = PT.IdProject
					INNER JOIN ASSOCIATES A 
						ON PT.IdAssociate = A.Id
				WHERE 
					P.Code = IBI.ProjectCode
					AND A.EmployeeNumber  = IBI.AssociateNumber
					AND PT.IsActive = 1  
					AND dbo.fnIsAssociateProjectReader(P.Id, A.Id ) <> 1
			)
			OR NOT EXISTS
			(
				--CHECK if there is an initial validated budget
				SELECT 
					bi.IdProject
					FROM PROJECTS p
					join BUDGET_INITIAL bi on bi.IdProject = p.Id
				WHERE 
					p.Code = IBI.ProjectCode and bi.IsValidated = 1
			)
			--CHECK the HoursQty, HoursVal, SalesVal as in UI
			OR (IBI.HoursQty IS NULL or IBI.HoursQty < 0) 
			OR (IBI.HoursVal IS NULL or IBI.HoursVal < 0)
			OR (IBI.SalesVal IS NULL)
			OR (IBI.TE is null or IBI.TE < 0)
			OR (IBI.ProtoParts is null or IBI.ProtoParts < 0)
			or (IBI.ProtoTooling is null or IBI.ProtoTooling < 0)
			or (IBI.Trials is null or IBI.Trials < 0)
			or (IBI.OtherExpenses is null or IBI.OtherExpenses < 0)

		)
		
	)	
	BEGIN
		CREATE TABLE #tempTable
		(
			IdImport int,
			IdRow int,
			Details varchar(500),
			Module char(3)
		)
		DECLARE @Module VARCHAR(50)
		DECLARE @Details varchar(500)
		
		--CHECK Country Code
		SELECT @Module = RTRIM(Code) FROM MODULES
		WHERE Name = N'Country'

		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
		      'Country Code N/A!',
		       @Module
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE
		--NO Country Code
		ISNULL(IBI.CountryCode, '' ) = ''
		AND IBI.IdImport = @IdImport
		
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
		      'Country Code ''' + ISNULL( IBI.CountryCode, 'N/A' ) + ''' does not exist in Countries catalog.',
	 	      @Module
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE
		--NO CountryCode
		(NOT EXISTS
			(
				SELECT C.Id 
				FROM COUNTRIES C
				WHERE C.Code = IBI.CountryCode
			)
		)
		AND IBI.IdImport = @IdImport


		---- ########## CHECK 1
		SELECT @Module =  RTRIM(Code) FROM MODULES
		WHERE NAME =N'Cost Center'

		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Cost Center is N/A!'
			,@Module
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE		
		-- NO cost center
		ISNULL(IBI.CostCenterCode, '' ) = ''
		AND IBI.IdImport = @IdImport
			
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,	
			'Cost Center '''  + ISNULL(IBI.CostCenterCode, 'N/A')  + ''' is not active or does not exists for Country Code ''' + ISNULL(IBI.CountryCode, 'N\A') + ''
			,@Module		
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE			
		-- NO cost center
		( NOT EXISTS
			(
				SELECT CC.Id 
				FROM COST_CENTERS CC 
				INNER JOIN INERGY_LOCATIONS IL 
				        ON CC.IdInergyLocation = IL.Id 
				INNER JOIN COUNTRIES C 
					ON IL.IdCountry = C.Id
				WHERE CC.CODE = IBI.CostCenterCode
				AND C.Code = IBI.CountryCode
				AND CC.IsActive = 1
				
			)
		)
		AND IBI.IdImport = @IdImport
	
		---- ########## CHECK 2
		SELECT @Module =  RTRIM(Code) FROM MODULES
		WHERE NAME =N'Project'

		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow, 
			'Project Code field is N/A!'
			,@Module	
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE 
		--NO project code
		ISNULL(IBI.ProjectCode, '' ) = ''
		AND IBI.IdImport = @IdImport
		
	
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Project Code '''  + ISNULL(IBI.ProjectCode,'N/A') + ''' does not exist in Projects catalog!',
			@Module			
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE 
		--NO project code
		( NOT EXISTS
			(
				SELECT Id 
				FROM PROJECTS 
				WHERE CODE=IBI.ProjectCode
			)
		)
		AND IBI.IdImport = @IdImport 
	
		
		---- ########## CHECK 3
		SELECT @Module =  RTRIM(Code) FROM MODULES 
		WHERE NAME =N'Work Package'

		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Work Package Code is N/A!'
			,@Module
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE 
		--NO WP code
		ISNULL(IBI.WPCode, '' ) = ''
		AND IBI.IdImport = @IdImport			
		
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Work Package Code '''  + ISNULL(IBI.WPCode,'N/A') + ''' does not exist or is inactive for Project Code ''' + ISNULL(IBI.ProjectCode,'N/A') + '''!'
			,@Module
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE 
		--NO WP code
		( NOT EXISTS(
				SELECT TOP 1  WP.Code 
			      	FROM WORK_PACKAGES WP
			      	INNER JOIN PROJECTS P
			      		ON WP.IdProject = P.Id					
			     	WHERE WP.CODE = IBI.WPCode AND
				      Wp.IsActive = 1 AND	
				      P.Code = IBI.ProjectCode				      
			     )
		)				
		AND IBI.IdImport = @IdImport 
			
		---- ########## CHECK 4
		SELECT @Module =  RTRIM(Code) FROM MODULES WHERE NAME =N'Associate'
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Associate Number is N/A!'
			,@Module
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE 
		ISNULL(IBI.AssociateNumber, '' ) = ''
		AND IBI.IdImport = @IdImport
				
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Associate Number '  + ISNULL(IBI.AssociateNumber,'N/A') + ' does not exist in Associates catalogue.'
			,@Module
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE 
		--NO Associate Number
		( NOT EXISTS
			(
				SELECT Id 
				FROM ASSOCIATES 
				WHERE EmployeeNumber = IBI.AssociateNumber 
			)
		)
		AND IBI.IdImport = @IdImport 

		--AssociateNumber found in more than one country
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Associate Number '''  + ISNULL(IBI.AssociateNumber,'N/A') + ''' was found in ' +  
					(SELECT cast(count(Id) as varchar(3)) as AssociateCount
					 FROM ASSOCIATES 
					 WHERE EmployeeNumber = IBI.AssociateNumber
					 GROUP BY EmployeeNumber
					 HAVING count(*)>1)
				 + ' countries. Associate cannot be unique identified. Process cannot continue.'
			,@Module
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE   (SELECT Count(Id) 
			 FROM ASSOCIATES 
			 WHERE EmployeeNUmber = IBI.AssociateNumber) > 1 AND		
		IBI.IdImport = @IdImport
	
		---- ########## CHECK 5		
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Currency Code is N/A!'
			,NULL
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE 
		--NO Currency Code
		ISNULL(IBI.CurrencyCode, '' ) = ''
		AND IBI.IdImport = @IdImport
				
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Currency Code '''  + ISNULL(IBI.CurrencyCode,'N/A') + ''' does not match the currency for Country code ''' + IBI.CountryCode + ''
			,NULL
		FROM IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE 
		--NO Currency Code
		( NOT EXISTS
			(
				SELECT * 
				FROM COUNTRIES C
				INNER JOIN CURRENCIES CURR
					ON C.IdCurrency = CURR.Id
				WHERE C.Code = IBI.CountryCode
		  		      AND CURR.Code = IBI.CurrencyCode										
			)
		) 
		AND IBI.IdImport = @IdImport 
		
		-- CHECK if the Projects are validated
		IF EXISTS
		(
				SELECT IBI.IdImport
				FROM IMPORT_BUDGET_REVISED_DETAILS IBI
				join Projects p on IBI.ProjectCode = p.Code
				left join BUDGET_INITIAL bi on bi.IdProject = p.Id
			WHERE 
				IBI.IdImport = @IdImport and (bi.IdProject is null or bi.IsValidated=0)
		)
			INSERT INTO #tempTable
			(IdImport, IdRow, Details, Module)
			SELECT distinct @IdImport, IBI.IdRow,
				'Project ' + IBI.ProjectCode + ' hasn''t an initial validated budget',NULL
			FROM IMPORT_BUDGET_REVISED_DETAILS IBI
			join Projects p on IBI.ProjectCode = p.Code
			left join BUDGET_INITIAL bi on bi.IdProject = p.Id 
			where IBI.IdImport = @IdImport and (bi.IdProject is null or bi.IsValidated=0)


		--CHECK if the project is ready for Revised Budget ( with explicit messages )
		IF EXISTS
		(
			SELECT IBI.IdImport				
			FROM IMPORT_BUDGET_REVISED_DETAILS IBI
			WHERE			
			NOT EXISTS
			(
				SELECT 
					P.Id 
				FROM 
					PROJECTS P
					INNER JOIN WORK_PACKAGES WP 
						ON P.Id =  WP.IdProject
					INNER JOIN PROJECTS_INTERCO PIN 
						ON P.Id = PIN.IdProject
				WHERE 
					P.CODE = IBI.ProjectCode 
					AND P.IsActive = 1
					AND WP.Code = IBI.WPCode
					AND WP.StartYearMonth IS NOT NULL 
					AND WP.EndYearMonth IS NOT NULL
				GROUP BY P.Id
			)
			AND IBI.IdImport = @IdImport	
		)
		BEGIN
			--CHECK IF THE PROJECT IS ACTIVE
			INSERT INTO #tempTable
			(
				IdImport, IdRow, Details, Module
			)
			SELECT @IdImport, IBI.IdRow,
				'Project code ''' + ISNULL(IBI.ProjectCode, 'N/A' ) + ''' is not ready for Revised Budget ( Project is not active ).',
				NULL
			FROM IMPORT_BUDGET_REVISED_DETAILS IBI
			WHERE
			EXISTS 
			(
				SELECT P.ID
				FROM PROJECTS P 
				WHERE P.Code = IBI.ProjectCode
				AND P.IsActive = 0
			)
			AND IBI.IdImport = @IdImport
			--CHECK IF THE WORK PACKAGE IS ACTIVE AND WITH DEFINED PERIOD
			INSERT INTO #tempTable
			(
				IdImport, IdRow, Details, Module
			)
			SELECT @IdImport, IBI.IdRow,
				'Project code ''' + ISNULL(IBI.ProjectCode, 'N/A' ) + ''' is not ready for Revised Budget ( Project does not have WPs with defined period ).',
				NULL
			FROM IMPORT_BUDGET_REVISED_DETAILS IBI
			WHERE
			(
				EXISTS 
				(
					SELECT  P.Id 
					FROM PROJECTS P
					INNER JOIN WORK_PACKAGES WP 
						ON P.Id =  WP.IdProject							
					WHERE 
						P.CODE = IBI.ProjectCode 
						AND P.IsActive = 1
						AND WP.Code = IBI.WPCode
						AND (WP.StartYearMonth IS NULL  OR WP.EndYearMonth IS NULL )
				)
				OR
				NOT EXISTS
				(
					SELECT  P.Id 
					FROM PROJECTS P
					INNER JOIN WORK_PACKAGES WP 
						ON P.Id =  WP.IdProject							
					WHERE 
						P.CODE = IBI.ProjectCode 
						AND P.IsActive = 1
						AND WP.Code = IBI.WPCode
				)
			)
			AND IBI.IdImport = @IdImport

			--CHECK IF THE PROJECT HAS INTERCO DEFINED
			INSERT INTO #tempTable
			(
				IdImport, IdRow, Details, Module
			)
			SELECT @IdImport, IBI.IdRow,
				'Project code ''' + ISNULL(IBI.ProjectCode, 'N/A' ) + ''' is not ready for Revised Budget ( Project has no interco defined ).',
				NULL
			FROM IMPORT_BUDGET_REVISED_DETAILS IBI
			WHERE
			(
				NOT EXISTS 
				(
					SELECT  P.Id 
					FROM PROJECTS P
					INNER JOIN WORK_PACKAGES WP 
						ON P.Id =  WP.IdProject
					INNER JOIN PROJECTS_INTERCO PIN 
						ON P.Id = PIN.IdProject
					WHERE 
						P.CODE = IBI.ProjectCode 
						AND P.IsActive = 1
						AND WP.Code = IBI.WPCode
				)
			)			
		END								


		--CHECK If the Core Team is active and not a project reader
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Core Member with Associate number ''' + ISNULL( IBI.AssociateNumber, 'N/A' ) + ''' is not active or is a project reader.',
			NULL
		FROM
			IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE
		NOT EXISTS
		(
			SELECT 
				P.Id 
			FROM 
				PROJECTS P
				INNER JOIN PROJECT_CORE_TEAMS  PT 
					ON P.Id = PT.IdProject
				INNER JOIN ASSOCIATES A 
					ON PT.IdAssociate = A.Id
			WHERE 
				P.Code = IBI.ProjectCode
				AND A.EmployeeNumber  = IBI.AssociateNumber
				AND PT.IsActive = 1				
				AND dbo.fnIsAssociateProjectReader(P.Id, A.Id ) <> 1
		)
		AND IBI.IdImport = @IdImport
		

		--CHECK if the KEY( IdProject, IdAssociate, IdWorkPackage, IdCostCenter ) exists
		INSERT INTO #tempTable
		(
			idImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
		       'The key (Project ''' + ISNULL(IBI.ProjectCode, 'N/A') + ''', AssociateNumber ''' + ISNULL(IBI.AssociateNumber, 'N/A') + ''', WPCode ''' + ISNULL(IBI.WPCode, 'N/A') + ''', CostCenterCode ''' + ISNULL(IBI.CostCenterCode, 'N/A') + ''' ) is duplicated in the imported file.',
			NULL
			from IMPORT_BUDGET_REVISED_DETAILS IBI
			join
			(
				SELECT  BID.ProjectCode, BID.WPCode, BID.AssociateNumber, BID.CountryCode, BID.CostCenterCode
				FROM IMPORT_BUDGET_REVISED_DETAILS BID 
				where IdImport = @IdImport
				group by  BID.ProjectCode, BID.WPCode, BID.AssociateNumber, BID.CountryCode, BID.CostCenterCode
				having count(*) > 1
			) BID on IBI.ProjectCode = BID.ProjectCode AND
					IBI.WPCode = BID.WPCode AND
					BID.AssociateNumber = IBI.AssociateNumber AND
					BID.CountryCode = IBI.CountryCode AND
					BID.CostCenterCode = IBI.CostCenterCode
		WHERE
			IBI.IdImport = @IdImport 


		--CHECK if HoursQty, HoursVal, SalesVal follow the same rules as in UI
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			case when  IBI.HoursQty is null or IBI.HoursQty <0 then 'HoursQty ''' + rtrim(ISNULL(CONVERT(char(20), IBI.HoursQty), 'N/A')) + ''' must be a non-empty, non-negative number.' else '' end  + case when IBI.HoursVal is null or IBI.HoursVal < 0 then 'HoursVal ''' +  rtrim(ISNULL(CONVERT(char(20),IBI.HoursVal), 'N/A')) + ''' must be a non-empty, non-negative number.' else '' end + case when IBI.SalesVal is null then 'Sales must be a not-empty number.' else '' end +  case when IBI.TE is null or IBI.ProtoParts is null or IBI.ProtoTooling is null or IBI.Trials is null  or IBI.OtherExpenses is null or IBI.TE < 0 or IBI.ProtoParts < 0 or IBI.ProtoTooling < 0 or IBI.Trials < 0 or IBI.OtherExpenses < 0 then 'T&E, Proto Parts, Proto Tooling, Trials, Other Expenses must be non-empty, non-negative numbers: ''' + rtrim(ISNULL(cast(IBI.TE as varchar), 'N/A')) + ''', ''' + rtrim(ISNULL(CONVERT(char(20), IBI.ProtoParts), 'N/A')) + ''', ''' + rtrim(ISNULL(CONVERT(char(20), IBI.ProtoTooling), 'N/A')) + ''', ''' + rtrim(ISNULL(CONVERT(char(20), IBI.Trials), 'N/A')) + ''', ''' + rtrim(ISNULL(CONVERT(char(20), IBI.OtherExpenses), 'N/A')) + '''' else '' end,
			NULL
		FROM
			IMPORT_BUDGET_REVISED_DETAILS IBI
		WHERE
			IBI.IdImport = @IdImport AND
			(IBI.HoursQty IS NULL or IBI.HoursQty < 0
			OR IBI.HoursVal IS NULL or IBI.HoursVal  < 0
			OR IBI.SalesVal IS NULL 
			OR IBI.TE is null or IBI.TE < 0
			OR IBI.ProtoParts is null or IBI.ProtoParts < 0
			or IBI.ProtoTooling is null or IBI.ProtoTooling < 0
			or IBI.Trials is null or IBI.Trials < 0
			or IBI.OtherExpenses is null or IBI.OtherExpenses < 0)


		SELECT TOP 1 @Details ='IdRow = ' + cast(IdRow as varchar) + ' ' + Details FROM #tempTable
		
		IF @@RowCount > 0
		BEGIN
			RAISERROR( @Details,16,1)
			RETURN -1
		END
	END		
	
	if @ForceDeleteExistingOpenBudget = 1
	-- Delete the existing InProgress version
	   begin
	    DECLARE @IdGenerationInProgress INT
		declare @IdProj int
		select top 1 @IdProj = p.Id 
		from IMPORT_BUDGET_REVISED_DETAILS a
		join PROJECTS p on a.ProjectCode = p.Code
		where a.IdImport = @IdImport

		SELECT  @IdGenerationInProgress = dbo.fnGetRevisedBudgetGeneration(@IdProj,'N')

		if @IdGenerationInProgress is not null
		   delete BUDGET_REVISED_DETAIL_COSTS where IdGeneration = @IdGenerationInProgress and IdProject = @IdProj
		   delete BUDGET_REVISED_DETAIL where IdGeneration = @IdGenerationInProgress and IdProject = @IdProj
		   delete from BUDGET_REVISED_STATES where IdProject = @IdProj and IdGeneration = @IdGenerationInProgress
		   delete from BUDGET_REVISED where IdProject = @IdProj and IdGeneration = @IdGenerationInProgress
	   end

	--Declare the cursor for import the data
	DECLARE RevisedBudgetData CURSOR FAST_FORWARD FOR
		SELECT
			IdRow,
			ProjectCode,
			WPCode,	
			AssociateNumber,
			CountryCode,
			CostCenterCode,
			HoursQty,
			HoursVal,
			SalesVal,
			TE,	
			ProtoParts,
			ProtoTooling,
			Trials,
			OtherExpenses,
			CurrencyCode
		FROM IMPORT_BUDGET_REVISED_DETAILS
		WHERE IdImport = @IdImport	
		order by AssociateNumber
	
	
	DECLARE @IdRow int	
	DECLARE @ProjectCode varchar(10)
	DECLARE @WPCode varchar(4)
	DECLARE @AssociateNumber varchar(15)
	DECLARE @CountryCode varchar(3)
	DECLARE @CostCenterCode varchar(10)
	DECLARE @HoursQty int
	DECLARE @HoursVal decimal(18,4)
	DECLARE @SalesVal decimal(18,4)
	DECLARE @TE decimal(18,4)
	DECLARE @ProtoParts decimal(18,4)
	DECLARE @ProtoTooling decimal(18,4)
	DECLARE @Trials decimal(18,4)
	DECLARE @OtherExpenses decimal(18,4)
	DECLARE @CurrencyCode varchar(3),
		@IdCountry INT

	DECLARE @IdTE int
	DECLARE @IdProtoParts int
	DECLARE @IdProtoTooling int
	DECLARE @IdTrials int
	DECLARE @IdOtherExpenses int
	
	DECLARE @RetVal int 
	DECLARE @IdCurrentProject int
	DECLARE @IdCurrentAssociate int
	DECLARE @IdGenerationNew INT = 0

	SET @IdCurrentProject   = -1
	SET @IdCurrentAssociate = -1

	--Getting the id's for BUDGET_COST_TYPES
	SELECT @IdTE = dbo.fnGetBudgetOtherCostType('T&E'),
	       @IdProtoParts = dbo.fnGetBudgetOtherCostType('Proto parts'),
	       @IdProtoTooling = dbo.fnGetBudgetOtherCostType('Proto tooling'),
	       @IdTrials = dbo.fnGetBudgetOtherCostType('Trials'),
	       @IdOtherExpenses = dbo.fnGetBudgetOtherCostType('Other expenses')
			
	OPEN RevisedBudgetData
	FETCH NEXT FROM RevisedBudgetData INTO @IdRow, @ProjectCode, @WPCode, @AssociateNumber, @CountryCode, 
		@CostCenterCode, @HoursQty, @HoursVal, @SalesVal, @TE, @ProtoParts, @ProtoTooling, @Trials, 
		@OtherExpenses, @CurrencyCode
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		DECLARE @IdPhase int
		DECLARE @IdWP int
		DECLARE @IdCostCenter int
		DECLARE @IdAssociate int
		DECLARE @YearMonth int		

		--transform usual code into Id
		SELECT @IdProject = Id 
		FROM PROJECTS P 
		WHERE P.Code = @ProjectCode
	
		SELECT  @IdPhase = IdPhase, 
			@IdWP = Id, 
			@YearMonth = StartYearMonth 
		FROM WORK_PACKAGES WP 
		WHERE WP.IdProject =@IdProject AND 
		      WP.Code = @WPCode

		SELECT @IdCountry = Id
		FROM COUNTRIES C
		WHERE   C.Code = @CountryCode
	
		SELECT @IdCostCenter = CC.Id 
		FROM COST_CENTERS CC 	
		INNER JOIN INERGY_LOCATIONS IL 
		        ON CC.IdInergyLocation = IL.Id 
		WHERE   IL.IdCountry = @IdCountry AND
			CC.Code = @CostCenterCode

		SELECT @IdAssociate = Id 
		FROM ASSOCIATES A 
		WHERE A.EmployeeNumber = @AssociateNumber
		
		--Prepare the Insertion
		IF ( @IdCurrentProject <> @IdProject )
		BEGIN 
			SET @IdCurrentProject = @IdProject
			select @IdGenerationNew = isnull(max(IdGeneration),0) + 1
									FROM BUDGET_REVISED TABLOCKX
									WHERE 	IdProject = @IdProject AND
									IsValidated = 1
			insert into BUDGET_REVISED
			select @IdProject, @IdGenerationNew, 0, getdate()
			IF ( @@ERROR <> 0 OR @RetVal < 0 )
			BEGIN
				CLOSE RevisedBudgetData
				DEALLOCATE RevisedBudgetData
				return -2
			END
		END
			
		IF ( @IdCurrentAssociate <> @IdAssociate )
		BEGIN
			SET @IdCurrentAssociate = @IdAssociate
			-- insert state
			INSERT INTO BUDGET_REVISED_STATES
				(IdProject, IdGeneration, IdAssociate, State, StateDate)
			VALUES 
				(@IdProject, @IdGenerationNew, @IdAssociate, 'U', GETDATE())

			IF( @@ERROR <> 0)
			BEGIN
				CLOSE RevisedBudgetData
				DEALLOCATE RevisedBudgetData
				return -3
			END
		END

		exec @RetVal = bgtInsertRevisedBudgetDetail @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -4
		END

		exec @RetVal = bgtUpdateRevisedBudgetDetailForUplodRevisedBudget @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @HoursQty, @SalesVal
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -5
		END

		exec @RetVal = bgtInsertRevisedBudgetOtherCosts @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdTE
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN	
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -6
		END
			
		exec @RetVal = bgtUpdateRevisedBudgetOtherCosts @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdTE, @TE
		IF (@@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -7
		END
		
		exec @RetVal = bgtInsertRevisedBudgetOtherCosts @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdProtoParts
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -8
		END
		
		exec @RetVal = bgtUpdateRevisedBudgetOtherCosts @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdProtoParts, @ProtoParts
		IF ( @@ERROR <> 0 OR @RetVal < 0 ) 
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -9
		END

		exec @RetVal = bgtInsertRevisedBudgetOtherCosts @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdProtoTooling
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -10
		END
		
		exec @RetVal = bgtUpdateRevisedBudgetOtherCosts @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdProtoTooling, @ProtoTooling
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -11
		END

		exec @RetVal = bgtInsertRevisedBudgetOtherCosts @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdTrials
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -12
		END
		
		exec @RetVal = bgtUpdateRevisedBudgetOtherCosts @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdTrials, @Trials
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -13
		END

		exec @RetVal = bgtInsertRevisedBudgetOtherCosts @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdOtherExpenses
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -14
		END
		
		exec @RetVal = bgtUpdateRevisedBudgetOtherCosts @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdOtherExpenses, @OtherExpenses
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			return -15
		END
		
		FETCH NEXT FROM RevisedBudgetData INTO @IdRow, @ProjectCode, @WPCode, @AssociateNumber, @CountryCode
		, @CostCenterCode, @HoursQty, @HoursVal, @SalesVal, @TE, @ProtoParts, @ProtoTooling, @Trials
		, @OtherExpenses, @CurrencyCode


	END
	CLOSE RevisedBudgetData
	DEALLOCATE RevisedBudgetData

	--Group by IdProject, IdPhase, IdWp
	CREATE TABLE #BudgetRevised
	(
		IdProject INT NOT NULL,
		IdPhase INT NOT NULL ,
		IdWP INT NOT NULL,
		StartYearMonth int NULL,
		EndYearMonth int NULL
	)
	INSERT INTO #BudgetRevised(IdProject, IdPhase, IdWP, StartYearMonth, EndYearMonth)	
	SELECT 
		BId.IdProject,
		BId.IdPhase,
		BId.IdWorkPackage,
		NULL,
		NULL
	FROM 
		BUDGET_REVISED_DETAIL BId
	WHERE 
		BId.IdProject = @IdProject
	GROUP BY 
		BId.IdProject, 
		BId.IdPhase, 
		BId.IdWorkPackage
	
	UPDATE t
	SET StartYearMonth = wp.StartYearMonth,
	    EndYearMonth =  wp.EndYearMonth
	FROM #BudgetRevised t
	INNER JOIN WORK_PACKAGES wp
		on t.IdProject = wp.IdProject AND 
		   t.IdPhase = wp.IdPhase AND
		   t.IdWP = wp.Id
		
	--Prepare to split the data
	DECLARE RevisedBudgetData CURSOR FAST_FORWARD FOR
		SELECT
			IdProject,
			IdPhase,
			IdWP,
			StartYearMonth,
			EndYearMonth
		FROM #BudgetRevised	
	SET @IdProject = NULL
	SET @IdPhase = NULL
	SET @IdWp = NULL
	DECLARE @StartYearMonth int
	DECLARE @EndYearMonth int
		
	OPEN RevisedBudgetData	
	FETCH NEXT FROM RevisedBudgetData INTO @IdProject, @IdPhase, @IdWp, @StartYearMonth, @EndYearMonth
	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec @RetVal = bgtUpdateRevisedWPPeriod @IdProject, @IdPhase, @IdWp, @StartYearMonth, @EndYearMonth
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE RevisedBudgetData
			DEALLOCATE RevisedBudgetData
			DROP TABLE #BudgetRevised
			return -16
		END	
		
		FETCH NEXT FROM RevisedBudgetData INTO @IdProject, @IdPhase, @IdWp, @StartYearMonth, @EndYearMonth
	END
	CLOSE RevisedBudgetData
	DEALLOCATE RevisedBudgetData	

	if @IdGenerationNew > 1
	   begin
		
			select a.IdAssociate 
			into #tenpAssociatesToBeNulledInNewVersion
			from
			(
	   			select IdAssociate 
				from BUDGET_REVISED_STATES a
				where IdGeneration=@IdGenerationNew - 1
				and IdProject=@IdProject
			) a
			left join
			(
	   			select IdAssociate
				from BUDGET_REVISED_STATES a
				where IdGeneration=@IdGenerationNew
				and IdProject=@IdProject
			) b on a.IdAssociate = b.IdAssociate
			where b.IdAssociate is  null

			insert into BUDGET_REVISED_DETAIL
			select IdProject, @IdGenerationNew, IdPhase, IdWorkPackage, IdCostCenter, a.IdAssociate, YearMonth,0,0,0,IdCountry,IdAccountHours,IdAccountSales
			from BUDGET_REVISED_DETAIL  a
			join #tenpAssociatesToBeNulledInNewVersion b on a.IdAssociate = b.IdAssociate
			where IdProject=@IdProject
			and IdGeneration = @IdGenerationNew - 1

			insert BUDGET_REVISED_DETAIL_COSTS
			select IdProject, @IdGenerationNew, IdPhase, IdWorkPackage, IdCostCenter, a.IdAssociate, YearMonth, IdCostType,0,IdCountry,IdAccount
			from BUDGET_REVISED_DETAIL_COSTS a 
			join #tenpAssociatesToBeNulledInNewVersion b on a.IdAssociate = b.IdAssociate
			where IdProject=@IdProject
			and IdGeneration = @IdGenerationNew - 1
	   end


GO

