--Drops the Procedure impProcessErrorToLogTable if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impProcessErrorToLogTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impProcessErrorToLogTable
GO


CREATE    PROCEDURE impProcessErrorToLogTable
	@IdImport INT,
	@Message nvarchar(255)
AS

-- we have an error
UPDATE IMPORT_LOGS
SET Validation = 'R'
WHERE IdImport = @IdImport

INSERT INTO [IMPORT_LOGS_DETAILS]
	([IdImport], [IdRow], [Details])
VALUES(@IDIMPORT, 1, @Message)

GO


