--Drops the Procedure bgtDeleteProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtDeleteProjectCoreTeam]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtDeleteProjectCoreTeam
GO
CREATE PROCEDURE bgtDeleteProjectCoreTeam
	@IdProject 	AS INT, 	--The IdProject of the selected Project Core Team
	@IdAssociate	AS INT,		--The IdAssociate of the selected Project Core Team
	@IdFunction	AS INT		--The @IdFunction of the selected Project Core Team
AS
declare @rowcount int
--validate the FKs
	if 
	exists  (SELECT TOP 1 IdAssociate
		FROM BUDGET_INITIAL_DETAIL 
		WHERE	IdAssociate = @IdAssociate AND
			IdProject = @IdProject)
		OR
	exists	(SELECT TOP 1 IdAssociate
		FROM BUDGET_INITIAL_DETAIL_COSTS 
		WHERE	IdAssociate = @IdAssociate AND
			IdProject = @IdProject)
		OR
	exists	(SELECT TOP 1 IdAssociate
		FROM BUDGET_INITIAL_STATES 
		WHERE	IdAssociate = @IdAssociate AND
			IdProject = @IdProject)
	BEGIN
		RAISERROR('The core team member can not be deleted because he/she has information defined in the Initial Budget',16,1)	
		RETURN
	END



	if 
	exists  (SELECT TOP 1 IdAssociate
		FROM BUDGET_REVISED_DETAIL 
		WHERE	IdAssociate = @IdAssociate AND
			IdProject = @IdProject)
		OR
	exists	(SELECT TOP 1 IdAssociate
		FROM BUDGET_REVISED_DETAIL_COSTS 
		WHERE	IdAssociate = @IdAssociate AND
			IdProject = @IdProject)
		OR
	exists	(SELECT TOP 1 IdAssociate
		FROM BUDGET_REVISED_STATES 
		WHERE	IdAssociate = @IdAssociate AND
			IdProject = @IdProject)
	BEGIN
		RAISERROR('The core team member can not be deleted because he/she has information defined in the Revised Budget',16,1)
		RETURN
	END



	if 
	exists  (SELECT TOP 1 IdAssociate
		FROM BUDGET_TOCOMPLETION_DETAIL 
		WHERE	IdAssociate = @IdAssociate AND
			IdProject = @IdProject)
		OR
	exists	(SELECT TOP 1 IdAssociate
		FROM BUDGET_TOCOMPLETION_DETAIL_COSTS 
		WHERE	IdAssociate = @IdAssociate AND
			IdProject = @IdProject)
		OR
	exists	(SELECT TOP 1 IdAssociate
		FROM BUDGET_TOCOMPLETION_STATES 
		WHERE	IdAssociate = @IdAssociate AND
			IdProject = @IdProject)
		OR
	exists	(SELECT TOP 1 IdAssociate
		FROM BUDGET_TOCOMPLETION_PROGRESS 
		WHERE	IdAssociate = @IdAssociate AND
			IdProject = @IdProject)
	BEGIN
		RAISERROR('The core team member can not be deleted because he/she has information defined in the Reforecast',16,1)
		RETURN
	END
--end validation section

	DELETE FROM PROJECT_CORE_TEAMS
	WHERE 	IdProject = @IdProject AND
		IdAssociate = @IdAssociate AND 
		IdFunction = @IdFunction

	SET @rowcount = @@ROWCOUNT
	RETURN @rowcount
GO
