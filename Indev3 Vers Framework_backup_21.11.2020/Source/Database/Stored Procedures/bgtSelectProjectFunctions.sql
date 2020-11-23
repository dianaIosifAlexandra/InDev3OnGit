--Drops the Procedure bgtSelectProjectFunctions if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtSelectProjectFunctions]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtSelectProjectFunctions
GO
CREATE PROCEDURE bgtSelectProjectFunctions
AS
		SELECT 	PF.[Id]		AS 'Id',
			PF.[Name]	AS 'Name'
		FROM PROJECT_FUNCTIONS AS PF
		ORDER BY PF.Rank
GO

