--Drops the Procedure impDeleteImportDetails if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impDeleteImportDetails]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impDeleteImportDetails
GO
CREATE PROCEDURE impDeleteImportDetails
(
	@IdImport INT
)

AS

DELETE FROM IMPORT_DETAILS WHERE IdImport = @IdImport

GO

