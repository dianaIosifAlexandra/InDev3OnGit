--Drops the Function fnGetToCompletionRevisedOtherCosts if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetToCompletionRevisedOtherCosts]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetToCompletionRevisedOtherCosts]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE   FUNCTION fnGetToCompletionRevisedOtherCosts
	(@IdProject	INT,
	@IdPhase	INT,
	@IdWP		INT,
	@IdCostCenter	INT,
	@IdAssociate	INT,
	@IdGeneration	INT,
	@YearMonth	INT,
	@IdCostType	INT)
RETURNS DECIMAL(19, 4)
AS
BEGIN
    DECLARE @OtherCosts 	DECIMAL(19, 4)
	SET @OtherCosts = (SELECT SUM(CostVal) 
                        FROM BUDGET_REVISED_DETAIL_COSTS
                        WHERE 	IdProject = @IdProject
			AND 	IdPhase = @IdPhase
			AND 	IdWorkPackage = @IdWP
			AND 	IdCostCenter = @IdCostCenter
			AND 	IdAssociate = CASE WHEN @IdAssociate = -1 THEN IdAssociate ELSE @IdAssociate END
			AND 	IdGeneration = @IdGeneration
			AND	YearMonth = @YearMonth
			AND 	IdCostType = CASE WHEN @IdCostType = -1 THEN IdCostType ELSE @IdCostType END)
    RETURN @OtherCosts
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

