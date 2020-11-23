--Drops the Procedure fltProjectSelectorProjects if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fltProjectSelectorProjects]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE fltProjectSelectorProjects
GO

-- exec fltProjectSelectorProjects -1,78,-1,'A','C'

CREATE PROCEDURE fltProjectSelectorProjects
	@IdOwner		AS INT,		--The Id of the Owner
	@IdAssociate		AS INT,		--The Id of the Associate
	@IdProgram		AS INT,		--The Id of the Program
	@ShowOnly		AS CHAR(1),	--The option to filter projects after their state
	@OrderBy 		AS CHAR(1)  --Order By option: 'C' - Project Code, 'N' - Project Name
AS
BEGIN

--If @IdOwner has the value -1, it will return all Projects
DECLARE @IsBAOrTA BIT,
	@IsFinancial BIT,
	@IsFM BIT,
	@IsKeyUser bit	

--the Role of BA or TA has special access rights - they may see all the projects
SET @IsBAOrTA = dbo.fnIsBAOrTA(@IdAssociate)
SET @IsFinancial = dbo.fnIsFinancial(@IdAssociate)
SET @IsFM = dbo.fnIsFunctionalManager(@IdAssociate)
set @IsKeyUser = dbo.fnIsKeyUser(@IdAssociate)

CREATE TABLE #TempProjects
(
	ProjectId			INT,
	ProjectName			VARCHAR(80),
	ProgramName 			VARCHAR(80),
	ProjectFunction 		VARCHAR(50),
	ProgramId 			INT,
	ProjectFunctionId 		INT,
	ProjectFunctionWPCodeSuffix	VARCHAR(29),
	OwnerId 			INT,
	ProgramCode			VARCHAR(10),
	ProjectCode			VARCHAR(10),
	ActiveMembers			INT DEFAULT 0,
	TimingIntercoPercent		INT DEFAULT 0,
	IsInitialBudgetValidated	BIT DEFAULT 0
)

	
IF (@IsBAOrTA = 1 OR @IsFM = 1  or @IsKeyUser = 1)
BEGIN
	INSERT INTO #TempProjects 
		([ProjectId], [ProjectName], ProgramName, ProjectFunction, ProgramId, 
		ProjectFunctionId, ProjectFunctionWPCodeSuffix, OwnerId, ProgramCode, ProjectCode)
	SELECT 	P.Id			AS 'ProjectId',
		(CASE WHEN @OrderBy = 'C' THEN P.Code + ' [' + P.Name + ']'
		else P.Name + ' [' + P.Code + ']' END) AS 'ProjectName',
		PR.Name			AS 'ProgramName',
		ISNULL(PF.Name, 'None') AS 'ProjectFunction',
		PR.Id			AS 'ProgramId',
		ISNULL(PF.Id, -1)	AS 'ProjectFunctionId',
		ISNULL(PF.WPCodeSuffixes, '')	AS 'ProjectFunctionWPCodeSuffix',
		O.Id			AS 'OwnerId',
		PR.Code			AS 'ProgramCode',
		P.Code			AS 'ProjectCode'
	FROM PROJECTS P(nolock)
	INNER JOIN PROGRAMS PR(nolock)
		ON P.IdProgram = PR.Id
	INNER JOIN OWNERS O(nolock)
		ON PR.IdOwner = O.Id
	LEFT JOIN PROJECT_CORE_TEAMS PCT (nolock)
		ON PCT.IdProject = P.Id AND
		   PCT.IdAssociate = @IdAssociate
	LEFT JOIN PROJECT_FUNCTIONS PF(nolock)
		ON PCT.IdFunction = PF.[Id]	
	WHERE (O.Id = CASE WHEN @IdOwner = -1 THEN O.Id ELSE @IdOwner END) and
	      (P.IdProgram = CASE WHEN @IdProgram =-1 THEN P.IdProgram ELSE @IdProgram END) and
	      (P.IsActive = CASE WHEN @ShowOnly = 'A' THEN 1
				WHEN @ShowOnly = 'I' THEN 0
				WHEN @ShowOnly = 'T' THEN P.IsActive END) 
END

