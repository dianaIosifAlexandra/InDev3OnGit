IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetBudgetOtherCostType]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetBudgetOtherCostType]
GO

CREATE  FUNCTION fnGetBudgetOtherCostType
(
	@CostType varchar(15)
)
RETURNS INT
AS
BEGIN
	DECLARE @CostTypeID INT		
	SELECT @CostTypeID = ID FROM BUDGET_COST_TYPES WHERE Name = @CostType

	return @CostTypeID
END
GO


