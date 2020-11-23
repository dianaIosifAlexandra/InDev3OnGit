--Drops the Procedure impDeleteImportRows if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impDeleteImportRows]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impDeleteImportRows
GO
CREATE PROCEDURE impDeleteImportRows
(
	@IdImport INT,
	@IdRow INT
)

AS
	DELETE FROM IMPORT_LOGS_DETAILS WHERE IdImport = @IdImport AND IdRow = @IdRow
	DELETE FROM IMPORT_LOGS_DETAILS_KEYROWS_MISSING WHERE IdImport = @IdImport AND IdRow = @IdRow
	DELETE FROM IMPORT_DETAILS WHERE IdImport = @IdImport AND IdRow = @IdRow
	DELETE FROM IMPORT_DETAILS_KEYROWS_MISSING WHERE IdImport = @IdImport AND IdRow = @IdRow

GO
