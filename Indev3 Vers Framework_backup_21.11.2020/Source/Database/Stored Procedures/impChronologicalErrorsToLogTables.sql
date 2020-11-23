--Drops the Procedure impChronologicalErrorsToLogTables if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impChronologicalErrorsToLogTables]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impChronologicalErrorsToLogTables
GO


CREATE    PROCEDURE impChronologicalErrorsToLogTables
	@fileName 	nvarchar(400), 	--The name of the file	
	@IdAssociate INT,		--ID of the associate
	@Message nvarchar(255),		-- the upload error
	 @IdSource INT			-- ID of source application
AS

IF (@fileName is null )
	BEGIN 
		RAISERROR('No file has been selected',16,1)		
		RETURN -1
	END

DECLARE @RealFileName nvarchar(100)
Select @RealFileName = dbo.fnGetFileNameFromPath(@FileName)

	IF (@IdSource=-1)
	BEGIN
		RAISERROR('File in wrong format: no id source!',16,1)		
		RETURN -2
	END

--fill imports table
DECLARE @IDIMPORT INT
SELECT @IDIMPORT  = ISNULL(MAX(IdImport),0)+1 
FROM IMPORTS (TABLOCKX)

DECLARE @YEARMONTH INT
	SET @YEARMONTH=SUBSTRING(SUBSTRING(RIGHT(@fileName,CHARINDEX('\',REVERSE(@fileName))-1),7,6),3,4) + 
	SUBSTRING(SUBSTRING(RIGHT(@fileName,CHARINDEX('\',REVERSE(@fileName))-1),7,6),1,2)

INSERT INTO [IMPORTS]([IdImport], [ImportDate], [FileName], [IdAssociate], [ExclusionCostCenterRowsNo], [ExclusionGlAccountsRowsNo])
VALUES(@IDIMPORT, GETDATE(), @RealFileName, @IdAssociate, 0, 0)


INSERT INTO [IMPORT_DETAILS]([IdImport], [IdRow])
VALUES(@IDIMPORT, 1)

INSERT INTO [IMPORT_LOGS]([IdImport], [IdSource], [YearMonth], [Validation])
VALUES(@IDIMPORT, @IdSource, @YEARMONTH, 'R')

INSERT INTO [IMPORT_LOGS_DETAILS]([IdImport], [IdRow], [Details])
VALUES(@IDIMPORT, 1, @Message)



GO

