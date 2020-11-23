--Drops the Procedure catDeleteGlAccount if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteGlAccount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteGlAccount
GO
CREATE PROCEDURE catDeleteGlAccount
	@IdCountry	AS INT,		--The Id of the Country connected to the selected GL Account
	@Id		AS INT		--The Id of the selected GL Account

AS
	DECLARE @RowCount INT
	DECLARE @AccountName VARCHAR(30)

	--Check that the account is not used in the budget tables
	IF (
	EXISTS 
		(SELECT IdAccountHours 
		FROM 	BUDGET_INITIAL_DETAIL
		WHERE 	IdAccountHours = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS
		(SELECT IdAccountSales
		FROM 	BUDGET_INITIAL_DETAIL
		WHERE 	IdAccountSales = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS
		(SELECT IdAccount
		FROM 	BUDGET_INITIAL_DETAIL_COSTS
		WHERE 	IdAccount = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS 
		(SELECT IdAccountHours 
		FROM 	BUDGET_REVISED_DETAIL
		WHERE 	IdAccountHours = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS
		(SELECT IdAccountSales
		FROM 	BUDGET_REVISED_DETAIL
		WHERE 	IdAccountSales = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS
		(SELECT IdAccount
		FROM 	BUDGET_REVISED_DETAIL_COSTS
		WHERE 	IdAccount = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS 
		(SELECT IdAccountHours 
		FROM 	BUDGET_TOCOMPLETION_DETAIL
		WHERE 	IdAccountHours = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS
		(SELECT IdAccountSales
		FROM 	BUDGET_TOCOMPLETION_DETAIL
		WHERE 	IdAccountSales = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS
		(SELECT IdAccount
		FROM 	BUDGET_TOCOMPLETION_DETAIL_COSTS
		WHERE 	IdAccount = @Id AND
			IdCountry = @IdCountry)
	)
	BEGIN
		SELECT 	@AccountName = [Name] 
		FROM 	GL_ACCOUNTS
		WHERE 	IdCountry = @IdCountry AND
			[Id] = @Id 
		
		RAISERROR('Could not delete the account %s because it is used in the Budget tables',16,1,@AccountName)
		RETURN -1
	END

	--Check that the account is not used in the actual data tables
	IF (
	EXISTS 
		(SELECT IdAccount 
		FROM 	ACTUAL_DATA_DETAILS_HOURS
		WHERE 	IdAccount = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS
		(SELECT IdAccount
		FROM 	ACTUAL_DATA_DETAILS_SALES
		WHERE 	IdAccount = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS
		(SELECT IdAccount
		FROM 	ACTUAL_DATA_DETAILS_COSTS
		WHERE 	IdAccount = @Id AND
			IdCountry = @IdCountry)
	)
	BEGIN
		SELECT 	@AccountName = [Name] 
		FROM 	GL_ACCOUNTS
		WHERE 	IdCountry = @IdCountry AND
			[Id] = @Id 
		
		RAISERROR('Could not delete the account %s because it is used in the ACTUAL DATA Tables',16,1,@AccountName)
		RETURN -2
	END
	
	--Check that the account is not used in the annual tables

	IF (
	EXISTS 
		(SELECT IdAccount 
		FROM 	ANNUAL_BUDGET_DATA_DETAILS_HOURS
		WHERE 	IdAccount = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS
		(SELECT IdAccount
		FROM 	ANNUAL_BUDGET_DATA_DETAILS_SALES
		WHERE 	IdAccount = @Id AND
			IdCountry = @IdCountry)
	OR
	EXISTS
		(SELECT IdAccount
		 FROM	ANNUAL_BUDGET_DATA_DETAILS_COSTS
	 	 WHERE IdAccount = @Id AND
		       IdCountry = @IdCountry)
	)
	BEGIN
		SELECT 	@AccountName = [Name] 
		FROM 	GL_ACCOUNTS
		WHERE 	IdCountry = @IdCountry AND
			[Id] = @Id 
		RAISERROR('Could not delete the account %s because it is used in the Annual tables',16,1,@AccountName)
		RETURN -3
	END

	DELETE FROM GL_ACCOUNTS
	WHERE 	IdCountry = @IdCountry AND
		[Id] = @Id 

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

