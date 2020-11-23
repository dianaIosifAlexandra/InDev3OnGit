--Drops the Procedure bgtInsertInitialBudgetOtherCost if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtInsertInitialBudgetOtherCost]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtInsertInitialBudgetOtherCost
GO

CREATE  PROCEDURE bgtInsertInitialBudgetOtherCost
	@IdProject		INT,		--The Id of detail from master table
	@IdPhase		INT,
	@IdWP			INT,
	@IdCostCenter		INT,
	@IdAssociate		INT,
	@YearMonth		INT,
	@IdCostType		INT		--The Id of other cost type
	
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
		RETURN -2
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
	INSERT INTO BUDGET_INITIAL_DETAIL_COSTS
			(IdProject,  IdPhase,  IdWorkpackage,IdCostCenter,  IdAssociate,  YearMonth,  IdCostType, CostVal, IdCountry,  IdAccount)
		VALUES  (@IdProject, @IdPhase, @IdWP, 	     @IdCostCenter, @IdAssociate, @YearMonth, @IdCostType, NULL,   @IdCountry, @IdAccount)
END
GO

