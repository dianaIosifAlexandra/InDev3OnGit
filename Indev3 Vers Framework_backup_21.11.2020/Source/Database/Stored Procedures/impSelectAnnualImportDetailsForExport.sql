--Drops the Procedure impSelectAnnualImportDetailsForExport if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impSelectAnnualImportDetailsForExport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectAnnualImportDetailsForExport
GO
CREATE PROCEDURE impSelectAnnualImportDetailsForExport
(
	@IdImport INT
)

AS
IF (@IdImport is null )
BEGIN 
	RAISERROR('No import selected',16,1)		
	RETURN -1
END


SELECT  IdImport,
	IdRow,
	Country,
	Year,
	CostCenter,
	ProjectCode,
	WPCode,
	AccountNumber,
	isnull(Value1,0) as Value1,
	isnull(Value2,0) as Value2,
	isnull(Value3,0) as Value3,
	isnull(Value4,0) as Value4,
	isnull(Value5,0) as Value5, 
	isnull(Value6,0) as Value6,
	isnull(Value7,0) as Value7,
	isnull(Value8,0) as Value8,
	isnull(Value9,0) as Value9,
	isnull(Value10,0) as Value10,
	isnull(Value11,0) as Value11,
	isnull(Value12,0) as Value12,
	isnull(Quantity1,0) as Quantity1,
	isnull(Quantity2,0) as Quantity2,
	isnull(Quantity3,0) as Quantity3,
	isnull(Quantity4,0) as Quantity4,
	isnull(Quantity5,0) as Quantity5, 
	isnull(Quantity6,0) as Quantity6,
	isnull(Quantity7,0) as Quantity7,
	isnull(Quantity8,0) as Quantity8,
	isnull(Quantity9,0) as Quantity9,
	isnull(Quantity10,0) as Quantity10,
	isnull(Quantity11,0) as Quantity11,
	isnull(Quantity12,0) as Quantity12,
	CurrencyCode,
	Date 
FROM ANNUAL_BUDGET_IMPORT_DETAILS BID	
WHERE IdImport = @IdImport

GO

