--Drops the Procedure bgtGetToCompletionBudgetHoursEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtInsertToCompletionBudget]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtInsertToCompletionBudget
GO

CREATE  PROCEDURE bgtInsertToCompletionBudget
	@IdAssociate		INT,
	@IdProject		INT,
	@IdPhase		INT,
	@IdWP			INT,
	@IdCostCenter		INT
AS
	--Get the new generation Id
	DECLARE @NewGeneration		INT
	DECLARE @CurrentGeneration	INT
	DECLARE @RevisedGenerationNo 	INT

	DECLARE @RetVal INT
	
	SET @NewGeneration = dbo.fnGetToCompletionBudgetGeneration (@IdProject, 'N')
	SET @RevisedGenerationNo = dbo.fnGetRevisedBudgetGeneration(@IdProject,'C')

	IF (@NewGeneration IS NULL)
	BEGIN
		SET @CurrentGeneration = dbo.fnGetToCompletionBudgetGeneration(@IdProject,'C')
		IF (@CurrentGeneration IS NULL)
		BEGIN
			RAISERROR('No released generation found for To Completion budget', 16, 1)
			RETURN -1
		END
		SET @NewGeneration = @CurrentGeneration + 1
		
		EXEC @RetVal = bgtToCompletionBudgetCreateNewFromCurrentAll @IdProject = @IdProject, @NewGeneration = @NewGeneration
		IF (@@ERROR <> 0 OR @RetVal < 0)
			RETURN -2
	END


	IF (EXISTS 
	(SELECT IdProject FROM BUDGET_TOCOMPLETION_DETAIL AS BTD
	 WHERE 	BTD.IdProject = @IdProject AND
		BTD.IdGeneration = @NewGeneration AND
		BTD.IdPhase = @IdPhase AND
		BTD.IdWorkPackage = @IdWP AND
		BTD.IdCostCenter = @IdCostCenter AND
		BTD.IdAssociate = @IdAssociate
	)	
	OR 
	EXISTS
	(
	SELECT 	IdProject FROM BUDGET_REVISED_DETAIL AS BRD
	WHERE 	BRD.IdProject = @IdProject AND
		BRD.IdGeneration = @RevisedGenerationNo AND
		BRD.IdPhase = @IdPhase AND
		BRD.IdWorkPackage = @IdWP AND
		BRD.IdCostCenter = @IdCostCenter AND
		BRD.IdAssociate = @IdAssociate
	)
	OR
	EXISTS
	(
	SELECT 	IdProject FROM ACTUAL_DATA_DETAILS_HOURS AS AD
	WHERE 	AD.IdProject = @IdProject AND
		AD.IdPhase = @IdPhase AND
		AD.IdWorkPackage = @IdWP AND
		AD.IdCostCenter = @IdCostCenter
	)
	OR
	EXISTS
	(
	SELECT 	IdProject FROM ACTUAL_DATA_DETAILS_SALES AS AD
	WHERE 	AD.IdProject = @IdProject AND
		AD.IdPhase = @IdPhase AND
		AD.IdWorkPackage = @IdWP AND
		AD.IdCostCenter = @IdCostCenter
	)
	OR
	EXISTS
	(
	SELECT 	IdProject FROM ACTUAL_DATA_DETAILS_COSTS AS AD
	WHERE 	AD.IdProject = @IdProject AND
		AD.IdPhase = @IdPhase AND
		AD.IdWorkPackage = @IdWP AND
		AD.IdCostCenter = @IdCostCenter
	)
	)
	BEGIN
		DECLARE @CCName VARCHAR(50)
		DECLARE @WPName VARCHAR(50)
		DECLARE @ErrorMessage	VARCHAR(255)
		SELECT 	@CCName = DP.[Name]+'-'+IL.Code+'-'+CC.[Code],
			@WPName = WP.Code + '-' + WP.[Name]
		FROM	COST_CENTERS AS CC
		INNER 	JOIN DEPARTMENTS AS DP 
		ON	CC.IdDepartment = DP.[Id]
		INNER 	JOIN INERGY_LOCATIONS AS IL
		ON 	CC.IdInergyLocation = IL.[Id]
		INNER 	JOIN WORK_PACKAGES AS WP ON
			WP.IdProject = @IdProject AND
			WP.IdPhase = @IdPhase AND
			WP.[Id] = @IdWP
		WHERE 	CC.[Id] = @IdCostCenter
		

		--RAISERROR('Cost Center %s is already added.', 16, 1, @CCName)

		EXEC   auxSelectErrorMessage_2 @Code = 'DUPLICATE_COST_CENTER_1', @IdLanguage = 1, @Parameter1 = @CCName, @Parameter2 = @WPName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -3
	END 


	DECLARE @IdCountry INT
	DECLARE @CountryName VARCHAR(30)
	DECLARE @CostCenterName VARCHAR(50)
	DECLARE @CountryHasDefaultAccounts BIT

	SELECT 	@IdCountry = C.[Id],
		@CountryName = C.[Name],
		@CostCenterName = CC.[Name]
	FROM 	COST_CENTERS CC
	INNER 	JOIN INERGY_LOCATIONS IL ON
		CC.IdInergyLocation = IL.[Id]
	INNER 	JOIN COUNTRIES C ON
		IL.IdCountry = C.[Id]
	WHERE 	CC.[Id] = @IdCostCenter

	SELECT @CountryHasDefaultAccounts = dbo.fnCheckCountryDefaultAccounts(@IdCountry)

	IF (@CountryHasDefaultAccounts = 0)
	BEGIN
		RAISERROR('You do not have all the default accounts for Country %s to which the Cost Center %s belongs in your G/L Account catalogue.', 16, 1, @CountryName, @CostCenterName)
		RETURN -4
	END

	DECLARE @IdAccountHours INT
	DECLARE @IdAccountSales INT

	--Select the account id for hours
	SELECT 	@IdAccountHours = GLA.[Id]
	FROM 	GL_ACCOUNTS GLA
	INNER JOIN COST_INCOME_TYPES CIT ON
	GLA.Account = CIT.DefaultAccount
	WHERE	GLA.IdCountry = @IdCountry AND
		CIT.[Id] = 6

	--Select the account id for sales
	SELECT 	@IdAccountSales = GLA.[Id]
	FROM 	GL_ACCOUNTS GLA
	INNER JOIN COST_INCOME_TYPES CIT ON
	GLA.Account = CIT.DefaultAccount
	WHERE	GLA.IdCountry = @IdCountry AND
		CIT.[Id] = 7
		


	IF NOT EXISTS
	(
		SELECT 	IdProject
		FROM 	BUDGET_TOCOMPLETION_PROGRESS
		WHERE	IdProject = @IdProject AND
			IdGeneration = @NewGeneration AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP AND
			IdAssociate = @IdAssociate
	)
	BEGIN
		INSERT INTO BUDGET_TOCOMPLETION_PROGRESS 
			(IdProject,   IdGeneration,   IdPhase,  IdWorkPackage,   IdAssociate,  [Percent])
		VALUES (@IdProject,   @NewGeneration, @IdPhase, @IdWP         ,  @IdAssociate, 0)
	END

	DECLARE @StartYear INT
	DECLARE @StartMonth INT
	DECLARE @EndYear INT
	DECLARE @EndMonth INT

	SELECT 	@StartYear = StartYearMonth / 100,
		@StartMonth = StartYearMonth % 100,
		@EndYear = EndYearMonth / 100,
		@EndMonth = EndYearMonth % 100
	FROM 	WORK_PACKAGES AS WP
	WHERE 	WP.IdProject = @IdProject AND
		WP.IdPhase = @IdPhase AND
		WP.[Id] = @IdWP
	
	WHILE ((@StartYear < @EndYear) OR (@StartYear = @EndYear AND @StartMonth <= @EndMonth))
	BEGIN
		DECLARE @Date INT
		SET @Date = @StartYear * 100 + @StartMonth
		
		INSERT INTO BUDGET_TOCOMPLETION_DETAIL
			(IdProject, IdGeneration,   IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth, HoursQty,  HoursVal, SalesVal, IdCountry,  IdAccountHours,  IdAccountSales)
		VALUES (@IdProject, @NewGeneration, @IdPhase, @IdWP, 	     @IdCostCenter, @IdAssociate, @Date,     NULL,	NULL, 	  NULL,	    @IdCountry, @IdAccountHours, @IdAccountSales)

		DECLARE @CostType INT
		SET @CostType = 1
	
		WHILE (@CostType <= 5)
		BEGIN
			DECLARE @IdAccount INT

			--Select the account id for the given cost type
			SELECT 	@IdAccount = GLA.[Id]
			FROM 	GL_ACCOUNTS GLA
			INNER JOIN COST_INCOME_TYPES CIT ON
			GLA.Account = CIT.DefaultAccount
			WHERE	GLA.IdCountry = @IdCountry AND
				CIT.[Id] = @CostType
			
			INSERT INTO BUDGET_TOCOMPLETION_DETAIL_COSTS
				(IdProject,  IdGeneration,   IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth,   IdCostType, CostVal, IdCountry,  IdAccount)
			VALUES	(@IdProject, @NewGeneration, @IdPhase, @IdWP, 	      @IdCostCenter, @IdAssociate, @Date,	@CostType,  NULL,    @IdCountry, @IdAccount)
			SET @CostType = @CostType + 1
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
	
GO

