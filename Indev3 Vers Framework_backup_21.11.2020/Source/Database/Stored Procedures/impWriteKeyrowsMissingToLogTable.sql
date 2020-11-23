--Drops the Procedure impWriteKeyrowsMissingToLogTable if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteKeyrowsMissingToLogTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteKeyrowsMissingToLogTable
GO


CREATE    PROCEDURE impWriteKeyrowsMissingToLogTable
	@IdImport 	INT,
	@IdRow		INT,		
	@Message 	nvarchar(255)
AS

-- set validation flag to 'O' to allow creating new process file
UPDATE IMPORT_LOGS
SET Validation = 'O'
WHERE IdImport = @IdImport

INSERT INTO [IMPORT_LOGS_DETAILS_KEYROWS_MISSING]
	([IdImport], [IdRow], [Details])
VALUES(@IDIMPORT, @IdRow, @Message)

GO


