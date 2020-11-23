--Drops the Procedure abgtSelectAnnualDataLogsDetail if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[abgtSelectAnnualDataLogsDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE abgtSelectAnnualDataLogsDetail
GO
CREATE PROCEDURE abgtSelectAnnualDataLogsDetail
	@IdImport INT
AS

DECLARE @ROWCOUNTDELETED_CC INT,
	@ROWCOUNTDELETED_GL INT

SELECT @ROWCOUNTDELETED_CC =ExclusionCostCenterRowsNo,
	@ROWCOUNTDELETED_GL=ExclusionGlAccountsRowsNo
FROM ANNUAL_BUDGET_IMPORTS
WHERE IDIMPORT = @IdImport

	SELECT 
		C.[Name]								AS	'Country',
		I.[FileName]								AS	'FileName',
		I.ImportDate								AS	'Date',
		IL.[Year]									AS	'Year',
		A.Name									AS	'UserName',
		COUNT (DISTINCT AID.IdRow) + @ROWCOUNTDELETED_CC + @ROWCOUNTDELETED_GL	AS	'Lines'
	FROM ANNUAL_BUDGET_IMPORT_LOGS AS IL
	INNER JOIN ANNUAL_BUDGET_IMPORTS AS I ON 
		IL.IdImport = I.IdImport
	INNER JOIN ANNUAL_BUDGET_IMPORT_DETAILS AS AID 
		ON AID.IdImport = I.IdImport
	INNER JOIN ASSOCIATES A
		ON I.IdAssociate = A.Id
	LEFT JOIN COUNTRIES AS C ON SUBSTRING(I.[FileName],1,3)=C.Code
	WHERE IL.IdImport = @IdImport
	GROUP BY C.[Name], I.[FileName], I.ImportDate, IL.[Year], A.Name

	SELECT 	
		ILD.IdRow	AS 'RowNo',
		ILD.Details 	AS 'Details',
		Module		AS 'Module'
	FROM ANNUAL_BUDGET_IMPORT_LOGS_DETAILS AS ILD
	WHERE ILD.IdImport = @IdImport
	ORDER BY ILD.IdRow

	RETURN 1
GO
