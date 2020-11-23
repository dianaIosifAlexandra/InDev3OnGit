--Drops the Procedure bgtInsertRevisedBudgetOtherCost if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtInsertRevisedBudgetOtherCosts]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtInsertRevisedBudgetOtherCosts
GO

CREATE  PROCEDURE bgtInsertRevisedBudgetOtherCosts
	@IdProject		INT,		--The Id of project
	@IdPhase		INT,		--The Id of phase
	@IdWP			INT,		--The Id of workpackage
	@IdCostCenter		INT,		--The Id of cost center
	@IdAssociate		INT,		--The Id of associate
	@YearMonth		INT,		--Year and month
	@IdCostType		INT
AS
BEGIN
	Declare	@ErrorMessage		VARCHAR(255),
			@YMValidationResult	INT

	-- verify if the yearmonth value is valid
	Select @YMValidationResult = ValidationResult,
	       @ErrorMessage = ErrorMessage
	from fnValidateYearMonth(@YearMonth)

	if (@YMValidationResult < 0)
	begin
	 	RAISERROR(@ErrorMessage, 16, 1)
		RETURN -1
	end

	DECLARE @IdGeneration INT
	SELECT @IdGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,'N')

	IF (@IdGeneration IS NULL)
	BEGIN
		RAISERROR('No new budget version found for Revised Budget', 16, 1)
		RETURN -2
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
		RETURN -3
	END

	DECLARE @IdAccount INT

	--Select the account id for the given cost type
	SELECT 	@IdAccount = GLA.[Id]
	FROM 	GL_ACCOUNTS GLA
	INNER JOIN COST_INCOME_TYPES CIT ON
	GLA.Account = CIT.DefaultAccount
	WHERE	GLA.IdCountry = @IdCountry AND
		CIT.[Id] = @IdCostType
	
	--insert other costs
	INSERT INTO BUDGET_REVISED_DETAIL_COSTS
		(IdProject,  IdGeneration,  IdPhase,  IdWorkPackage, IdCostCenter,  IdAssociate,  YearMonth,  IdCostType,  CostVal, IdCountry,  IdAccount)
	VALUES  (@IdProject, @IdGeneration, @IdPhase, @IdWP, 	     @IdCostCenter, @IdAssociate, @YearMonth, @IdCostType, NULL,    @IdCountry, @IdAccount)
	
END
GO


