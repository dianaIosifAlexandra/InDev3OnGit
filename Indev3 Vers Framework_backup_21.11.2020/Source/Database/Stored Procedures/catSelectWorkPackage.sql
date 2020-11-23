--Drops the Procedure catSelectWorkPackage if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectWorkPackage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectWorkPackage
GO
CREATE PROCEDURE catSelectWorkPackage
	@IdProject 	AS INT, 	--The IdProject of the selected WorkPackage
	@IdPhase	AS INT,		--The IdPhase of the selected WorkPackage
	@Id		AS INT,	 	--The Id of the WorkPackage
	@IdAssociate	AS INT 		--The Id of the Associate that holds the project in ProjectCoreTeams. If the Associate is -1 then all 
					--work packages will be returned, else, we will check if the associate has any project where he is 
					--Program Manager. If there is one, it will return the Work Package for that Project
AS
	--If @Id has the value -1, it will return all WorkPackages


IF @Id=-1
BEGIN
	IF (@IdAssociate = -1)
		BEGIN
			SELECT 	
				PP.Name			AS 'ProjectPhase',
				WP.Code 		AS 'Code',
				WP.Name			AS 'Name',
				WP.Rank			AS 'Rank',
				WP.IsActive		AS 'IsActive',
				WP.StartYearMonth	AS 'StartYearMonth',
				WP.EndYearMonth		AS 'EndYearMonth',
				WP.LastUpdate		AS 'LastUpdate',
				A.Name			AS 'LastUserUpdate',
				CAST (0 AS BIT) 	AS 'IsProgramManager',
				P.Name			AS 'ProjectName',	
				WP.LastUserUpdate	AS 'IdLastUserUpdate',
				WP.Id			AS 'Id',
				WP.IdPhase		AS 'IdPhase',
				WP.IdProject		AS 'IdProject',
				CAST(-1 AS INT)		AS 'IdProjectFunction'
			FROM WORK_PACKAGES AS WP	
			INNER JOIN PROJECTS AS P
				ON WP.IdProject = P.Id 
			INNER JOIN PROJECT_PHASES AS PP
				ON WP.IdPhase = PP.Id
			INNER JOIN ASSOCIATES AS A
				ON WP.LastUserUpdate = A.Id
			WHERE WP.IdProject = case when @IdProject = -1 then WP.IdProject else @IdProject end
			ORDER BY WP.Rank
		END
		ELSE
		BEGIN
			SELECT 	
				PP.Name			AS 'ProjectPhase',
				WP.Code 		AS 'Code',
				WP.Name			AS 'Name',
				WP.Rank			AS 'Rank',
				WP.IsActive		AS 'IsActive',
				WP.StartYearMonth	AS 'StartYearMonth',
				WP.EndYearMonth		AS 'EndYearMonth',
				WP.LastUpdate		AS 'LastUpdate',
				A.Name			AS 'LastUserUpdate',
				dbo.fnIsAssociatePMOnProject(WP.IdProject, @IdAssociate) AS 'IsProgramManager',
				P.Name			AS 'ProjectName',	
				WP.LastUserUpdate	AS 'IdLastUserUpdate',
				WP.Id			AS 'Id',
				WP.IdPhase		AS 'IdPhase',
				WP.IdProject		AS 'IdProject',
				PCT.IdFunction		AS 'IdProjectFunction'
			FROM WORK_PACKAGES AS WP	
			INNER JOIN PROJECTS AS P
				ON WP.IdProject = P.Id 
			INNER JOIN PROJECT_PHASES AS PP
				ON WP.IdPhase = PP.Id
			INNER JOIN ASSOCIATES AS A
				ON WP.LastUserUpdate = A.Id
			INNER JOIN PROJECT_CORE_TEAMS AS PCT
				ON  PCT.IdProject = P.[Id]
				AND PCT.IdAssociate = @IdAssociate
				AND PCT.IsActive = 1
			WHERE WP.IdProject = case when @IdProject = -1 then WP.IdProject else @IdProject end
			ORDER BY WP.Rank
		END
END

