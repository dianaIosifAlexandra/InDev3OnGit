--Drops the Procedure extSelectExtractByFunctionFilterRegions if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extSelectExtractByFunctionFilterRegions]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extSelectExtractByFunctionFilterRegions
GO
CREATE PROCEDURE extSelectExtractByFunctionFilterRegions
	@Id AS INT 	--The Id of the  selected region
AS
	--If @Id has the value -1, it will return all Regions
	SELECT 	R.Id		AS 'Id',		
		R.Name		AS 'Name'		
	FROM REGIONS AS R(nolock)	
	WHERE R.Id =CASE @Id
				WHEN -1 THEN R.Id
				ELSE @Id
				END	
	ORDER BY R.Rank
GO
