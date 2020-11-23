IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetRevisedBudgetHoursQty]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetRevisedBudgetHoursQty]
GO

CREATE   FUNCTION fnGetRevisedBudgetHoursQty
	(@IdProject	INT,
	@IdGeneration	INT,
	@IdPhase	INT,
	@IdWP		INT,
	@IdCostCenter	INT,
	@IdAssociate	INT)
RETURNS INT
AS
BEGIN
    DECLARE @HoursQty 	INT

	SELECT @HoursQty = SUM(HoursQty)
	FROM BUDGET_REVISED_DETAIL
	WHERE 	IdProject = @IdProject AND
			IdGeneration = @IdGeneration AND
		 	IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP AND
		 	IdCostCenter = @IdCostCenter AND
			IdAssociate = case when @IdAssociate = -1 then IdAssociate else @IdAssociate end

    RETURN @HoursQty
END

GO