IF (@IsFinancial = 1)
BEGIN
	DECLARE @IdCountryAssociate INT

	SELECT @IdCountryAssociate = IdCountry 
	FROM ASSOCIATES (nolock)
	WHERE Id = @IdAssociate

	INSERT INTO #TempProjects 
		([ProjectId], [ProjectName], ProgramName, ProjectFunction, ProgramId, 
		ProjectFunctionId, ProjectFunctionWPCodeSuffix, OwnerId, ProgramCode, ProjectCode)
	SELECT 	P.Id			AS 'ProjectId',
		(CASE WHEN @OrderBy = 'C' THEN P.Code + ' [' + P.Name + ']'
		else P.Name + ' [' + P.Code + ']' END) AS 'ProjectName',
		PR.Name			AS 'ProgramName',
		ISNULL(PF.Name, 'None') AS 'ProjectFunction',
		PR.Id			AS 'ProgramId',
		PF.Id			AS 'ProjectFunctionId',
		PF.WPCodeSuffixes	AS 'ProjectFunctionWPCodeSuffix',
		O.Id			AS 'OwnerId',
		PR.Code			AS 'ProgramCode',
		P.Code			AS 'ProjectCode'
	FROM PROJECTS AS P(nolock)
	INNER JOIN PROGRAMS PR(nolock)
		ON P.IdProgram = PR.Id
	INNER JOIN OWNERS O(nolock)
		ON PR.IdOwner = O.Id
	INNER JOIN PROJECT_CORE_TEAMS PCT(nolock)
		ON PCT.IdProject = P.Id AND
		   PCT.IdAssociate = @IdAssociate
	INNER JOIN PROJECT_FUNCTIONS PF(nolock)
		ON PCT.IdFunction = PF.[Id]
	WHERE (O.Id = CASE WHEN @IdOwner = -1 THEN O.Id ELSE @IdOwner END) and
	      (P.IdProgram = CASE WHEN @IdProgram =-1 THEN P.IdProgram ELSE @IdProgram END) and
	      (P.IsActive = CASE WHEN @ShowOnly = 'A' THEN 1
				WHEN @ShowOnly = 'I' THEN 0
				WHEN @ShowOnly = 'T' THEN P.IsActive END) AND
	PCT.IsActive = 1 --only when core team member is active

	UNION		

	SELECT DISTINCT
		P.Id			AS 'ProjectId',
		(CASE WHEN @OrderBy = 'C' THEN P.Code + ' [' + P.Name + ']'
		else P.Name + ' [' + P.Code + ']' END) AS 'ProjectName',
		PR.Name			AS 'ProgramName',
		'None'			AS 'ProjectFunction',
		PR.Id			AS 'ProgramId',
		-1			AS 'ProjectFunctionId',
		''			AS 'ProjectFunctionWPCodeSuffix',
		O.Id			AS 'OwnerId',
		PR.Code			AS 'ProgramCode',
		P.Code			AS 'ProjectCode'
	FROM PROJECTS AS P(nolock)
	INNER JOIN PROGRAMS PR(nolock)
		ON P.IdProgram = PR.Id
	INNER JOIN OWNERS O(nolock)
		ON PR.IdOwner = O.Id
	INNER JOIN PROJECTS_INTERCO_LAYOUT PIL 
		ON PIL.IdProject = P.[Id] AND 
		   PIL.IdCountry = @IdCountryAssociate
	WHERE (O.Id = CASE WHEN @IdOwner = -1 THEN O.Id ELSE @IdOwner END) and
	      (P.IdProgram = CASE WHEN @IdProgram =-1 THEN P.IdProgram ELSE @IdProgram END) and
	      (P.IsActive = CASE WHEN @ShowOnly = 'A' THEN 1
				WHEN @ShowOnly = 'I' THEN 0
				WHEN @ShowOnly = 'T' THEN P.IsActive END)
	
	--delete duplicates due to coincidence of project manager function in project and financial role
	DELETE FROM #TempProjects 
	WHERE ProjectId IN 
	(
		SELECT [ProjectId] FROM #TempProjects
		GROUP BY [ProjectId]
		HAVING COUNT(ProjectId) > 1
	) AND ProjectFunctionId = -1 
