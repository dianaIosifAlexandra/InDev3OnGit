--Drops the Function fnGetRevisedBudgetSales if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetRevisedBudgetSales]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetRevisedBudgetSales]
GO

CREATE   FUNCTION fnGetRevisedBudgetSales
	(@IdProject				INT,
	 @IdGeneration			INT,
	 @IdPhase				INT,
	 @IdWP					INT,
	 @IdCostCenter			INT,
	 @IdAssociate			INT,
	 @IsAssociateCurrency   BIT,
	 @AssociateCurrency	    INT)
RETURNS DECIMAL(18, 4)
AS
BEGIN
    DECLARE @SalesVal DECIMAL(18, 4)

	SELECT @SalesVal = SUM(CASE WHEN @IsAssociateCurrency = 1 THEN	dbo.fnGetExchangeRate(dbo.fnGetCurrencyFromCC(IdCostCenter), @AssociateCurrency, YearMonth) ELSE 1 END *
							SalesVal) 
    FROM BUDGET_REVISED_DETAIL
    WHERE 	IdProject = @IdProject AND
			IdGeneration = @IdGeneration AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP AND
			IdCostCenter = @IdCostCenter AND
			IdAssociate = CASE 	WHEN @IdAssociate = -1 THEN IdAssociate ELSE @IdAssociate END

    RETURN @SalesVal
END
GO



