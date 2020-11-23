--Drops the Function fnGetRevisedBudgetOtherCosts if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetRevisedBudgetOtherCosts]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetRevisedBudgetOtherCosts]
GO

CREATE   FUNCTION fnGetRevisedBudgetOtherCosts
	(@IdProject				INT,
	 @IdGeneration			INT,
	 @IdPhase				INT,
	 @IdWP					INT,
	 @IdCostCenter			INT,
	 @IdAssociate			INT,
	 @IsAssociateCurrency   BIT,
	 @AssociateCurrency	    INT)
RETURNS DECIMAL(19, 4)
AS
BEGIN
    DECLARE @OtherCosts DECIMAL(19, 4)

	SELECT @OtherCosts = SUM(CASE WHEN @IsAssociateCurrency = 1 THEN dbo.fnGetExchangeRate(dbo.fnGetCurrencyFromCC(IdCostCenter), @AssociateCurrency, YearMonth) ELSE 1 END *
							CostVal) 
    FROM BUDGET_REVISED_DETAIL_COSTS
    WHERE 	IdProject = @IdProject AND
			IdGeneration = @IdGeneration AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP AND
			IdCostCenter = @IdCostCenter AND
			IdAssociate = CASE WHEN @IdAssociate=-1 THEN IdAssociate ELSE @IdAssociate END

    RETURN @OtherCosts
END
GO



