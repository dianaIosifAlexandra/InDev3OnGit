--Drops the Procedure fltProjectSelectorPrograms if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fltProjectSelectorPrograms]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE fltProjectSelectorPrograms
GO

-- EXEC fltProjectSelectorPrograms 78,-1,-1,'A'

CREATE PROCEDURE fltProjectSelectorPrograms
	@IdAssociate		AS INT,		--The Id of the Associate
	@IdOwner		AS INT,		--The Id of the Owner
	@IdProgram		AS INT,		--The Id of the Program
	@ShowOnly		AS CHAR(1) 	--The option to filter projects after their state
AS
BEGIN

	DECLARE @IsBAOrTA BIT,
		@IsFM BIT,
		@IsKeyUser bit	
	
	--the Role of BA or TA has special access rights - they may see all the projects
	SET @IsBAOrTA = dbo.fnIsBAOrTA(@IdAssociate)
	SET @IsFM = dbo.fnIsFunctionalManager(@IdAssociate)
	set @IsKeyUser = dbo.fnIsKeyUser(@IdAssociate)
	
	IF @IsBAOrTA = 1 OR @IsFM = 1 or @IsKeyUser = 1
	BEGIN
		SELECT 	[Id] AS ProgramId,
			[Name] + ' [' + Code + ']'AS [Name],
			IdOwner as OwnerId, PRG.Rank, -1 as ProjectId
		FROM	PROGRAMS PRG(nolock)
		WHERE	PRG.IdOwner = CASE WHEN @IdOwner = -1 THEN PRG.IdOwner ELSE @IdOwner END AND
			PRG.Id = CASE WHEN @IdProgram = -1 THEN PRG.Id ELSE @IdProgram END
		ORDER BY PRG.Rank

		RETURN
	END
	ELSE
	BEGIN
		CREATE TABLE #TempProjects
		(
			IdProject		INT,
			ProjectName		VARCHAR(80),
			ProgramName 		VARCHAR(80),
			ProjectFunction 	VARCHAR(50),
			ProgramId 		INT,
			ProjectFunctionId 	INT,
			ProjectFunctionWPCodeSuffix VARCHAR(29),
			OwnerId 		INT,
			ProgramCode		VARCHAR(10),
			ProjectCode		VARCHAR(10),
			ActiveMembers		INT,
			TimingIntercoPercent	INT,
			IsInitialBudgetValidated BIT
		)
		
		INSERT INTO #TempProjects
		EXEC fltProjectSelectorProjects @IdOwner, @IdAssociate, -1, @ShowOnly, 'C'
		
		SELECT DISTINCT PRG.Id AS ProgramId, PRG.Name + ' [' + Code + ']' as [Name], PRG.IdOwner as OwnerId, PRG.Rank, -1 as ProjectId 
		FROM #TempProjects t
		INNER JOIN PROGRAMS PRG (NOLOCK) ON
			t.ProgramID = PRG.Id
		WHERE (PRG.Id = CASE WHEN @IdProgram = -1 THEN PRG.Id ELSE @IdProgram END)
		ORDER BY PRG.Rank
	END

END
GO