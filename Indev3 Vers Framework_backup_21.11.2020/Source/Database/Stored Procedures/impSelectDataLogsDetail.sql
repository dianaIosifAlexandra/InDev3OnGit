--Drops the Procedure bgtGetDataLogsDetail if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impSelectDataLogsDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectDataLogsDetail
GO
CREATE PROCEDURE impSelectDataLogsDetail
	@IdImport INT
AS


	SELECT 	
		ILD.IdRow	AS 'RowNo',
		ILD.Details 	AS 'Details',
		Module		AS 'Module'
	FROM IMPORT_LOGS_DETAILS AS ILD
	WHERE ILD.IdImport = @IdImport
	ORDER BY ILD.IdRow

	RETURN 1
GO

