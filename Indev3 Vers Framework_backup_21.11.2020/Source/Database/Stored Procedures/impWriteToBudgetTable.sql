IF EXISTS (SELECT * FROM dbo.sysobjects WHERE Id = object_id(N'dbo.impWriteToBudgetTable') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteToBudgetTable
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[impWriteToBudgetTable]
	@IdImport INT			-- Id of the import	
AS	

	DECLARE @errMsg varchar(255)

	--Verify if the IdImport exists
	IF NOT EXISTS(
		SELECT IBI.IdImport
		FROM IMPORT_BUDGET_INITIAL IBI
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
			--Employee Number and country doesn't exist in Associates
			OR NOT EXISTS
			(
				SELECT * 
				FROM ASSOCIATES A 
				join Countries c on A.IdCountry = c.ID
				WHERE A.EmployeeNumber = IBI.AssociateNumber 
				and c.Code = IBI.CountryCode
			) 
			-- IdAssociate and IdProject doesn't exist in PROJECT_CORE_TEAMS
			OR NOT EXISTS
			(
				select *
				from COUNTRIES c
				cross join ASSOCIATES a
				cross join PROJECTS p
				left join PROJECT_CORE_TEAMS t on t.IdProject = p.Id and t.IdAssociate = a.Id
				where c.Code = IBI.CountryCode
				and a.EmployeeNumber = IBI.AssociateNumber 
				and p.Code = IBI.ProjectCode
				and t.IdProject is null
			)
			--NO Project ready for Initial Budget
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
			--CHECK IF THE KEY ( IdProject, IdAssociate, IdWorkPackage, IdCostCenter ) already exists 
			OR EXISTS
			(
				SELECT  BID.IdProject AS Id,
					BID.IdProject AS IdWorkPackage,
					BID.IdAssociate AS IdAssociate,
					BID.IdCostCenter AS IdCostCenter	 
				FROM BUDGET_INITIAL_DETAIL BID
				INNER JOIN PROJECTS P
					ON BID.IdProject = P.Id
				INNER JOIN WORK_PACKAGES WP 
					ON BID.IdProject = WP.IdProject AND
					   BID.IdPhase = WP.IdPhase AND
					   BID.IdWorkPackage = WP.Id
				INNER JOIN ASSOCIATES A 
					ON BID.IdAssociate = A.Id
				INNER JOIN COUNTRIES C
					ON BID.IdCountry = C.Id
				INNER JOIN COST_CENTERS CC
					ON BID.IdCostCenter = CC.Id
				WHERE	IBI.ProjectCode = P.Code AND
					IBI.WPCode = WP.Code AND
					A.EmployeeNumber = IBI.AssociateNumber AND
					C.Code = IBI.CountryCode AND
					CC.Code = IBI.CostCenterCode
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
			--CHECK the HoursQty, HoursVal, SalesVal as in UI
			OR (IBI.HoursQty IS NULL OR IBI.HoursQty < 0) 
			OR (IBI.HoursVal IS NULL OR IBI.HoursVal < 0)
			OR IBI.SalesVal IS NULL
		)
		
	)	
	BEGIN
		CREATE TABLE #tempTable
		(
			IdImport int,
			IdRow int,
			Details varchar(255),
			Module char(3)
		)
		DECLARE @Module VARCHAR(50)
		DECLARE @Details varchar(255)
		
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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

		--AssociateNumber and country not found in Associates
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Associate Number '''  + ISNULL(IBI.AssociateNumber,'N/A') + ''' from country ' +  
					c.Code + ' exist in import file, but this combination wasn''t found in Associates table.'
				 + ' Process cannot continue.'
			,@Module
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
		join Countries c on IBI.CountryCode = c.Code
		left join ASSOCIATES a on IBI.AssociateNumber = a.EmployeeNumber and c.Id = a.IdCountry
		WHERE  IBI.IdImport = @IdImport and a.Id is null
	

		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Associate Number '''  + ISNULL(IBI.AssociateNumber,'N/A') + ''' from country ' +  
					c.Code + ' exist in import file, but the corresponding Associate doesn''t exist in Project Core Team.'
			,@Module
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
		join Countries c on IBI.CountryCode = c.Code
		join PROJECTS p on IBI.ProjectCode = p.Code
		join ASSOCIATES a on IBI.AssociateNumber = a.EmployeeNumber and c.Id = a.IdCountry
		left join PROJECT_CORE_TEAMS t on t.IdProject = p.Id and t.IdAssociate = a.Id
		WHERE  IBI.IdImport = @IdImport and t.IdAssociate is null


		---- ########## CHECK 5		
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'Currency Code is N/A!'
			,NULL
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		
		--CHECK if the project is ready for Initial Budget ( with explicit messages )
		IF EXISTS
		(
			SELECT IBI.IdImport				
			FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
				'Project code ''' + ISNULL(IBI.ProjectCode, 'N/A' ) + ''' is not ready for Initial Budget ( Project is not active ).',
				NULL
			FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
				'Project code ''' + ISNULL(IBI.ProjectCode, 'N/A' ) + ''' is not ready for Initial Budget ( Project does not have WPs with defined period ).',
				NULL
			FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
				'Project code ''' + ISNULL(IBI.ProjectCode, 'N/A' ) + ''' is not ready for Initial Budget ( Project has no interco defined ).',
				NULL
			FROM IMPORT_BUDGET_INITIAL_DETAILS IBI
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
			IMPORT_BUDGET_INITIAL_DETAILS IBI
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
		       'The key (Project ''' + ISNULL(IBI.ProjectCode, 'N/A') + ''', AssociateNumber ''' + ISNULL(IBI.AssociateNumber, 'N/A') + ''', WPCode ''' + ISNULL(IBI.WPCode, 'N/A') + ''', CostCenterCode ''' + ISNULL(IBI.CostCenterCode, 'N/A') + ''' ) already exists in the budget table.',
			NULL
		FROM 
			IMPORT_BUDGET_INITIAL_DETAILS IBI
			INNER JOIN PROJECTS P 
				ON P.Code = IBI.ProjectCode
			INNER JOIN WORK_PACKAGES WP 
				ON P.Id = WP.IdProject  
				AND WP.Code = IBI.WPCode
			INNER JOIN ASSOCIATES A 
				ON A.EmployeeNumber = IBI.AssociateNumber
			INNER JOIN COUNTRIES C 
				ON C.Code = IBI.CountryCode
			INNER JOIN COST_CENTERS CC 
				ON CC.Code = IBI.CostCenterCode
			INNER JOIN BUDGET_INITIAL_DETAIL BId 
				ON P.Id = BId.IdProject AND
				   WP.IdPhase = BId.IdPhase AND
				   WP.Id = BId.IdWorkPackage AND
				   A.Id = BId.IdAssociate AND
				   CC.Id = BId.IdCostCenter
		WHERE
			IBI.IdImport = @IdImport 

		--CHECK if HoursQty, HoursVal, SalesVal follow the same rules as in UI
		INSERT INTO #tempTable
		(
			IdImport, IdRow, Details, Module
		)
		SELECT @IdImport, IBI.IdRow,
			'HoursQty ''' + ISNULL(CONVERT(char(20), IBI.HoursQty), 'N/A') + ''' must be a non-empty positive number. HoursVal ''' + ISNULL(CONVERT(char(20),IBI.HoursVal), 'N/A') + ''' must be a non-empty positive number. SalesVal ''' + ISNULL(CONVERT(char(20),IBI.SalesVal), 'N/A' + ''' must be a non-empty number.'),
			NULL
		FROM
			IMPORT_BUDGET_INITIAL_DETAILS IBI
		WHERE
			IBI.IdImport = @IdImport AND
			((IBI.HoursQty IS NULL OR IBI.HoursQty < 0) 
			OR (IBI.HoursVal IS NULL OR IBI.HoursVal < 0)
			OR IBI.SalesVal IS NULL )
		
		SELECT TOP 1 @Details =Details FROM #tempTable

		IF @@RowCount > 0
		BEGIN
			RAISERROR( @Details,16,1)
			RETURN -1
		END
	END		
	
	--Declare the cursor for import the data
	DECLARE InitialBudgetData CURSOR FAST_FORWARD FOR
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
		FROM IMPORT_BUDGET_INITIAL_DETAILS
		WHERE IdImport = @IdImport	
	
	
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
	SET @IdCurrentProject   = -1
	SET @IdCurrentAssociate = -1

	--Getting the id's for BUDGET_COST_TYPES
	SELECT @IdTE = dbo.fnGetBudgetOtherCostType('T&E'),
	       @IdProtoParts = dbo.fnGetBudgetOtherCostType('Proto parts'),
	       @IdProtoTooling = dbo.fnGetBudgetOtherCostType('Proto tooling'),
	       @IdTrials = dbo.fnGetBudgetOtherCostType('Trials'),
	       @IdOtherExpenses = dbo.fnGetBudgetOtherCostType('Other expenses')
			
	OPEN InitialBudgetData
	FETCH NEXT FROM InitialBudgetData INTO @IdRow, @ProjectCode, @WPCode, @AssociateNumber, @CountryCode, 
		@CostCenterCode, @HoursQty, @HoursVal, @SalesVal, @TE, @ProtoParts, @ProtoTooling, @Trials, 
		@OtherExpenses, @CurrencyCode
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @IdProject int
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
		WHERE A.EmployeeNumber = @AssociateNumber and A.IdCountry = @IdCountry
		
		--Prepare the Insertion
		IF ( @IdCurrentProject <> @IdProject )
		BEGIN 
			SET @IdCurrentProject = @IdProject
			exec @RetVal = bgtInsertInitialBudget @IdProject
			IF ( @@ERROR <> 0 OR @RetVal < 0 )
			BEGIN
				CLOSE InitialBudgetData
				DEALLOCATE InitialBudgetData
				return -2
			END
		END
		
		IF ( @IdCurrentAssociate <> @IdAssociate )
		BEGIN
			SET @IdCurrentAssociate = @IdAssociate
			exec @RetVal = bgtUpdateInitialBudgetStates @IdProject, @IdAssociate, 'U'
			IF( @@ERROR <> 0 OR @RetVal < 0 )
			BEGIN
				CLOSE InitialBudgetData
				DEALLOCATE InitialBudgetData
				return -3
			END
		END

		exec @RetVal = bgtInsertInitialBudgetDetail @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -4
		END
		exec @RetVal = bgtUpdateInitialBudgetDetail @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @HoursQty, @HoursVal, @SalesVal
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -5
		END

		exec @RetVal = bgtInsertInitialBudgetOtherCost @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdTE
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN	
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -6
		END
			
		exec @RetVal = bgtUpdateInitialBudgetOtherCost @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdTE, @TE
		IF (@@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -7
		END
		
		exec @RetVal = bgtInsertInitialBudgetOtherCost @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdProtoParts
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -8
		END
		
		exec @RetVal = bgtUpdateInitialBudgetOtherCost @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdProtoParts, @ProtoParts
		IF ( @@ERROR <> 0 OR @RetVal < 0 ) 
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -9
		END

		exec @RetVal = bgtInsertInitialBudgetOtherCost @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdProtoTooling
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -10
		END
		
		exec @RetVal = bgtUpdateInitialBudgetOtherCost @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdProtoTooling, @ProtoTooling
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -11
		END

		exec @RetVal = bgtInsertInitialBudgetOtherCost @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdTrials
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -12
		END
		
		exec @RetVal = bgtUpdateInitialBudgetOtherCost @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdTrials, @Trials
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -13
		END

		exec @RetVal = bgtInsertInitialBudgetOtherCost @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdOtherExpenses
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -14
		END
		
		exec @RetVal = bgtUpdateInitialBudgetOtherCost @IdProject, @IdPhase, @IdWP, @IdCostCenter, @IdAssociate, @YearMonth, @IdOtherExpenses, @OtherExpenses
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			return -15
		END
		
		FETCH NEXT FROM InitialBudgetData INTO @IdRow, @ProjectCode, @WPCode, @AssociateNumber, @CountryCode
		, @CostCenterCode, @HoursQty, @HoursVal, @SalesVal, @TE, @ProtoParts, @ProtoTooling, @Trials
		, @OtherExpenses, @CurrencyCode
	END
	CLOSE InitialBudgetData
	DEALLOCATE InitialBudgetData

	--Group by IdProject, IdPhase, IdWp
	CREATE TABLE #BudgetInitial
	(
		IdProject INT NOT NULL,
		IdPhase INT NOT NULL ,
		IdWP INT NOT NULL,
		StartYearMonth int NULL,
		EndYearMonth int NULL
	)
	INSERT INTO #BudgetInitial(IdProject, IdPhase, IdWP, StartYearMonth, EndYearMonth)	
	SELECT 
		BId.IdProject,
		BId.IdPhase,
		BId.IdWorkPackage,
		NULL,
		NULL
	FROM 
		BUDGET_INITIAL_DETAIL BId
	WHERE 
		BId.IdProject = @IdProject
	GROUP BY 
		BId.IdProject, 
		BId.IdPhase, 
		BId.IdWorkPackage
	
	UPDATE t
	SET StartYearMonth = wp.StartYearMonth,
	    EndYearMonth =  wp.EndYearMonth
	FROM #BudgetInitial t
	INNER JOIN WORK_PACKAGES wp
		on t.IdProject = wp.IdProject AND 
		   t.IdPhase = wp.IdPhase AND
		   t.IdWP = wp.Id
		
	--Prepare to split the data
	DECLARE InitialBudgetData CURSOR FAST_FORWARD FOR
		SELECT
			IdProject,
			IdPhase,
			IdWP,
			StartYearMonth,
			EndYearMonth
		FROM #BudgetInitial	
	SET @IdProject = NULL
	SET @IdPhase = NULL
	SET @IdWp = NULL
	DECLARE @StartYearMonth int
	DECLARE @EndYearMonth int
		
	OPEN InitialBudgetData	
	FETCH NEXT FROM InitialBudgetData INTO @IdProject, @IdPhase, @IdWp, @StartYearMonth, @EndYearMonth
	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec @RetVal = bgtUpdateInitialWPPeriod @IdProject, @IdPhase, @IdWp, @StartYearMonth, @EndYearMonth
		IF ( @@ERROR <> 0 OR @RetVal < 0 )
		BEGIN
			CLOSE InitialBudgetData
			DEALLOCATE InitialBudgetData
			DROP TABLE #BudgetInitial
			return -16
		END	
		
		FETCH NEXT FROM InitialBudgetData INTO @IdProject, @IdPhase, @IdWp, @StartYearMonth, @EndYearMonth
	END
	CLOSE InitialBudgetData
	DEALLOCATE InitialBudgetData	



GO


