--Drops the Procedure impSelectAnnualImportDetailsErrors if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.impSelectAnnualImportDetailsErrors') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectAnnualImportDetailsErrors
GO


CREATE PROCEDURE impSelectAnnualImportDetailsErrors
(
	@IdImport INT
)
AS
BEGIN
	IF (@IdImport is null )
	BEGIN 
		RAISERROR('No import selected',16,1)		
		RETURN -1
	END

	SELECT IMPD.IdImport, IMPD.IdRow, IMPD.Id, 
	       IMPD.Details, IMPD.Module, ISNULL(MDL.Name,'') AS ModuleName
	FROM ANNUAL_BUDGET_IMPORT_LOGS_DETAILS IMPD (nolock)
	LEFT JOIN MODULES MDL
		on IMPD.Module = MDL.Code
	WHERE IdImport = @IdImport
	ORDER BY IdImport, IdRow, Id
END
GO

