IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnGetFileNameFromPath]'))
	DROP FUNCTION fnGetFileNameFromPath
GO

--select dbo.fnGetFileNameFromPath('D:\Work\INDEV3\Source\Indev3WebSite\Indev3WebSite\UploadDirectories\InProcess\XLSROM012007_123_2006_12_23.csv')
CREATE FUNCTION fnGetFileNameFromPath
(
	@FileName NVARCHAR(400)
)
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @RealFileName NVARCHAR(100)
	DECLARE @UNDERSCOREPOS INT

	--get only the name of the file from path
	DECLARE @FileNameNoPath NVARCHAR(100)
	DECLARE @FILEEXTENSION NVARCHAR(4)
		
/*
 * There is a new security feature in IE 8 that hides the real path of the selected file from JavaScript call (it returns c:\fakepath\).
 * This seems to only be activated for internet servers, not local intranet servers.
 * In this case the input parameter comes without the fakepath, so @FileNameNoPath = @FileName 
*/
	IF (CHARINDEX('\', @fileName) = 0)
	BEGIN
		SET @FileNameNoPath = @FileName
	END
	ELSE
	BEGIN
		SET @FileNameNoPath = RIGHT(@fileName,CHARINDEX('\',REVERSE(@FileName))-1)
	END

	SET @FILEEXTENSION = RIGHT(@FileNameNoPath,4)
	SET @RealFileName = LEFT(@FileNameNoPath,LEN(@FileNameNoPath) - CHARINDEX('_',REVERSE(@FileNameNoPath)))
	SET @UNDERSCOREPOS = CHARINDEX('_',@FileNameNoPath)
	
	IF (@UNDERSCOREPOS>0)
	BEGIN
		SET @RealFileName = SUBSTRING(@FileNameNoPath,0,@UNDERSCOREPOS) + @FILEEXTENSION
	END
	
	RETURN @RealFileName

END
GO

