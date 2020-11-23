--Drops the Function fnGetInitialOtherCosts if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetInitialOtherCosts]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetInitialOtherCosts]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE   FUNCTION fnGetInitialOtherCosts
	(@IdProject	INT,
	@IdPhase	INT,
	@IdWP		INT,
	@IdCostCenter	INT,
	@IdAssociate	INT,
	@YearMonth	INT)
RETURNS DECIMAL(19, 4)
AS
BEGIN
    DECLARE @OtherCosts 	DECIMAL(19, 4)
	SET @OtherCosts = (SELECT SUM(CostVal) 
                        FROM BUDGET_INITIAL_DETAIL_COSTS
                        WHERE IdProject = @IdProject
				AND IdPhase = @IdPhase
				AND IdWorkPackage = @IdWP
				AND IdCostCenter = @IdCostCenter
				AND IdAssociate = @IdAssociate
				AND YearMonth = @YearMonth)
    RETURN @OtherCosts
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

