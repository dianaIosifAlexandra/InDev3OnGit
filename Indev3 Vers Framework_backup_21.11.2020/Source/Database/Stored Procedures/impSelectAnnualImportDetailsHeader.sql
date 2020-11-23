--Drops the Procedure impSelectAnnualImportDetailsHeader if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impSelectAnnualImportDetailsHeader]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectAnnualImportDetailsHeader
GO
CREATE PROCEDURE impSelectAnnualImportDetailsHeader
(
	@IdImport INT
)

AS

DECLARE @Semaphore nvarchar(1)
DECLARE @ROWCOUNTDELETED_CC INT,
	@ROWCOUNTDELETED_GL INT

SELECT @Semaphore=Validation FROM ANNUAL_BUDGET_IMPORT_LOGS WHERE IDIMPORT=@IdImport
-- PRINT @SEMAPHORE


IF @Semaphore=N'R'
BEGIN
	SELECT 
	C.[Name]			AS	'Country',
	I.[FileName]			AS	'FileName',
	I.ImportDate			AS	'Date',
	IL.[Year]				AS	'Period',
	[ASC].[Name]			AS	'UserName',
	0				AS	'Lines'
	FROM ANNUAL_BUDGET_IMPORT_LOGS AS IL
	INNER JOIN ANNUAL_BUDGET_IMPORTS AS I ON 
		IL.IdImport = I.IdImport
	INNER JOIN 
	(select IdImport, IdRow from ANNUAL_BUDGET_IMPORT_DETAILS where IdImport=@IdImport union 
		SELECT  IdImport, IdRow FROM ANNUAL_BUDGET_IMPORT_LOGS_DETAILS WHERE IdImport = @IdImport 
		and Details like '%not numeric%') ID
		ON IL.IdImport = Id.IDImport
	INNER JOIN ASSOCIATES AS [ASC]
		ON I.IdAssociate = [ASC].Id
	LEFT JOIN COUNTRIES AS C
		ON SUBSTRING(I.[FileName],1,3) = C.Code
	WHERE IL.IdImport = @IdImport
	GROUP BY C.[Name], I.[FileName], I.ImportDate, IL.[Year], [ASC].[Name]
	
	SELECT COUNT(idRow) AS 'NoOfErrors' 
	FROM [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS] 
	WHERE idimport = @IdImport

	SELECT 0 as 'NoOfRowsOk'
END
ELSE
BEGIN


SELECT @ROWCOUNTDELETED_CC =ExclusionCostCenterRowsNo,
	@ROWCOUNTDELETED_GL=ExclusionGlAccountsRowsNo
FROM ANNUAL_BUDGET_IMPORTS
WHERE IDIMPORT = @IdImport

-- PRINT @ROWCOUNTDELETED_CC
-- PRINT @ROWCOUNTDELETED_GL

	SELECT 
	C.[Name]							AS	'Country',
	I.[FileName]							AS	'FileName',
	I.ImportDate							AS	'Date',
	IL.[Year]								AS	'Period',
	[ASC].[Name]							AS	'UserName',
	COUNT (ID.IdRow) + @ROWCOUNTDELETED_CC + @ROWCOUNTDELETED_GL	AS	'Lines'	
	FROM ANNUAL_BUDGET_IMPORT_LOGS AS IL
	INNER JOIN ANNUAL_BUDGET_IMPORTS AS I ON 
		IL.IdImport = I.IdImport
	INNER JOIN ANNUAL_BUDGET_IMPORT_DETAILS ID
		ON IL.IdImport = Id.IDImport
	INNER JOIN ASSOCIATES AS [ASC]
		ON I.IdAssociate = [ASC].Id
	LEFT JOIN COUNTRIES AS C
		ON SUBSTRING(I.[FileName],1,3) = C.Code
	WHERE IL.IdImport = @IdImport
	GROUP BY C.[Name], I.[FileName], I.ImportDate, IL.[Year], [ASC].[Name]

	SELECT COUNT(idRow) AS 'NoOfErrors' 
	FROM [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS] 
	WHERE idimport = @IdImport

	SELECT COUNT(IdImport)  AS 'NoOfRowsOk'
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE IMD.IDIMPORT=@IdImport
	AND NOT EXISTS(	SELECT Id 
			FROM ANNUAL_BUDGET_IMPORT_LOGS_DETAILS ILD 
			WHERE ILD.IDIMPORT = IMD.IDIMPORT AND 
			ILD.IdROW = IMD.IDROW
		      )	

END
GO


