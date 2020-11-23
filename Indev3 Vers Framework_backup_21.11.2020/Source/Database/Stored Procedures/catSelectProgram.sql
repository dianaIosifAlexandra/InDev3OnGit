--Drops the Procedure catSelectProgram if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectProgram]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectProgram
GO
CREATE PROCEDURE catSelectProgram
	@Id AS INT, 	--The Id of the selected Program
	@OnlyActive AS BIT --flag to take only active programs or not
AS

	--return only active programs
	--If @Id has the value -1, it will return all Programs

IF @Id=-1
BEGIN
	SELECT 	
		P.Code 		AS 'Code',
		P.Name		AS 'Name',
		O.Name		AS 'OwnerName',
		OT.Name		AS 'OwnerType',
		P.IsActive	AS 'IsActive',
		P.Rank		AS 'Rank',
		P.Id		AS 'Id',
		P.IdOwner	AS 'IdOwner',
		OT.Id		AS 'IdOwnerType'
	FROM PROGRAMS P(nolock)
	INNER JOIN OWNERS O(nolock)
		ON P.IdOwner = O.Id
	INNER JOIN OWNER_TYPES OT(nolock)
		ON O.IdOwnerType = OT.Id
	WHERE ISNULL(P.IsActive,0) = CASE @OnlyActive WHEN 0 THEN ISNULL(P.IsActive,0) ELSE 1  END
	ORDER BY P.Rank

END

IF @Id=-2
BEGIN
	
	SELECT 	
		CAST(NULL AS VARCHAR(10)) 		AS 'Code',
		CAST(NULL AS VARCHAR(50))		AS 'Name',
		CAST(NULL AS VARCHAR(30))		AS 'OwnerName',
		CAST(NULL AS VARCHAR(50))		AS 'OwnerType',
		CAST(NULL AS BIT)			AS 'IsActive',
		ISNULL(MAX(P.Rank),0) + 1		AS 'Rank',
		CAST(NULL AS INT)			AS 'Id',
		CAST(NULL AS INT)			AS 'IdOwner',
		CAST(NULL AS INT)			AS 'IdOwnerType'
	FROM PROGRAMS P(nolock)
	INNER JOIN OWNERS O(nolock)
		ON P.IdOwner = O.Id
	INNER JOIN OWNER_TYPES OT(nolock)
		ON O.IdOwnerType = OT.Id
	WHERE ISNULL(P.IsActive,0) = CASE @OnlyActive WHEN 0 THEN ISNULL(P.IsActive,0) ELSE 1  END
	--ORDER BY P.Rank
	
END

IF @Id>0
BEGIN
	SELECT 	
		P.Code 		AS 'Code',
		P.Name		AS 'Name',
		O.Name		AS 'OwnerName',
		OT.Name		AS 'OwnerType',
		P.IsActive	AS 'IsActive',
		P.Rank		AS 'Rank',
		P.Id		AS 'Id',
		P.IdOwner	AS 'IdOwner',
		OT.Id		AS 'IdOwnerType'
	FROM PROGRAMS P(nolock)
	INNER JOIN OWNERS O(nolock)
		ON P.IdOwner = O.Id
	INNER JOIN OWNER_TYPES OT(nolock)
		ON O.IdOwnerType = OT.Id
	WHERE P.Id =  @Id 
		AND ISNULL(P.IsActive,0) = CASE @OnlyActive WHEN 0 THEN ISNULL(P.IsActive,0) ELSE 1  END
	ORDER BY P.Rank
END

GO