END

IF NOT ( (@IsBAOrTA = 1 OR @IsFM = 1) OR (@IsFinancial = 1) or (@IsKeyUser = 1) )
BEGIN
	-- the only difference in this case is that we use a INNER JOIN with PROJECT_CORE_TEAMS 
	-- to supress the projects in which the associate has no role at all
	INSERT INTO #TempProjects 
		([ProjectId], [ProjectName], ProgramName, ProjectFunction, ProgramId, 
		ProjectFunctionId, ProjectFunctionWPCodeSuffix, OwnerId, ProgramCode, ProjectCode)
	SELECT 	P.Id			AS 'ProjectId',
		(CASE WHEN @OrderBy = 'C' THEN P.Code + ' [' + P.Name + ']'
		else P.Name + ' [' + P.Code + ']' END) AS 'ProjectName',
		PR.Name			AS 'ProgramName',
		ISNULL(PF.Name, 'None') AS 'ProjectFunction',
		PR.Id			AS 'ProgramId',
		ISNULL(PF.Id, -1)	AS 'ProjectFunctionId',
		ISNULL(PF.WPCodeSuffixes, '')	AS 'ProjectFunctionWPCodeSuffix',
		O.Id			AS 'OwnerId',
		PR.Code			AS 'ProgramCode',
		P.Code			AS 'ProjectCode'
	FROM PROJECTS AS P(nolock)
	INNER JOIN PROGRAMS PR(nolock)
		ON P.IdProgram = PR.Id
	INNER JOIN OWNERS O(nolock)
		ON PR.IdOwner = O.Id
	INNER JOIN PROJECT_CORE_TEAMS PCT(nolock)
		ON P.Id = PCT.IdProject AND
		   PCT.IdAssociate = @IdAssociate
	INNER JOIN PROJECT_FUNCTIONS PF(nolock)
		ON PCT.IdFunction = PF.[Id]
	WHERE (O.Id = CASE WHEN @IdOwner = -1 THEN O.Id ELSE @IdOwner END) and
	      (P.IdProgram = CASE WHEN @IdProgram =-1 THEN P.IdProgram ELSE @IdProgram END) and
	      (P.IsActive = CASE WHEN @ShowOnly = 'A' THEN 1
				WHEN @ShowOnly = 'I' THEN 0
				WHEN @ShowOnly = 'T' THEN P.IsActive END) AND
	PCT.IsActive = 1  --only when core team member is active
	ORDER BY P.Code
END


UPDATE T
SET ActiveMembers = (SELECT COUNT(IdAssociate)
                     FROM PROJECT_CORE_TEAMS PCT
                     WHERE PCT.IdProject = T.ProjectId AND
 		           PCT.IsActive = 1)
FROM #TempProjects T


UPDATE T
SET TimingIntercoPercent = dbo.fnGetPercentageWpWithTimingAndInterco(T.ProjectId)
FROM #TempProjects T


UPDATE T
SET IsInitialBudgetValidated = BI.IsValidated
FROM #TempProjects T
INNER JOIN BUDGET_INITIAL BI
	ON BI.IdProject = T.ProjectId

	
	SELECT 
		[ProjectId]		AS 'ProjectId',
		[ProjectName]		AS 'ProjectName',
		ProgramName		AS 'ProgramName',
		ProjectFunction		AS 'ProjectFunction',
		ProgramId		AS 'ProgramId',
		ProjectFunctionId	AS 'ProjectFunctionId',
		ProjectFunctionWPCodeSuffix AS 'ProjectFunctionWPCodeSuffix',
		OwnerId			AS 'OwnerId',
		ProgramCode		AS 'ProgramCode',
		ProjectCode		AS 'ProjectCode',
		ActiveMembers		AS 'ActiveMembers',
		TimingIntercoPercent	AS 'TimingIntercoPercent',
		IsInitialBudgetValidated AS 'IsInitialBudgetValidated'	 
	FROM #TempProjects
	ORDER BY
		CASE WHEN @OrderBy = 'C' THEN ProjectCode END,
		CASE WHEN @OrderBy = 'N' THEN ProjectName END

END

GO


