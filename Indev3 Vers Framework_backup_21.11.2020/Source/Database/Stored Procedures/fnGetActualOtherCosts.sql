--Drops the Function fnGetActualOtherCosts if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetActualOtherCosts]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetActualOtherCosts]
GO

CREATE   FUNCTION fnGetActualOtherCosts
	(@IdProject	INT,
	@IdPhase	INT,
	@IdWP		INT,
	@IdCostCenter	INT,
	@YearMonth	INT,
	@IdCostType	INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @OtherCosts 	DECIMAL(18, 2)
	SET @OtherCosts = (SELECT SUM(ROUND(CostVal,0)) 
                        FROM ACTUAL_DATA_DETAILS_COSTS
                        WHERE 	IdProject = @IdProject
			AND 	IdPhase = @IdPhase
			AND 	IdWorkPackage = @IdWP
			AND 	IdCostCenter = @IdCostCenter
			AND	YearMonth = @YearMonth
			AND 	IdCostType = CASE WHEN @IdCostType = -1 THEN IdCostType ELSE @IdCostType END)
    RETURN @OtherCosts
END

GO


