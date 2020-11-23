--Drops the Procedure testVerifyProcedureName if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[testVerifyProcedureName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE testVerifyProcedureName
GO
CREATE PROCEDURE testVerifyProcedureName
	@Name AS VARCHAR(100) 	--The Name of the supposed stored procedure
AS

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(@Name) and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	SELECT 1
ELSE 
	SELECT 0
GO

