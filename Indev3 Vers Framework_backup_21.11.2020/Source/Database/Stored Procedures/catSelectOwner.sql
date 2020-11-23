--Drops the Procedure catSelectOwner if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectOwner]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectOwner
GO
CREATE PROCEDURE catSelectOwner
	@Id AS INT 	--The Id of the selected Owner
AS
	--If @Id has the value -1, it will return all Owners

IF @Id=-1
BEGIN
	SELECT 	
		O.Code 		AS 'Code',
		O.Name		AS 'Name',
		OT.Name		AS 'OwnerType',
		O.Rank		AS 'Rank',
		O.Id		AS 'Id',
		O.IdOwnerType	AS 'IdOwnerType'
	FROM OWNERS AS O(nolock)
	INNER JOIN OWNER_TYPES AS OT(nolock)
		ON O.IdOwnerType = OT.[Id]	
	ORDER BY O.Rank

END

IF @Id=-2
BEGIN
	SELECT 	
		CAST(NULL AS VARCHAR(10)) 		AS 'Code',
		CAST(NULL AS VARCHAR(30))		AS 'Name',
		CAST(NULL AS VARCHAR(50))		AS 'OwnerType',
		ISNULL(MAX(O.Rank),0) + 1		AS 'Rank',		
		CAST(NULL AS INT)			AS 'Id',
		CAST(NULL AS INT)			AS 'IdOwnerType'
	FROM OWNERS AS O(nolock)
	INNER JOIN OWNER_TYPES AS OT(nolock)
		ON O.IdOwnerType = OT.[Id]
END

IF @Id>0
BEGIN
	SELECT 	
		O.Code 		AS 'Code',
		O.Name		AS 'Name',
		OT.Name	AS 	'OwnerType',
		O.Rank		AS 'Rank',
		O.Id		AS 'Id',
		O.IdOwnerType	AS 'IdOwnerType'
	FROM OWNERS AS O(nolock)
	INNER JOIN OWNER_TYPES AS OT(nolock)
		ON O.IdOwnerType = OT.[Id]
	WHERE O.Id = @Id
END

GO

