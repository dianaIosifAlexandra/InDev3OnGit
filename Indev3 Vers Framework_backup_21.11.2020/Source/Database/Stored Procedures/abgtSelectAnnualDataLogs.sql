--Drops the Procedure abgtSelectAnnualDataLogs if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[abgtSelectAnnualDataLogs]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE abgtSelectAnnualDataLogs
GO
CREATE PROCEDURE abgtSelectAnnualDataLogs
	@CountryCode AS varchar(5) --the code of the country
AS
IF @CountryCode IS NULL
	SELECT 
		IL.[Year]				AS	'Year',
		I.[FileName]			AS	'FileName',
		I.ImportDate			AS	'Date',
		SUBSTRING(I.[FileName],1,3)	AS	'CountryCode',
		[ASC].[Name]			AS	'UserName',
		IL.Validation			AS	'Validation',
		I.IdImport			AS	'IdImport',
		I.IdAssociate			AS	'IdUser'
	FROM ANNUAL_BUDGET_IMPORT_LOGS AS IL
	INNER JOIN ANNUAL_BUDGET_IMPORTS AS I ON 
		IL.IdImport = I.IdImport
	INNER JOIN ASSOCIATES AS [ASC]
		ON I.IdAssociate = [ASC].Id
	ORDER BY IdImport DESC
ELSE
	SELECT 
		IL.[Year]				AS	'Year',
		I.[FileName]			AS	'FileName',
		I.ImportDate			AS	'Date',
		SUBSTRING(I.[FileName],1,3)	AS	'CountryCode',
		[ASC].[Name]			AS	'UserName',
		IL.Validation			AS	'Validation',
		I.IdImport			AS	'IdImport',
		I.IdAssociate			AS	'IdUser'
	FROM ANNUAL_BUDGET_IMPORT_LOGS AS IL
	INNER JOIN ANNUAL_BUDGET_IMPORTS AS I ON 
		IL.IdImport = I.IdImport
	INNER JOIN ASSOCIATES AS [ASC]
		ON I.IdAssociate = [ASC].Id
	WHERE SUBSTRING(I.[FileName],1,3) = @CountryCode
	ORDER BY IdImport DESC

	RETURN 1
GO
	

