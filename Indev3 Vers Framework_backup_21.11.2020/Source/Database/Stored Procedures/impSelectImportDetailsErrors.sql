--Drops the Procedure impSelectImportDetailsErrors if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.impSelectImportDetailsErrors') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectImportDetailsErrors
GO

-- impSelectImportDetailsErrors 77
CREATE PROCEDURE impSelectImportDetailsErrors
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

SELECT ERR.IdImport, ERR.IdRow, ERR.Id, 
	       ERR.Details, ERR.Module, ERR.ModuleName
FROM
(
	SELECT IMPD.IdImport, IMPD.IdRow, IMPD.Id, 
	       IMPD.Details, IMPD.Module, ISNULL(MDL.Name,'') AS ModuleName
	FROM IMPORT_LOGS_DETAILS IMPD (nolock)
	LEFT JOIN MODULES MDL
		on IMPD.Module = MDL.Code
	WHERE IdImport = @IdImport

UNION 

	SELECT ILDKM.IdImport, ILDKM.IdRow, ILDKM.Id, 
	       ILDKM.Details, ILDKM.Module, ISNULL(MDL.Name,'') AS ModuleName
	FROM IMPORT_LOGS_DETAILS_KEYROWS_MISSING ILDKM (nolock)
	LEFT JOIN MODULES MDL
		on ILDKM.Module = MDL.Code
	WHERE IdImport = @IdImport

) AS ERR
	ORDER BY ERR.IdImport, ERR.IdRow, ERR.Id
END
GO


