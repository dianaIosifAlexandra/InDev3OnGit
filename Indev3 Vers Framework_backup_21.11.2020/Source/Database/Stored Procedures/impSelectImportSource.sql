--Drops the Procedure impSelectImportSource if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impSelectImportSource]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectImportSource
GO
CREATE PROCEDURE impSelectImportSource

AS

	SELECT 
		ISR.[Id] AS 'Id', 
		ISR.[IdApplicationTypes] AS 'IdApplicationTypes',
		ISR.[Code] AS 'Code', 
		ISR.[SourceName] AS 'SourceName', 
		CAST(ISR.ID as NVARCHAR(10)) + '|' + IAP.Name AS 'IdCodeName'
	FROM [IMPORT_SOURCES] ISR INNER JOIN IMPORT_APPLICATION_TYPES IAP
		ON ISR.IdApplicationTypes = IAP.ID
	WHERE 	Active = 1
	ORDER BY Rank ASC

GO




