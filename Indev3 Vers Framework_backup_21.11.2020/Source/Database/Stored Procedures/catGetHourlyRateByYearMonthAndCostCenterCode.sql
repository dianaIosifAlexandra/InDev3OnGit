--Drops the Procedure catSelectProgram if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catGetHourlyRateByYearMonthAndCostCenterCode]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catGetHourlyRateByYearMonthAndCostCenterCode
GO
CREATE PROCEDURE catGetHourlyRateByYearMonthAndCostCenterCode
	@StartYearMonth	AS INT, 	
	@EndYearMonth	AS INT, 	
	@CostCenterCode	AS varchar(15)		--The CostCenterCode of the selected Hourly Rate
AS

declare @HourlyRate decimal(12,2)

	SELECT top 1 @HourlyRate = HR.HourlyRate
		FROM HOURLY_RATES HR(NOLOCK)		
		INNER JOIN COST_CENTERS CC(NOLOCK)
			ON HR.IdCostCenter = CC.[Id]
	WHERE 
		HR.YearMonth between @StartYearMonth and @EndYearMonth
		AND	CC.Code = @CostCenterCode
	ORDER BY HR.YearMonth, HR.IdCostCenter

	
	if @HourlyRate is null or @HourlyRate <= 0.1
	  begin
		-- get the last hourly rate for @CostCenterCode in the  year of @StartYearMonth
			SELECT top 1 @HourlyRate = HR.HourlyRate
				FROM HOURLY_RATES HR(NOLOCK)		
				INNER JOIN COST_CENTERS CC(NOLOCK)
					ON HR.IdCostCenter = CC.[Id]
			WHERE 
				floor(HR.YearMonth / 100) = floor(@StartYearMonth/100) 
				AND CC.Code = @CostCenterCode
			ORDER BY HR.YearMonth desc
	  end

	if @HourlyRate is null or @HourlyRate <= 0.1
	  begin
		-- get the last hourly rate for @CostCenterCode in the current year
			SELECT top 1 @HourlyRate = HR.HourlyRate
				FROM HOURLY_RATES HR(NOLOCK)		
				INNER JOIN COST_CENTERS CC(NOLOCK)
					ON HR.IdCostCenter = CC.[Id]
			WHERE 
				floor(HR.YearMonth / 100) = year(getdate()) 
				AND CC.Code = @CostCenterCode
			ORDER BY HR.YearMonth desc
	  end

select @HourlyRate

GO

