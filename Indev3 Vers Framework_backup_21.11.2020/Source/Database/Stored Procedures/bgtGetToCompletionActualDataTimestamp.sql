--Drops the Procedure bgtGetToCompletionActualDataTimestamp if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetToCompletionActualDataTimestamp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetToCompletionActualDataTimestamp
GO

CREATE PROCEDURE bgtGetToCompletionActualDataTimestamp
AS
	SELECT 	GETDATE()
GO

