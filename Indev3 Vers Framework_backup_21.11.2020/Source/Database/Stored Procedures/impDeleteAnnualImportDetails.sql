--Drops the Procedure impDeleteAnnualImportDetails if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impDeleteAnnualImportDetails]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impDeleteAnnualImportDetails
GO
CREATE PROCEDURE impDeleteAnnualImportDetails
(
	@IdImport INT
)

AS

	DELETE FROM ANNUAL_BUDGET_IMPORT_DETAILS WHERE IdImport = @IdImport

GO

