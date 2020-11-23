--Drops the Procedure bgtCopyProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtCopyProjectCoreTeam]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtCopyProjectCoreTeam
GO

CREATE  PROCEDURE bgtCopyProjectCoreTeam
	@IdProject		INT,
	@IdTargetProject	INT
AS


DECLARE @IdAssociate	INT,
	@IdFunction	INT,
	@IsActive	BIT,
	@retVal		INT

-- Delete old team members from target project
DECLARE DeleteOldCoreTeamCursor CURSOR FAST_FORWARD FOR
SELECT
	IdAssociate,
	IdFunction
FROM PROJECT_CORE_TEAMS
WHERE IdProject = @IdTargetProject

OPEN DeleteOldCoreTeamCursor

FETCH NEXT FROM DeleteOldCoreTeamCursor INTO @IdAssociate, @IdFunction
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC @retVal = bgtDeleteProjectCoreTeam @IdTargetProject, @IdAssociate, @IdFunction
	IF (@@ERROR <> 0 OR @retVal < 0)
		BEGIN
			RETURN -2
		END	

	FETCH NEXT FROM DeleteOldCoreTeamCursor INTO @IdAssociate, @IdFunction
END

CLOSE DeleteOldCoreTeamCursor
DEALLOCATE DeleteOldCoreTeamCursor


-- Insert new core team members
DECLARE InsertCoreTeamCursor CURSOR FAST_FORWARD FOR
SELECT
	IdAssociate,
	IdFunction,
	IsActive
FROM PROJECT_CORE_TEAMS
WHERE IdProject = @IdProject

OPEN InsertCoreTeamCursor

FETCH NEXT FROM InsertCoreTeamCursor INTO @IdAssociate, @IdFunction, @IsActive
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC @retVal = bgtInsertProjectCoreTeam @IdTargetProject, @IdAssociate, @IdFunction, @IsActive
	IF (@@ERROR <> 0 OR @retVal < 0)
		BEGIN
			RETURN -3
		END	

	FETCH NEXT FROM InsertCoreTeamCursor INTO @IdAssociate, @IdFunction, @IsActive
END

CLOSE InsertCoreTeamCursor
DEALLOCATE InsertCoreTeamCursor

GO

