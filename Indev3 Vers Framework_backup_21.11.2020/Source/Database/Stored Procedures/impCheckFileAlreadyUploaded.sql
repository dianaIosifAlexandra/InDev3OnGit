--Drops the Procedure impCheckFileAlreadyUploaded if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impCheckFileAlreadyUploaded]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impCheckFileAlreadyUploaded
GO


CREATE    PROCEDURE impCheckFileAlreadyUploaded
	@fileName 	nvarchar(400) 	--The name of the file	
	
	
AS


	IF (@fileName is null )
	BEGIN 
		RAISERROR('No file has been selected',16,1)		
		RETURN -1
	END
	DECLARE @RealFileName nvarchar(100)
	SELECT @RealFileName= dbo.fnGetFileNameFromPath(@fileName)
	IF EXISTS(
			SELECT Imports.IdImport 
			FROM IMPORTS INNER JOIN IMPORT_LOGS
			ON IMPORTS.IdImport = IMPORT_LOGS.IdImport
			WHERE IMPORTS.FileName = @RealFileName AND IMPORT_LOGS.Validation='G'
		)
	BEGIN
		return -1
	END
	ELSE
	BEGIN
		return 1
	END


GO


