--Drops the Procedure fltProjectSelectorOwners if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fltProjectSelectorOwners]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE fltProjectSelectorOwners
GO

-- EXEC fltProjectSelectorOwners 78,-1,'A'

CREATE PROCEDURE fltProjectSelectorOwners
	@IdAssociate		AS INT,		--The Id of the Associate
	@IdOwner		AS INT,		--The Id of the Owner
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
		SELECT O.Id as OwnerId, O.Name as [Name], O.Rank
		FROM OWNERS O
		WHERE (O.Id = CASE WHEN @IdOwner = -1 THEN O.Id ELSE @IdOwner END)
		ORDER BY O.Rank

		RETURN
	END
	ELSE
	BEGIN
		CREATE TABLE #TempProjects
		(
			ProjectId		INT,
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
		EXEC dbo.fltProjectSelectorProjects @IdOwner, @IdAssociate, -1, @ShowOnly, 'C'
		
		SELECT DISTINCT O.Id as OwnerId, O.Name as [Name], O.Rank
		FROM #TempProjects t
		INNER JOIN OWNERS O (NOLOCK) ON
			t.OwnerID = O.Id
		WHERE (O.Id = CASE WHEN @IdOwner = -1 THEN O.Id ELSE @IdOwner END)
		ORDER BY O.Rank
	END

END

GO
