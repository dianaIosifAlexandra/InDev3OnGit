--Drops the Procedure impSelectImportDetailsForExport if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.impSelectImportDetailsForExport') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectImportDetailsForExport
GO

-- exec impSelectImportDetailsForExport 451

CREATE PROCEDURE impSelectImportDetailsForExport
(
	@IdImport INT
)
AS
	IF (@IdImport is null )
	BEGIN 
		RAISERROR('No import selected',16,1)		
		RETURN -1
	END


SELECT 	IdImport,
	IdRow, 
	Country, 
	Year, 
	Month, 
	CostCenter, 
	ProjectCode, 
	WPCode,
       	AccountNumber, 
	AssociateNumber, 
	Quantity, 
	UnitQty,
       	Value, 
	CurrencyCode,
	[Date]
FROM IMPORT_DETAILS IMPD
WHERE IdImport = @IdImport

UNION

SELECT 	IdImport,
	IdRow, 
	Country, 
	Year, 
	Month, 
	CostCenter, 
	ProjectCode, 
	WPCode,
       	AccountNumber, 
	AssociateNumber, 
	Quantity, 
	UnitQty,
       	Value, 
	CurrencyCode,
	[Date]
FROM IMPORT_DETAILS_KEYROWS_MISSING
WHERE IdImport = @IdImport

GO


