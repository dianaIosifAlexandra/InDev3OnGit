--Drops the Procedure catUpdateGlAccount if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateGlAccount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateGlAccount
GO
CREATE PROCEDURE catUpdateGlAccount
	@Id		INT,		--The Id of the selected GlAccount
	@IdCountry	INT,		--The Id of the country
 	@Account	VARCHAR(20),	--The Code of the Inergy Location you want to Insert
	@Name		VARCHAR(30),	--The Name of the Inergy Location you want to Insert
	@IdCostType	INT		--The Id of the updated cost type related to the GL_ACCOUNT 
	
AS
DECLARE @Rowcount 		INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)
	
	SET @LogicalKey = 'Country, Account'

	IF EXISTS( SELECT *
	FROM GL_ACCOUNTS AS GA
	WHERE 	GA.Account = @Account AND 
		GA.IdCountry = @IdCountry AND
		GA.[Id] <> @Id) 
	SET @ValidateLogicKey = 1
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@IdCountry IS NULL OR 
	   @Account IS NULL OR 
	   @Name IS NULL OR 
	   @IdCostType IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END


	 -- A. check cost type change in the actual data
	IF (@IdCostType <> 6 AND
		EXISTS
		(
			SELECT 	IdAccount
			FROM 	ACTUAL_DATA_DETAILS_HOURS
			WHERE 	IdAccount = @Id AND
				IdCountry = @IdCountry
		)
	   )
	BEGIN
		RAISERROR('Cost type cannot be changed because account is used in Actual Data.', 16, 1)
		RETURN -3
	END

	IF (@IdCostType <> 7 AND
		EXISTS
		(
			SELECT 	IdAccount
			FROM 	ACTUAL_DATA_DETAILS_SALES
			WHERE 	IdAccount = @Id AND
				IdCountry = @IdCountry
		)
	   )
	BEGIN
		RAISERROR('Cost type cannot be changed because account is used in Actual Data.', 16, 1)
		RETURN -4
	END

	IF EXISTS
		(
			SELECT 	IdAccount
			FROM 	ACTUAL_DATA_DETAILS_COSTS
			WHERE 	IdAccount = @Id AND
				IdCountry = @IdCountry AND
				IdCostType <> @IdCostType
		)
	BEGIN

		IF @IdCostType NOT IN (6, 7) -- if the new cost type is still of type cost, change is allowed and update is made
		BEGIN
			UPDATE 	ACTUAL_DATA_DETAILS_COSTS
			SET IdCostType  = @IdCostType
			WHERE 	IdAccount = @Id AND
				IdCountry = @IdCountry
		END

		IF @IdCostType IN (6, 7)
		BEGIN
			RAISERROR('Cost type cannot be changed because account is used in Actual Data.', 16, 1)
			RETURN -5
		END
	END






	 -- B. check cost type change in the annual budget
	IF (@IdCostType <> 6 AND
		EXISTS
		(
			SELECT 	IdAccount
			FROM 	ANNUAL_BUDGET_DATA_DETAILS_HOURS
			WHERE 	IdAccount = @Id AND
				IdCountry = @IdCountry
		)
	   )
	BEGIN
		RAISERROR('Cannot change the cost type because account is used in Annual Budget.', 16, 1)
		RETURN -6
	END

	IF (@IdCostType <> 7 AND
		EXISTS
		(
			SELECT 	IdAccount
			FROM 	ANNUAL_BUDGET_DATA_DETAILS_SALES
			WHERE 	IdAccount = @Id AND
				IdCountry = @IdCountry
		)
	   )
	BEGIN
		RAISERROR('Cannot change the cost type because account is used in Annual Budget.', 16, 1)
		RETURN -7
	END

	IF (EXISTS
		(
			SELECT 	IdAccount
			FROM 	ANNUAL_BUDGET_DATA_DETAILS_COSTS
			WHERE 	IdAccount = @Id AND
				IdCountry = @IdCountry AND
				IdCostType <> @IdCostType
		)
	   )
	BEGIN
		IF @IdCostType NOT IN (6, 7) -- if the new cost type is still of type cost, change is allowed and update is made
		BEGIN
			UPDATE 	ANNUAL_BUDGET_DATA_DETAILS_COSTS
			SET IdCostType  = @IdCostType
			WHERE 	IdAccount = @Id AND
				IdCountry = @IdCountry
		END

		IF @IdCostType IN (6, 7)
		BEGIN
			RAISERROR('Cannot change the cost type because account is used in Annual Budget.', 16, 1)
			RETURN -8
		END
	END

		

	UPDATE GL_ACCOUNTS 	
	SET Account = @Account,
	    [Name] = @Name,
	    IdCostType = @IdCostType
	WHERE 	[Id] = @Id AND 
		IdCountry = @IdCountry

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

