--Drops the Procedure catSelectWorkPackageTemplate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectWorkPackageTemplate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectWorkPackageTemplate
GO
CREATE PROCEDURE catSelectWorkPackageTemplate
	@IdPhase	AS INT,		--The IdPhase of the selected WorkPackage
	@Id		AS INT	 	--The Id of the WorkPackage
	
AS
	--If @Id has the value -1, it will return all WorkPackagesTemplate


IF @Id=-1
BEGIN
	
	SELECT 	
		PP.Name			AS 'ProjectPhase',
		WP.Code 		AS 'Code',
		WP.Name			AS 'Name',
		WP.Rank			AS 'Rank',
		WP.IsActive		AS 'IsActive',
		WP.LastUpdate		AS 'LastUpdate',
		A.Name			AS 'LastUserUpdate',
		CAST (0 AS BIT) 	AS 'IsProgramManager',
		WP.LastUserUpdate	AS 'IdLastUserUpdate',
		WP.Id			AS 'Id',
		WP.IdPhase		AS 'IdPhase'
	FROM WORK_PACKAGES_TEMPLATE AS WP	
	INNER JOIN PROJECT_PHASES AS PP
		ON WP.IdPhase = PP.Id
	INNER JOIN ASSOCIATES AS A
		ON WP.LastUserUpdate = A.Id
	ORDER BY WP.Rank
	
END

IF @Id=-2
BEGIN
	
	SELECT 	
		CAST(NULL AS VARCHAR(3))	AS 'ProjectPhase',
		CAST(NULL AS VARCHAR(3)) 	AS 'Code',
		CAST(NULL AS VARCHAR(30))	AS 'Name',
		ISNULL(MAX(WP.Rank),0)+1	AS 'Rank',
		CAST(NULL AS BIT)		AS 'IsActive',
		CAST(NULL AS datetime)		AS 'LastUpdate',
		CAST(NULL AS INT)		AS 'LastUserUpdate',
		CAST (0 AS BIT) 		AS 'IsProgramManager',
		CAST(NULL AS INT)		AS 'IdLastUserUpdate',
		CAST(NULL AS INT)		AS 'Id',
		CAST(NULL AS INT)		AS 'IdPhase'
	FROM WORK_PACKAGES_TEMPLATE AS WP	
	INNER JOIN PROJECT_PHASES AS PP
		ON WP.IdPhase = PP.Id
	INNER JOIN ASSOCIATES AS A
		ON WP.LastUserUpdate = A.Id
	
END

IF @Id>0
BEGIN
	SELECT 	
		PP.Name			AS 'ProjectPhase',
		WP.Code 		AS 'Code',
		WP.Name			AS 'Name',
		WP.Rank			AS 'Rank',
		WP.IsActive		AS 'IsActive',
		WP.LastUpdate		AS 'LastUpdate',
		A.Name			AS 'LastUserUpdate',
		CAST (0 AS BIT) 	AS 'IsProgramManager',
		WP.LastUserUpdate	AS 'IdLastUserUpdate',
		WP.Id			AS 'Id',
		WP.IdPhase		AS 'IdPhase'
	FROM WORK_PACKAGES_TEMPLATE AS WP	
	INNER JOIN PROJECT_PHASES AS PP
		ON WP.IdPhase = PP.Id
	INNER JOIN ASSOCIATES AS A
		ON WP.LastUserUpdate = A.Id
	WHERE 	WP.IdPhase = @IdPhase AND
			WP.Id = @Id
	ORDER BY WP.Rank
END

GO

