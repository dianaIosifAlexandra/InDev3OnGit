IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetActualHoursQty]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetActualHoursQty]
GO

CREATE   FUNCTION fnGetActualHoursQty
	(@IdProject	INT,
	@IdPhase	INT,
	@IdWP		INT,
	@IdCostCenter	INT,
	@YearMonth	INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @HoursQty 	DECIMAL(18, 2)

	SELECT @HoursQty = SUM(ROUND(HoursQty,0)) 
	FROM ACTUAL_DATA_DETAILS_HOURS
	WHERE 	IdProject = @IdProject AND
		 	IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP AND
		 	IdCostCenter = @IdCostCenter AND
			YearMonth = @YearMonth

    RETURN @HoursQty
END

GO


