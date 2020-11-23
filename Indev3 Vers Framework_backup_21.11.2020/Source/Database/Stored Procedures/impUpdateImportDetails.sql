--Drops the Procedure impUpdateImportDetails if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impUpdateImportDetails]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impUpdateImportDetails
GO
CREATE PROCEDURE impUpdateImportDetails
(
	@IdImport INT,
	@IdRow	INT,
	@CostCenter VARCHAR(10),
	@ProjectCode VARCHAR(10),
	@WPCode VARCHAR(4),
	@AccountNumber NVARCHAR(20),
	@AssociateNumber VARCHAR(15),
	@Quantity DECIMAL,
	@UnitQty varchar(4),
	@Value DECIMAL,
	@CurrencyCode VARCHAR(3)
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

	
	UPDATE [IMPORT_DETAILS]
	SET 
		[CostCenter]=@CostCenter, 
		[ProjectCode]=@ProjectCode, 
		[WPCode]=@WPCode, 
		[AccountNumber]=@AccountNumber, 
		[AssociateNumber]=@AssociateNumber, 
		[Quantity]=@Quantity, 
		[UnitQty]=@UnitQty, 
		[Value]=@Value, 
		[CurrencyCode]=@CurrencyCode
	WHERE IdImport = @IdImport AND IdRow = @IdRow

	UPDATE [IMPORT_DETAILS_KEYROWS_MISSING]
	SET 
		[CostCenter]=@CostCenter, 
		[ProjectCode]=@ProjectCode, 
		[WPCode]=@WPCode, 
		[AccountNumber]=@AccountNumber, 
		[AssociateNumber]=@AssociateNumber, 
		[Quantity]=@Quantity, 
		[UnitQty]=@UnitQty, 
		[Value]=@Value, 
		[CurrencyCode]=@CurrencyCode
	WHERE IdImport = @IdImport AND IdRow = @IdRow


GO

