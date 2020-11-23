--Drops the Function fnCheckCountryDefaultAccounts if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnCheckCountryDefaultAccounts]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnCheckCountryDefaultAccounts]
GO
CREATE   FUNCTION fnCheckCountryDefaultAccounts
	(@IdCountry	INT)
RETURNS BIT
AS
BEGIN
	--Returns 1 if for the given country, all default accounts exist, 0 otherwise
	DECLARE @NoAccounts INT
	SET @NoAccounts = 0
	
	DECLARE CostIncomeCursor CURSOR FAST_FORWARD FOR
	SELECT 	DefaultAccount
	FROM	COST_INCOME_TYPES

	OPEN CostIncomeCursor
	DECLARE @DefaultAccountCostIncome VARCHAR(20)

	FETCH NEXT FROM CostIncomeCursor INTO @DefaultAccountCostIncome		
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS
		(
			SELECT 	*
			FROM 	GL_ACCOUNTS
			WHERE	IdCountry = @IdCountry AND
				Account = @DefaultAccountCostIncome
		)
		BEGIN
			SET @NoAccounts = @NoAccounts + 1
		END
		FETCH NEXT FROM CostIncomeCursor INTO @DefaultAccountCostIncome
	END
	
	CLOSE CostIncomeCursor
	DEALLOCATE CostIncomeCursor

	IF (@NoAccounts = 7)
		RETURN 1
	RETURN 0
END
GO

