--Drops the Procedure impAnnualUploadErrorsToLogTables if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impAnnualUploadErrorsToLogTables]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impAnnualUploadErrorsToLogTables
GO

--exec impAnnualUploadErrorsToLogTables @fileName = N'D:\Work\INDEV3\Source\TestData\ActualData\aaa\GRE2000.csv',
-- @Message = N'The file: GRE2000.csv you are trying to upload does not belong to country France you are registered in'
CREATE    PROCEDURE impAnnualUploadErrorsToLogTables
	@fileName 	nvarchar(400), 	--The name of the file	
	@Message nvarchar(255),		-- the upload error
	@IdAssociate INT
	
AS

IF (@fileName is null )
	BEGIN 
		RAISERROR('No file has been selected',16,1)		
		RETURN -1
	END


--fill imports table
DECLARE @IDIMPORT INT
SELECT @IDIMPORT  = ISNULL(MAX(IdImport),0)+1 
FROM ANNUAL_BUDGET_IMPORTS (TABLOCKX)

DECLARE @RealFileName nvarchar(100)
SELECT @RealFileName= dbo.fnGetFileNameFromPath(@fileName)


--#############BECAUSE THE FILENAME MIGHT BE WRONG WE USE DEFAULT YEAR
	DECLARE @YEAR int
	SET @YEAR = 1900
-- 	SET @YEAR=SUBSTRING(RIGHT(@fileName,CHARINDEX('\',REVERSE(@fileName)) -1),4,4)
-- 	PRINT @YEAR
--#############################################################################################



INSERT INTO [ANNUAL_BUDGET_IMPORTS]
	([IdImport], [ImportDate], [FileName], [IdAssociate], ExclusionCostCenterRowsNo, ExclusionGlAccountsRowsNo)
VALUES	(@IDIMPORT,  GETDATE(),	   @RealFileName, @IdAssociate, 0, 0)

INSERT INTO [ANNUAL_BUDGET_IMPORT_DETAILS]
( [IdImport], [IdRow])
VALUES(@IDIMPORT, 1)


INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS]
	( [IdImport], [Year], [Validation] )
VALUES (@IDImport, @YEAR, 'R')

INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
(
	[IdImport], [IdRow], [Details]
)
VALUES(@IDIMPORT, 1, @Message)




GO