IF @Id=-2
BEGIN
	IF (@IdAssociate = -1)
		BEGIN
			SELECT 	
				CAST(NULL AS VARCHAR(3))	AS 'ProjectPhase',
				CAST(NULL AS VARCHAR(3)) 	AS 'Code',
				CAST(NULL AS VARCHAR(30))	AS 'Name',
				ISNULL(MAX(WP.Rank),0)+1	AS 'Rank',
				CAST(NULL AS BIT)		AS 'IsActive',
				CAST(NULL AS INT)		AS 'StartYearMonth',
				CAST(NULL AS INT)		AS 'EndYearMonth',
				CAST(NULL AS datetime)		AS 'LastUpdate',
				CAST(NULL AS INT)		AS 'LastUserUpdate',
				CAST (0 AS BIT) 		AS 'IsProgramManager',
				CAST(NULL AS VARCHAR(50))	AS 'ProjectName',	
				CAST(NULL AS INT)		AS 'IdLastUserUpdate',
				CAST(NULL AS INT)		AS 'Id',
				CAST(NULL AS INT)		AS 'IdPhase',
				CAST(NULL AS INT)		AS 'IdProject',
				CAST(-1	  AS INT)		AS 'IdProjectFunction'
			FROM WORK_PACKAGES AS WP	
			INNER JOIN PROJECTS AS P
				ON WP.IdProject = P.Id 
			INNER JOIN PROJECT_PHASES AS PP
				ON WP.IdPhase = PP.Id
			INNER JOIN ASSOCIATES AS A
				ON WP.LastUserUpdate = A.Id
			WHERE WP.IdProject = case when @IdProject = -1 then WP.IdProject else @IdProject end
		END
		ELSE
		BEGIN
			SELECT 	
				CAST(NULL AS VARCHAR(3))	AS 'ProjectPhase',
				CAST(NULL AS VARCHAR(3)) 	AS 'Code',
				CAST(NULL AS VARCHAR(30))	AS 'Name',
				ISNULL(MAX(WP.Rank),0)+1	AS 'Rank',
				CAST(NULL AS BIT)		AS 'IsActive',
				CAST(NULL AS INT)		AS 'StartYearMonth',
				CAST(NULL AS INT)		AS 'EndYearMonth',
				CAST(NULL AS datetime)		AS 'LastUpdate',
				CAST(NULL AS INT)		AS 'LastUserUpdate',
				CAST (0 AS BIT)			AS 'IsProgramManager',
				CAST(NULL AS VARCHAR(50))	AS 'ProjectName',	
				CAST(NULL AS INT)		AS 'IdLastUserUpdate',
				CAST(NULL AS INT)		AS 'Id',
				CAST(NULL AS INT)		AS 'IdPhase',
				CAST(NULL AS INT)		AS 'IdProject',
				CAST(-1	  AS INT)		AS 'IdProjectFunction'
			FROM WORK_PACKAGES AS WP	
			INNER JOIN PROJECTS AS P
				ON WP.IdProject = P.Id 
			INNER JOIN PROJECT_PHASES AS PP
				ON WP.IdPhase = PP.Id
			INNER JOIN ASSOCIATES AS A
				ON WP.LastUserUpdate = A.Id
			INNER JOIN PROJECT_CORE_TEAMS AS PCT
				ON  PCT.IdProject = P.[Id]
				AND PCT.IdAssociate = @IdAssociate
				AND PCT.IsActive = 1
			WHERE WP.IdProject = case when @IdProject = -1 then WP.IdProject else @IdProject end
		END
END

IF @Id>0
BEGIN
	SELECT 	
		PP.Name			AS 'ProjectPhase',
		WP.Code 		AS 'Code',
		WP.Name			AS 'Name',
		WP.Rank			AS 'Rank',
		WP.IsActive		AS 'IsActive',
		WP.StartYearMonth	AS 'StartYearMonth',
		WP.EndYearMonth		AS 'EndYearMonth',
		WP.LastUpdate		AS 'LastUpdate',
		A.Name			AS 'LastUserUpdate',
		dbo.fnIsAssociatePMOnProject(WP.IdProject, @IdAssociate) AS 'IsProgramManager',
		P.Name			AS 'ProjectName',
		WP.LastUserUpdate	AS 'IdLastUserUpdate',
		WP.Id			AS 'Id',
		WP.IdPhase		AS 'IdPhase',
		WP.IdProject		AS 'IdProject',
		ISNULL(PCT.IdFunction, -1) AS 'IdProjectFunction'
	FROM WORK_PACKAGES AS WP	
	INNER JOIN PROJECTS AS P
		ON WP.IdProject = P.Id
	INNER JOIN PROJECT_PHASES AS PP
		ON WP.IdPhase = PP.Id
	INNER JOIN ASSOCIATES AS A
		ON WP.LastUserUpdate = A.Id
	LEFT JOIN PROJECT_CORE_TEAMS AS PCT
		ON  PCT.IdProject = P.Id AND
		    PCT.IdAssociate = @IdAssociate AND
		    PCT.IsActive = 1
	WHERE 	WP.IdProject = @IdProject AND
			WP.IdPhase = @IdPhase AND
			WP.Id = @Id
	ORDER BY WP.Rank
END

GO

