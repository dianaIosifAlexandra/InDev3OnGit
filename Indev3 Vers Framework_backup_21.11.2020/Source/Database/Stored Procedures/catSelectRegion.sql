--Drops the Procedure catSelectRegion if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectRegion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectRegion
GO
CREATE PROCEDURE catSelectRegion
	@Id AS INT 	--The Id of the selected Region
AS
	--If @Id has the value -1 it will return all Regions
	--if @id has the value -2 it will return new rank
SET NOCOUNT ON

IF @Id=-1
BEGIN
	SELECT 	
		R.Code		AS 'Code',
		R.Name		AS 'Name',
		R.Rank		AS 'Rank',
		R.Id		AS 'Id'		
		
	FROM REGIONS R(nolock)
	WHERE R.Id =R.Id
	ORDER BY R.Rank
END

IF @Id=-2
BEGIN
	
			
	SELECT
		CAST(NULL AS VARCHAR(8)) 	AS 'Code',
		CAST(NULL AS VARCHAR(30)) 	AS 'Name',
		ISNULL(MAX(R.Rank),0) + 1 	AS 'Rank',
		CAST(NULL AS INT) 		AS 'Id'
	FROM REGIONS R(nolock)
END

IF @Id>0
BEGIN
	SELECT 	
		R.Code		AS 'Code',
		R.Name		AS 'Name',
		R.Rank		AS 'Rank',
		R.Id		AS 'Id'		
		
	FROM REGIONS R(nolock)
	WHERE R.Id =@Id
	ORDER BY R.Rank
END

-- exec catSelectRegion @Id = -1
GO

