DECLARE @IdImport INT
SET @IdImport = NULL -- Please replace with correct ID

DELETE ANNUAL_BUDGET_DATA_DETAILS_HOURS WHERE IdImport = @IdImport
DELETE ANNUAL_BUDGET_DATA_DETAILS_SALES WHERE IdImport = @IdImport
DELETE ANNUAL_BUDGET_DATA_DETAILS_COSTS WHERE IdImport = @IdImport

DELETE ANNUAL_BUDGET_IMPORT_LOGS_DETAILS WHERE IdImport = @IdImport
DELETE ANNUAL_BUDGET_IMPORT_LOGS WHERE IdImport = @IdImport
DELETE ANNUAL_BUDGET_IMPORT_DETAILS WHERE IdImport = @IdImport
DELETE ANNUAL_BUDGET_IMPORTS WHERE IdImport = @IdImport

--Verification that data was deleled
SELECT * FROM ANNUAL_BUDGET_DATA_DETAILS_HOURS WHERE IdImport = @IdImport
SELECT * FROM ANNUAL_BUDGET_DATA_DETAILS_SALES WHERE IdImport = @IdImport
SELECT * FROM ANNUAL_BUDGET_DATA_DETAILS_COSTS WHERE IdImport = @IdImport
SELECT * FROM ANNUAL_BUDGET_IMPORT_LOGS_DETAILS WHERE IdImport = @IdImport
SELECT * FROM ANNUAL_BUDGET_IMPORT_LOGS WHERE IdImport = @IdImport
SELECT * FROM ANNUAL_BUDGET_IMPORT_DETAILS WHERE IdImport = @IdImport
SELECT * FROM ANNUAL_BUDGET_IMPORTS WHERE IdImport = @IdImport