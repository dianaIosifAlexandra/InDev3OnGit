--Drops the Procedure bgtInsertRevisedBudgetDetail if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtInsertRevisedBudgetDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtInsertRevisedBudgetDetail
GO

CREATE  PROCEDURE bgtInsertRevisedBudgetDetail
	@IdProject	INT,		--The Id of the selected Project
	@IdPhase	INT,		--The Id of a phase from project
	@IdWP		INT,		--The Id of workpackage
	@IdCostCenter	INT,		--The Id of cost center
	@IdAssociate	INT,		--The Id of associate
	@YearMonth	INT
AS
BEGIN
	DECLARE	@CostCenterName 	VARCHAR(50),
		@WPName			VARCHAR(50),
		@ErrorMessage		VARCHAR(255),
		@YMValidationResult	INT

	-- verify if the yearmonth value is valid
	SELECT @YMValidationResult = ValidationResult,
	       @ErrorMessage = ErrorMessage
	FROM fnValidateYearMonth(@YearMonth)

	IF (@YMValidationResult < 0)
	BEGIN
	 	RAISERROR(@ErrorMessage, 16, 1)
		RETURN -1
	END

	DECLARE @IdGeneration INT
	--Find a generation of a revised budget for the current project that is not validated (InProgress version of budget)
	SELECT @IdGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,'N')

	SET @CostCenterName = NULL
	SELECT 
		@CostCenterName = DP.[Name]+'-'+IL.Code+'-'+CC.[Code], --CC.[Name]
		@WPName = WP.Code + '-' + WP.[Name]
	FROM BUDGET_REVISED_DETAIL AS BRD (TABLOCKX)
	INNER JOIN COST_CENTERS AS CC ON
		CC.[Id] = @IdCostCenter
	INNER JOIN DEPARTMENTS AS DP ON
		DP.[Id] = CC.IdDepartment
	INNER JOIN INERGY_LOCATIONS AS IL ON
		IL.[Id] = CC.IdInergyLocation
	INNER JOIN WORK_PACKAGES AS WP ON
		WP.IdProject = @IdProject AND
		WP.IdPhase = @IdPhase AND
		WP.[Id] = @IdWP
	WHERE 	
		BRD.[IdCostCenter] = @IdCostCenter AND
		BRD.IdProject = @IdProject AND
		BRD.IdPhase = @IdPhase AND
		BRD.IdWorkPackage = @IdWP AND 
		BRD.YearMonth = @YearMonth AND
		BRD.IdAssociate = @IdAssociate AND
		BRD.IdGeneration = @IdGeneration


	IF (@CostCenterName IS NOT NULL)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DUPLICATE_COST_CENTER_1',@IdLanguage = 1, @Parameter1 = @CostCenterName, @Parameter2 = @WPName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2
	END

	DECLARE @IdCountry INT
	DECLARE @CountryName VARCHAR(30)
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
		RETURN -3
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
	
	
	--insert budget initial detail
	INSERT INTO BUDGET_REVISED_DETAIL
		(IdProject, IdGeneration,  IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth,  HoursQty,  HoursVal, SalesVal, IdCountry,  IdAccountHours,  IdAccountSales)
	VALUES  (@IdProject,@IdGeneration, @IdPhase, @IdWP,	    @IdCostCenter, @IdAssociate, @YearMonth, NULL, 	NULL,	  NULL,	    @IdCountry, @IdAccountHours, @IdAccountSales)
END
GO

