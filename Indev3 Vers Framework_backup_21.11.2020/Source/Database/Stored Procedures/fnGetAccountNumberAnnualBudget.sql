--Drops the Function fnGetAccountNumberAnnualBudget if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetAccountNumberAnnualBudget]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetAccountNumberAnnualBudget]
GO

-- Hours : 10000000 Hours
-- T&E : 10000001 T&E
-- Proto parts : 10000002 Proto parts
-- Proto Tooling : 10000003 Proto Tooling
-- Trials : 10000004 Trials
-- Other Expenses : 10000005 Other Expenses
-- Sales : 10000006 Sales

CREATE   FUNCTION fnGetAccountNumberAnnualBudget
	(@IdCostType INT)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @Account_Number	VARCHAR(20)
	DECLARE @BudgetCostName VARCHAR(50)



	SELECT @BudgetCostName = NAME 
	FROM BUDGET_COST_TYPES 
	WHERE ID = @IdCostType

	SELECT @Account_Number = DefaultAccount
	FROM COST_INCOME_TYPES
	WHERE Name = @BudgetCostName

    	RETURN @Account_Number
END

GO

