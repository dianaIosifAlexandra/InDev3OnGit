--Drops the Function fnGetValuedHours if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetValuedHours]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetValuedHours]
GO

CREATE   FUNCTION fnGetValuedHours
	( 	
	@IdCostCenter 	INT,
    	@TotalHours 	DECIMAL(18,2),
	@YearMonth	INT 
	)
RETURNS DECIMAL(18,2)
AS
BEGIN
	DECLARE @HourlyRate		DECIMAL(12,2)
	DECLARE @ValuedHours 		DECIMAL(18,2)

	Set @HourlyRate = dbo.fnGetHourlyRate(@IdCostCenter, @YearMonth)

	--if the hourly rate is null we return 0 in order to avoid some tricky situations above
	IF (@HourlyRate IS NULL)
		RETURN 0

	SET @ValuedHours = @TotalHours * @HourlyRate

	RETURN @ValuedHours
END
GO

