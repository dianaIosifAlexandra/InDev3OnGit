--Drops the Procedure catDeleteHourlyRate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteHourlyRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteHourlyRate
GO
CREATE PROCEDURE catDeleteHourlyRate
	@IdCostCenter	AS INT, 	--The IdCostCenter of the selected Hourly Rate
	@YearMonth	AS INT		--The Year and Month of the selected Hourly Rate
	
AS	
DECLARE @RowCount INT

	DELETE FROM HOURLY_RATES
	WHERE 	IdCostCenter = @IdCostCenter AND
		YearMonth = @YearMonth

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

