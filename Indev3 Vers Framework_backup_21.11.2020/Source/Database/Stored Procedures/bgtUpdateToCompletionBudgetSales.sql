--Drops the Procedure bgtGetToCompletionBudgetHoursEvidence if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateToCompletionBudgetSales]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateToCompletionBudgetSales
GO

CREATE  PROCEDURE bgtUpdateToCompletionBudgetSales
	@IdAssociate		INT,
	@IdProject		INT,
	@IdPhase		INT,
	@IdWP			INT,
	@IdCostCenter		INT,
	@YearMonth		INT,
	@Sales			DECIMAL(18, 2),
	@ActualDataTimestamp	DATETIME
AS
	--Get the new generation Id
	DECLARE @NewGeneration		INT
	SET @NewGeneration = dbo.fnGetToCompletionBudgetGeneration(@IdProject,'N')
	IF (@NewGeneration IS NULL)
	BEGIN
		RAISERROR('No new generation found for To Completion budget', 16, 1)
		RETURN
	END

	IF 
	(
		EXISTS 
		(
			SELECT 	I.ImportDate
			FROM	ACTUAL_DATA_DETAILS_HOURS AD
			INNER JOIN IMPORTS I ON
				AD.IdImport = I.IdImport
			WHERE 	AD.IdProject = @IdProject AND
				I.ImportDate > @ActualDataTimestamp
		)
		OR
		EXISTS 
		(
			SELECT 	I.ImportDate
			FROM	ACTUAL_DATA_DETAILS_SALES AD
			INNER JOIN IMPORTS I ON
				AD.IdImport = I.IdImport
			WHERE 	AD.IdProject = @IdProject AND
				I.ImportDate > @ActualDataTimestamp
		)
		OR
		EXISTS 
		(
			SELECT 	I.ImportDate
			FROM	ACTUAL_DATA_DETAILS_COSTS AD
			INNER JOIN IMPORTS I ON
				AD.IdImport = I.IdImport
			WHERE 	AD.IdProject = @IdProject AND
				I.ImportDate > @ActualDataTimestamp
		)
	)
	BEGIN
		RAISERROR('Please reload your budget, the actual data your budget is based on has changed.', 16, 1)
		RETURN
	END

	IF NOT EXISTS (
		SELECT 
			IdProject
		FROM 	BUDGET_TOCOMPLETION_DETAIL
		WHERE	IdProject = @IdProject
		AND	IdGeneration = @NewGeneration
		AND	IdPhase = @IdPhase
		AND	IdWorkPackage = @IdWP
		AND	IdCostCenter = @IdCostCenter
		AND	IdAssociate = @IdAssociate
		AND 	YearMonth = @YearMonth		
	)
	BEGIN
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


		INSERT INTO BUDGET_TOCOMPLETION_DETAIL 
			(IdProject,   IdGeneration,   IdPhase,  IdWorkPackage,  IdCostCenter,  IdAssociate,  YearMonth,  HoursQty, SalesVal, HoursVal,  IdCountry,  IdAccountHours,  IdAccountSales)
		VALUES (@IdProject,   @NewGeneration, @IdPhase, @IdWP         , @IdCostCenter, @IdAssociate, @YearMonth, NULL, 	   @Sales,   NULL,	@IdCountry, @IdAccountHours, @IdAccountSales)
	END
	ELSE
	BEGIN
		UPDATE 	BUDGET_TOCOMPLETION_DETAIL
		SET 	SalesVal = @Sales
		WHERE	IdProject = @IdProject
		AND	IdGeneration = @NewGeneration
		AND	IdPhase = @IdPhase
		AND	IdWorkPackage = @IdWP
		AND	IdCostCenter = @IdCostCenter
		AND	IdAssociate = @IdAssociate
		AND 	YearMonth = @YearMonth
	END
GO

