--Drops the Procedure abgtDeleteAnnualImport if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[abgtDeleteAnnualImport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE abgtDeleteAnnualImport
GO
CREATE PROCEDURE abgtDeleteAnnualImport
	@IdImport INT
AS

DECLARE @Validation	NVARCHAR(1)
SET @Validation = (SELECT Validation
					FROM ANNUAL_BUDGET_IMPORT_LOGS
					WHERE IdImport = @IdImport)

IF (@Validation = 'G')
BEGIN
	DELETE FROM ANNUAL_BUDGET_DATA_DETAILS_COSTS
	WHERE IdImport = @IdImport

	DELETE FROM ANNUAL_BUDGET_DATA_DETAILS_SALES
	WHERE IdImport = @IdImport

	DELETE FROM ANNUAL_BUDGET_DATA_DETAILS_HOURS
	WHERE IdImport = @IdImport
END

DELETE FROM ANNUAL_BUDGET_IMPORT_LOGS_DETAILS 
WHERE IdImport = @IdImport

DELETE FROM ANNUAL_BUDGET_IMPORT_LOGS 
WHERE IdImport = @IdImport	

DELETE FROM ANNUAL_BUDGET_IMPORT_DETAILS 
WHERE IdImport = @IdImport

DELETE FROM ANNUAL_BUDGET_IMPORTS 
WHERE IdImport = @IdImport

GO

