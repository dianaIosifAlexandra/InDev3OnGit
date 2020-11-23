--Drops the Procedure impCheckAnnualFileAlreadyUploaded if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impCheckAnnualFileAlreadyUploaded]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impCheckAnnualFileAlreadyUploaded
GO


CREATE    PROCEDURE impCheckAnnualFileAlreadyUploaded
	@fileName 	nvarchar(400) 	--The name of the file	
	
	
AS


IF (@fileName is null )
BEGIN 
	RAISERROR('No file has been selected',16,1)		
	RETURN -1
END
DECLARE @RealFileName nvarchar(100)
SELECT @RealFileName= dbo.fnGetFileNameFromPath(@fileName)
IF EXISTS
(
	SELECT *--AI.IdImport 
	FROM ANNUAL_BUDGET_IMPORTS AI INNER JOIN ANNUAL_BUDGET_IMPORT_LOGS AIL
	ON AI.IdImport = AIL.IdImport
	WHERE 	UPPER(REPLACE(AI.FileName,'ALL',SUBSTRING(@RealFileName,1,3))) 
		= 
		UPPER(REPLACE(@RealFileName,'ALL',SUBSTRING(AI.FileName,1,3)))
		
	AND AIL.Validation='G'
)


BEGIN
	return -1
END
ELSE
BEGIN
	return 1
END


GO

