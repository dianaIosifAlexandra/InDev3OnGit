IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetRevisedBudgetHoursVal]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetRevisedBudgetHoursVal]
GO

CREATE   FUNCTION fnGetRevisedBudgetHoursVal
	(@IdProject				INT,
	@IdGeneration			INT,
	@IdPhase				INT,
	@IdWP					INT,
	@IdCostCenter			INT,
	@IdAssociate			INT,
	@UseHourlyRates			BIT,
	@IsAssociateCurrency	BIT,
	@AssociateCurrency		INT)
RETURNS DECIMAL(18,4)
AS
BEGIN
    DECLARE @HoursVal 	DECIMAL(18,4)

	if (@UseHourlyRates = 0)
	BEGIN
		SELECT @HoursVal = 	SUM(CASE WHEN @IsAssociateCurrency = 1 THEN	dbo.fnGetExchangeRate(dbo.fnGetCurrencyFromCC(IdCostCenter), @AssociateCurrency, YearMonth) ELSE 1 END 
								* HoursVal)
		FROM BUDGET_REVISED_DETAIL BRD
		WHERE 	IdProject = @IdProject AND
				IdGeneration = @IdGeneration AND
			 	IdPhase = @IdPhase AND
				IdWorkPackage = @IdWP AND
			 	IdCostCenter = @IdCostCenter AND
				IdAssociate = case when @IdAssociate = -1 then IdAssociate else @IdAssociate end
	END
	ELSE
	BEGIN
		SELECT @HoursVal = SUM(CASE WHEN @IsAssociateCurrency = 1 THEN dbo.fnGetExchangeRate(dbo.fnGetCurrencyFromCC(IdCostCenter), @AssociateCurrency, YearMonth) ELSE 1 END *
								dbo.fnGetValuedHours(IdCostCenter, HoursQty, YearMonth))
		FROM BUDGET_REVISED_DETAIL
		WHERE 	IdProject = @IdProject AND
				IdGeneration = @IdGeneration AND
			 	IdPhase = @IdPhase AND
				IdWorkPackage = @IdWP AND
			 	IdCostCenter = @IdCostCenter AND
				IdAssociate = case when @IdAssociate = -1 then IdAssociate else @IdAssociate end	
	END

    RETURN @HoursVal
END

GO


