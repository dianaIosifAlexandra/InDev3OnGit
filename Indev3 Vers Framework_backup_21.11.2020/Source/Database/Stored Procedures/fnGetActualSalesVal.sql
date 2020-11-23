IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetActualSalesVal]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetActualSalesVal]
GO

CREATE   FUNCTION fnGetActualSalesVal
	(@IdProject	INT,
	@IdPhase	INT,
	@IdWP		INT,
	@IdCostCenter	INT,
	@YearMonth	INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @SalesVal 	DECIMAL(18, 2)

	SELECT @SalesVal = SUM(ROUND(SalesVal,0)) 
	FROM ACTUAL_DATA_DETAILS_SALES
	WHERE 	IdProject = @IdProject AND
		 	IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP AND
		 	IdCostCenter = @IdCostCenter AND
			YearMonth = @YearMonth

    RETURN @SalesVal
END

GO
