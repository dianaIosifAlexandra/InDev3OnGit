--Drops the Procedure impSelectDataLogs if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impSelectDataLogs]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectDataLogs
GO
CREATE PROCEDURE impSelectDataLogs
	@CountryCode AS varchar(5) --the code of the country
AS
IF @CountryCode IS NULL
	SELECT 
		IL.YearMonth			AS	'YearMonth',
		ISRC.SourceName			AS	'ApplicationName',
		I.[FileName]			AS	'FileName',
		I.ImportDate			AS	'Date',
		SUBSTRING(I.[FileName],4,3)	AS	'CountryCode',
		[ASC].[Name]			AS	'UserName',
		IL.Validation			AS	'Validation',
		I.IdImport			AS	'IdImport',
		I.IdAssociate			AS	'IdUser'
	FROM IMPORT_LOGS AS IL
	INNER JOIN IMPORT_SOURCES AS ISRC ON
		IL.IdSource = ISRC.[Id]
	INNER JOIN IMPORTS AS I ON 
		IL.IdImport = I.IdImport
	INNER JOIN ASSOCIATES AS [ASC]
		ON I.IdAssociate = [ASC].Id
	ORDER BY IdImport DESC

ELSE
	SELECT 
		IL.YearMonth			AS	'YearMonth',
		ISRC.SourceName			AS	'ApplicationName',
		I.[FileName]			AS	'FileName',
		I.ImportDate			AS	'Date',
		SUBSTRING(I.[FileName],4,3)	AS	'CountryCode',
		[ASC].[Name]			AS	'UserName',
		IL.Validation			AS	'Validation',
		I.IdImport			AS	'IdImport',
		I.IdAssociate			AS	'IdUser'
	FROM IMPORT_LOGS AS IL
	INNER JOIN IMPORT_SOURCES AS ISRC ON
		IL.IdSource = ISRC.[Id]
	INNER JOIN IMPORTS AS I ON 
		IL.IdImport = I.IdImport
	INNER JOIN ASSOCIATES AS [ASC] ON 
		I.IdAssociate = [ASC].Id
	INNER JOIN IMPORT_SOURCES_COUNTRIES AS ISC ON 
		IL.IdSource = ISC.IdImportSource
	INNER JOIN COUNTRIES AS C ON 
		ISC.IdCountry = C.Id
	WHERE C.Code = @CountryCode
	ORDER BY IdImport DESC

	RETURN 1
GO
	
		
