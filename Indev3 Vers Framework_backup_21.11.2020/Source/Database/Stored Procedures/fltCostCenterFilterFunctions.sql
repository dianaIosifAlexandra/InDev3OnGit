--Drops the Procedure fltCostCenterFilterFunctions if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fltCostCenterFilterFunctions]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE fltCostCenterFilterFunctions
GO
CREATE PROCEDURE fltCostCenterFilterFunctions	
AS
		SELECT  F.[Id]			AS 'Id',
			F.[Name]		AS 'Name',
			F.Rank			AS 'Rank'
		FROM [FUNCTIONS] F
		ORDER BY F.Rank
		
GO


