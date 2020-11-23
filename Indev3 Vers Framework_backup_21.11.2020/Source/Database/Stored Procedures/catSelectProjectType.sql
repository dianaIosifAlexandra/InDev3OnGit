--Drops the Procedure catSelectProjectType if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectProjectType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectProjectType
GO
CREATE PROCEDURE catSelectProjectType
	@Id AS INT 	--The Id of the selected Project Type
AS
	--If @Id has the value -1, it will return all Project Types

IF @Id=-1
BEGIN
	SELECT 	
		PT.Type		AS 'Type',
		PT.Rank		AS 'Rank',
		PT.[Id]		AS 'Id'
	FROM PROJECT_TYPES PT(nolock)	
	ORDER BY PT.Rank

END

IF @Id=-2
BEGIN
	SELECT 	
		CAST(NULL AS VARCHAR(20))		AS 'Type',
		ISNULL(MAX(PT.Rank),0) + 1		AS 'Rank',
		CAST(NULL AS INT)			AS 'Id'
	FROM PROJECT_TYPES PT(nolock)
END

IF @Id>0
BEGIN
	SELECT 	
		PT.Type		AS 'Type',
		PT.Rank		AS 'Rank',
		PT.[Id]		AS 'Id'
	FROM PROJECT_TYPES PT(nolock)
	WHERE PT.[Id] = @Id
END

GO

