--Drops the Procedure catSelectHourlyRate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectHourlyRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectHourlyRate
GO

-- exec catSelectHourlyRate @YearMonth = NULL, @IdCostCenter = -1, @IdCountry = -1
CREATE PROCEDURE catSelectHourlyRate
	@YearMonth	AS INT, 	--The Year of the selected Hourly Rate	
	@IdCostCenter	AS INT,		--The IdCostCenter of the selected Hourly Rate
	@IdCountry	AS INT		--The IdCountry of the selected Hourly Rate
AS
	--If @Id has the value -1, it will return all Hourly Rates
	IF (@YearMonth IS NULL AND @IdCostCenter = -1)
	BEGIN 
		SELECT DISTINCT
			IL.Name		AS 'InergyLocationName',
			CC.[Code]	AS 'CostCenterCode',
			C.Name		AS 'CurrencyName',
			HR.HourlyRate	AS 'Value',
			CO.Id		AS 'IdCountry',
			HR.YearMonth	AS 'YearMonth',
			CC.[Name]	AS 'CostCenterName',
			IL.ID		AS 'IdInergyLocation',
			HR.IdCostCenter	AS 'IdCostCenter',
			C.Id		AS 'IdCurrency'
		FROM HOURLY_RATES HR(NOLOCK)		
		INNER JOIN COST_CENTERS CC(NOLOCK)
			ON HR.IdCostCenter = CC.[Id]
		INNER JOIN INERGY_LOCATIONS IL(NOLOCK)
			ON CC.IdInergyLocation = IL.Id
		INNER JOIN COUNTRIES CO(NOLOCK)
			ON IL.IdCountry = CO.Id
		INNER JOIN CURRENCIES C
			ON CO.IdCurrency  = C.Id
		WHERE CO.[Id] = CASE WHEN @IdCountry = -1 THEN CO.[Id] ELSE @IdCountry END
		ORDER BY HR.YearMonth, HR.IdCostCenter
		RETURN
	END

	--If @Id doesn't have the value -1 it will return the selected Hourly Rates
	SELECT 
		IL.Name		AS 'InergyLocationName',
		CC.[Code]	AS 'CostCenterCode',
		C.Name		AS 'CurrencyName',
		HR.HourlyRate	AS 'Value',
		CO.Id		AS 'IdCountry',
		HR.YearMonth	AS 'YearMonth',
		CC.[Name]	AS 'CostCenterName',
		IL.ID		AS 'IdInergyLocation',
		HR.IdCostCenter	AS 'IdCostCenter',
		C.Id		AS 'IdCurrency'
		FROM HOURLY_RATES HR(NOLOCK)		
		INNER JOIN COST_CENTERS CC(NOLOCK)
			ON HR.IdCostCenter = CC.[Id]
		INNER JOIN INERGY_LOCATIONS IL(NOLOCK)
			ON CC.IdInergyLocation = IL.Id
		INNER JOIN COUNTRIES CO(NOLOCK)
			ON IL.IdCountry = CO.Id
		INNER JOIN CURRENCIES C
			ON CO.IdCurrency  = C.Id
	WHERE CO.[Id] = CASE WHEN @IdCountry = -1 THEN CO.[Id] ELSE @IdCountry END AND
		HR.YearMonth = @YearMonth AND
		HR.IdCostCenter = @IdCostCenter
	ORDER BY HR.YearMonth, HR.IdCostCenter
GO

