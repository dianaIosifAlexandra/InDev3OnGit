--Drops the Procedure bgtDeleteDataLogs if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impDeleteImport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impDeleteImport
GO
CREATE PROCEDURE impDeleteImport
	@IdImport INT
AS

DELETE FROM IMPORT_LOGS_DETAILS 
WHERE IdImport = @IdImport

DELETE FROM IMPORT_LOGS_DETAILS_KEYROWS_MISSING
WHERE IdImport = @IdImport

DELETE FROM IMPORT_DETAILS_KEYROWS_MISSING
WHERE IdImport = @IdImport

DELETE FROM IMPORT_LOGS 
WHERE IdImport = @IdImport	

DELETE FROM IMPORT_DETAILS 
WHERE IdImport = @IdImport

DELETE FROM IMPORTS 
WHERE IdImport = @IdImport

GO

