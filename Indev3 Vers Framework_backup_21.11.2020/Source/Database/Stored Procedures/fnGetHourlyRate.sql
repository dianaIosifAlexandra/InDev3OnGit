IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetHourlyRate]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetHourlyRate]
GO

CREATE   FUNCTION fnGetHourlyRate
	( 	
	@IdCostCenter 	INT,
	@YearMonth	INT
	)
RETURNS DECIMAL(12,2)
AS
BEGIN
	DECLARE @HourlyRate		DECIMAL(12,2),
		@YMOfHourlyRate		INT

	SET 	@HourlyRate = NULL
	SET 	@YMOfHourlyRate = NULL

	SELECT 	@YMOfHourlyRate = MAX(YearMonth)
	FROM 	HOURLY_RATES AS HR
	INNER JOIN COST_CENTERS AS CC 
		ON HR.IdCostCenter = CC.[Id]
	INNER JOIN INERGY_LOCATIONS AS IL
		ON CC.IdInergyLocation = IL.[Id]
	INNER JOIN COUNTRIES AS C
		ON IL.IdCountry = C.[Id]
	WHERE 	HR.IdCostCenter = @IdCostCenter AND
		HR.YearMonth <= @YearMonth 

	--in case no hourly rate is found NULL is returned from this function
	IF (@YMOfHourlyRate IS NULL)
		RETURN NULL

	SELECT 	@HourlyRate = HourlyRate 
	FROM 	HOURLY_RATES AS HR
	INNER JOIN COST_CENTERS AS CC 
		ON HR.IdCostCenter = CC.[Id]
	INNER JOIN INERGY_LOCATIONS AS IL
		ON CC.IdInergyLocation = IL.[Id]
	INNER JOIN COUNTRIES AS C
		ON IL.IdCountry = C.[Id]
	WHERE 	HR.IdCostCenter = @IdCostCenter AND 
		HR.YearMonth = @YMOfHourlyRate

	RETURN @HourlyRate
END
GO

