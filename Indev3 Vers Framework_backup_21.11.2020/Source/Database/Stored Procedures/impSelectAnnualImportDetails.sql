--Drops the Procedure impSelectAnnualImportDetails if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impSelectAnnualImportDetails]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectAnnualImportDetails
GO
CREATE PROCEDURE impSelectAnnualImportDetails
(
	@IdImport INT
)
AS
IF (@IdImport is null )
BEGIN 
	RAISERROR('No import selected',16,1)		
	RETURN -1
END


SELECT  BID.IdImport,
	BID.IdRow,
	BID.CostCenter,
	BID.ProjectCode,
	P.Id as ProjectId,
	BID.WPCode,
	BID.AccountNumber,
	isnull(BID.Quantity1,0) + isnull(BID.Quantity2,0) + isnull(BID.Quantity3,0) + isnull(BID.Quantity4,0) + isnull(BID.Quantity5,0) + isnull(BID.Quantity6,0) 
	+ isnull(BID.Quantity7,0) + isnull(BID.Quantity8,0) + isnull(BID.Quantity9,0) + isnull(BID.Quantity10,0) + isnull(BID.Quantity11,0) + isnull(BID.Quantity12,0)
	as Quantity,
	isnull(BID.Value1,0) + isnull(BID.Value2,0) + isnull(BID.Value3,0) + isnull(BID.Value4,0) + isnull(BID.Value5,0) + isnull(BID.Value6,0)
	+ isnull(BID.Value7,0) + isnull(BID.Value8,0) + isnull(BID.Value9,0) + isnull(BID.Value10,0) + isnull(BID.Value11,0) + isnull(BID.Value12,0)
	as Value,
	BID.CurrencyCode,
	BID.Date 
FROM ANNUAL_BUDGET_IMPORT_DETAILS BID
INNER JOIN ANNUAL_BUDGET_IMPORT_LOGS_DETAILS BILD
	ON BILD.IdImport = BID.IdImport AND
	BILD.IdRow = BID.IdRow AND
-- HACK TO TAKE ONLY ROWS THAT EXISTS IN ANNUAL_BUDGET_IMPORT_LOGS_DETAILS
	BILD.Id = (SELECT MIN(ID)
		   FROM ANNUAL_BUDGET_IMPORT_LOGS_DETAILS ild
		   WHERE ild.idimport = BILD.idimport AND
		   ild.idrow = BILD.idrow)
LEFT JOIN PROJECTS P
	ON BID.ProjectCode = P.CODE
	
WHERE BID.IdImport = @IdImport
union
-- get column1..12, value1..12 not numeric errors from ANNUAL_BUDGET_IMPORT_LOGS_DETAILS
SELECT  IdImport,
	IdRow,
	'',
	'',
	null,
	'',
	'',
	null as Quantity,
	null as Value,
	'',
	null 
FROM ANNUAL_BUDGET_IMPORT_LOGS_DETAILS 
WHERE IdImport = @IdImport and Details like '%not numeric%'
ORDER BY 2

GO
