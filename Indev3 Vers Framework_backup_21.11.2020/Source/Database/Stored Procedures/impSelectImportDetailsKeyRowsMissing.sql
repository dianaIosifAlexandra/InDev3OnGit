--Drops the Procedure impSelectImportDetails if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.impSelectImportDetailsKeyRowsMissing') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectImportDetailsKeyRowsMissing
GO

-- impSelectImportDetails 77
CREATE PROCEDURE impSelectImportDetailsKeyRowsMissing
(
	@IdImport INT
)
AS
	IF (@IdImport is null )
	BEGIN 
		RAISERROR('No import selected',16,1)		
		RETURN -1
	END

--we select all the records of the import
SELECT 	IDKRM.IdImport,
	IDKRM.IdRow,
	IDKRM.IdImportPrevious,
	IDKRM.Country,
	IDKRM.[Year],
	IDKRM.[Month],
	IDKRM.CostCenter, 
	IDKRM.ProjectCode, 
	IDKRM.WPCode,
       	IDKRM.AccountNumber, 
	IDKRM.AssociateNumber, 
	IDKRM.Quantity, 
	IDKRM.UnitQty,
       	IDKRM.Value, 
	IDKRM.CurrencyCode,
	GETDATE() as [Date]
FROM IMPORT_DETAILS_KEYROWS_MISSING IDKRM (holdlock)
WHERE IDKRM.IdImport = @IdImport
ORDER BY IDKRM.IdRow

GO


