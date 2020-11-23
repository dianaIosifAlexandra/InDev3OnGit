IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetActualHoursVal]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetActualHoursVal]
GO

CREATE   FUNCTION fnGetActualHoursVal
	(@IdProject	INT,
	@IdPhase	INT,
	@IdWP		INT,
	@IdCostCenter	INT,
	@YearMonth	INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @HoursVal 	DECIMAL(18, 2)

	SELECT @HoursVal = SUM(ROUND(HoursVal,0)) 
	FROM ACTUAL_DATA_DETAILS_HOURS
	WHERE 	IdProject = @IdProject AND
		 	IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP AND
		 	IdCostCenter = @IdCostCenter AND
			YearMonth = @YearMonth

    RETURN @HoursVal
END

GO
