--Drops the Procedure extSelectExtractByFunctionFilterFunctions if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extSelectExtractByFunctionFilterFunctions]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extSelectExtractByFunctionFilterFunctions
GO
CREATE PROCEDURE extSelectExtractByFunctionFilterFunctions
	@Id AS INT 	--The Id of the  selected region
AS
	--If @Id has the value -1, it will return all Regions
	SELECT 	F.Id		AS 'Id',		
		F.Name		AS 'Name'		
	FROM [FUNCTIONS] AS F(nolock)	
	WHERE F.[Id] =CASE @Id
				WHEN -1 THEN F.[Id]
				ELSE @Id
				END	
	ORDER BY F.Rank
GO
