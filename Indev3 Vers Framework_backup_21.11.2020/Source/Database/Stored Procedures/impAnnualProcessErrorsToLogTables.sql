--Drops the Procedure impAnnualProcessErrorsToLogTables if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impAnnualProcessErrorsToLogTables]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impAnnualProcessErrorsToLogTables
GO


CREATE    PROCEDURE impAnnualProcessErrorsToLogTables
	@IdImport INT,
	@fileName nvarchar(400),
	@Message nvarchar(255)
AS

IF (@IdImport is null )
	BEGIN 
		RAISERROR('No id import provided',16,1)		
		RETURN -1
	END

DECLARE @RealFileName nvarchar(100)
SELECT @RealFileName= dbo.fnGetFileNameFromPath(@fileName)


DECLARE @YEAR INT
SET @YEAR=SUBSTRING(RIGHT(@fileName,CHARINDEX('\',REVERSE(@fileName)) -1),4,4)

if not exists(select IdImport from [ANNUAL_BUDGET_IMPORT_LOGS] where IdImport = @IDImport)
-- if some quantity/value was not numeric, it was already inserted a record with "Orange" code
   begin
		INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS]
			( [IdImport], [Year], [Validation] )
		VALUES (@IDImport, @YEAR, 'R')

		INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
		(
			[IdImport], [IdRow], [Details]
		)
		VALUES(@IDIMPORT, 1, @Message)
	end




GO

