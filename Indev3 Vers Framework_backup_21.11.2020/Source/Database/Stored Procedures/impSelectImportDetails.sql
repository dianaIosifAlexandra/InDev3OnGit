--delete impSelectImportDetails if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.impSelectImportDetails') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectImportDetails
GO

-- impSelectImportDetails 447
CREATE PROCEDURE impSelectImportDetails
(
	@IdImport INT
)
AS
	IF (@IdImport is null )
	BEGIN 
		RAISERROR('No import selected',16,1)		
		RETURN -1
	END

SELECT * FROM
(
	SELECT 	IMPD.IdImport,
			IMPD.IdRow,
			IMPD.CostCenter, 
			IMPD.ProjectCode, 
			P.ID AS ProjectID, 
			IMPD.WPCode,
	       		IMPD.AccountNumber, 
			IMPD.AssociateNumber, 
			IMPD.Quantity, 
			IMPD.UnitQty,
	       		IMPD.Value, 
			IMPD.CurrencyCode 
		-- 	IMPD.Date
	FROM IMPORT_DETAILS IMPD
	LEFT JOIN PROJECTS P
	 ON IMPD.ProjectCode = P.CODE
		INNER JOIN IMPORT_LOGS_DETAILS IMPL
			on IMPL.IdImport = IMPD.IdImport and 
			   IMPL.IdRow = IMPD.IdRow and
			   IMPL.Id = (SELECT MIN(id) 
					  FROM IMPORT_LOGS_DETAILS ild
					  WHERE ild.idImport = impl.idImport and
						ild.IdRow = impl.idRow)
	WHERE IMPD.IdImport = @IdImport

	UNION ALL

	SELECT 	IMKM.IdImport,
			IMKM.IdRow,
			IMKM.CostCenter, 
			IMKM.ProjectCode, 
			P.ID AS ProjectID, 
			IMKM.WPCode,
	       		IMKM.AccountNumber, 
			IMKM.AssociateNumber, 
			IMKM.Quantity, 
			IMKM.UnitQty,
	       		IMKM.Value, 
			IMKM.CurrencyCode 
		-- 	IMPD.Date
	FROM IMPORT_DETAILS_KEYROWS_MISSING IMKM
	LEFT JOIN PROJECTS P
	 ON IMKM.ProjectCode = P.CODE
		INNER JOIN IMPORT_LOGS_DETAILS_KEYROWS_MISSING IMPL
			on IMPL.IdImport = IMKM.IdImport and 
			   IMPL.IdRow = IMKM.IdRow and
			   IMPL.Id = (SELECT MIN(id) 
					FROM IMPORT_LOGS_DETAILS_KEYROWS_MISSING ild
					  WHERE ild.idImport = impl.idImport and
						ild.IdRow = impl.idRow)
	WHERE IMKM.IdImport = @IdImport

) AS S
ORDER BY S.IdRow
GO



