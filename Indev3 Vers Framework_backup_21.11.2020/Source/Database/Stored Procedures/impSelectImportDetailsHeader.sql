--Drops the Procedure impSelectImportDetailsHeader if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impSelectImportDetailsHeader]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectImportDetailsHeader
GO
CREATE PROCEDURE impSelectImportDetailsHeader
(
	@IdImport INT
)

AS

DECLARE @Semaphore nvarchar(1)
DECLARE @ROWCOUNTDELETED_CC INT,
	@ROWCOUNTDELETED_GL INT,
	@NoOfErrors int

SELECT @Semaphore=Validation FROM IMPORT_LOGS WHERE IDIMPORT=@IdImport

IF @Semaphore=N'R'
BEGIN
	SELECT 
	C.[Name]			AS	'Country',
	I.[FileName]			AS	'FileName',
	I.ImportDate			AS	'Date',
	IL.YearMonth			AS	'Period',
	[ASC].[Name]			AS	'UserName',
	0				AS	'Lines',
	IL.IdSource			AS	'IdSource'
	FROM IMPORT_LOGS AS IL
	INNER JOIN IMPORTS AS I ON 
		IL.IdImport = I.IdImport
	INNER JOIN IMPORT_DETAILS ID
		ON IL.IdImport = Id.IDImport
	INNER JOIN ASSOCIATES AS [ASC]
		ON I.IdAssociate = [ASC].Id
	LEFT JOIN COUNTRIES AS C
		ON SUBSTRING(I.[FileName],4,3) = C.Code
	WHERE IL.IdImport =@IdImport
	GROUP BY C.[Name], I.[FileName], I.ImportDate, IL.YearMonth, [ASC].[Name], IL.IdSource
	
	SELECT @NoOfErrors = COUNT(idRow) 
	FROM [IMPORT_LOGS_DETAILS] 
	WHERE idimport = @IdImport
		
	SELECT @NoOfErrors = @NoOfErrors + COUNT(idRow)
	FROM [IMPORT_LOGS_DETAILS_KEYROWS_MISSING] 
	WHERE idimport = @IdImport
	SELECT @NoOfErrors AS 'NoOfErrors'

	SELECT 0 as 'NoOfRowsOk'
END
ELSE
BEGIN


SELECT @ROWCOUNTDELETED_CC =ExclusionCostCenterRowsNo,
	@ROWCOUNTDELETED_GL=ExclusionGlAccountsRowsNo
FROM IMPORTS
WHERE IDIMPORT = @IdImport

-- PRINT @ROWCOUNTDELETED_CC
-- PRINT @ROWCOUNTDELETED_GL

	SELECT 
	C.[Name]							AS	'Country',
	I.[FileName]							AS	'FileName',
	I.ImportDate							AS	'Date',
	IL.YearMonth							AS	'Period',
	[ASC].[Name]							AS	'UserName',
	COUNT (ID.IdRow) + @ROWCOUNTDELETED_CC + @ROWCOUNTDELETED_GL	AS	'Lines',
	IL.IdSource							AS	'IdSource'
	FROM IMPORT_LOGS AS IL
	INNER JOIN IMPORTS AS I ON 
		IL.IdImport = I.IdImport
	INNER JOIN IMPORT_DETAILS ID
		ON IL.IdImport = Id.IDImport
	INNER JOIN ASSOCIATES AS [ASC]
		ON I.IdAssociate = [ASC].Id
	LEFT JOIN COUNTRIES AS C
		ON SUBSTRING(I.[FileName],4,3) = C.Code
	WHERE IL.IdImport =@IdImport
	GROUP BY C.[Name], I.[FileName], I.ImportDate, IL.YearMonth, [ASC].[Name], IL.IdSource

	SELECT @NoOfErrors = COUNT(idRow) 
	FROM [IMPORT_LOGS_DETAILS] 
	WHERE idimport = @IdImport
		
	SELECT @NoOfErrors = @NoOfErrors + COUNT(idRow)
	FROM [IMPORT_LOGS_DETAILS_KEYROWS_MISSING] 
	WHERE idimport = @IdImport
	SELECT @NoOfErrors AS 'NoOfErrors'

	SELECT COUNT(IdImport)  AS 'NoOfRowsOk'
	FROM IMPORT_DETAILS IMD
	WHERE IMD.IDIMPORT=@IdImport
	AND NOT EXISTS(	SELECT Id 
			FROM IMPORT_LOGS_DETAILS ILD 
			WHERE ILD.IDIMPORT = IMD.IDIMPORT AND 
			ILD.IdROW = IMD.IDROW
		      )	
	AND NOT EXISTS(	SELECT Id 
			FROM IMPORT_LOGS_DETAILS_KEYROWS_MISSING ILD 
			WHERE ILD.IDIMPORT = IMD.IDIMPORT AND 
			ILD.IdROW = IMD.IDROW
		      )	
END
GO

