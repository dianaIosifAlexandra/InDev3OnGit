--Drops the Procedure impUpdateAnnualImportDetails if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impUpdateAnnualImportDetails]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impUpdateAnnualImportDetails
GO
CREATE PROCEDURE impUpdateAnnualImportDetails
(
	@IdImport INT,
	@IdRow	INT,
	--@Country VARCHAR(3),
	--@Year INT,
	--@Month INT,
	@CostCenter VARCHAR(10),
	@ProjectCode VARCHAR(10),
	@WPCode VARCHAR(4),
	@AccountNumber NVARCHAR(20),
	@Quantity DECIMAL,
	@Value DECIMAL,
	@CurrencyCode VARCHAR(3),
	@Date SMALLDATETIME
)

AS
	IF (@IdImport is null )
	BEGIN 
		RAISERROR('No import selected',16,1)		
		RETURN -1
	END

	IF (@IdImport is null )
	BEGIN 
		RAISERROR('No row selected',16,1)		
		RETURN -2
	END

	
	UPDATE [ANNUAL_BUDGET_IMPORT_DETAILS]
	SET 
-- 		[Country]=@Country, 
-- 		[Year]=@Year, 
-- 		[Month]=@Month, 
		[CostCenter]=@CostCenter, 
		[ProjectCode]=@ProjectCode, 
		[WPCode]=@WPCode, 
		[AccountNumber]=@AccountNumber, 
		--[Quantity]=@Quantity, 
		--[Value]=@Value, 
		[CurrencyCode]=@CurrencyCode, 
		[Date]=@Date
	WHERE IdImport = @IdImport AND IdRow = @IdRow


GO

