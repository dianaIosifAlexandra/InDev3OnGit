--Drops the Procedure bgtInsertProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtInsertProjectCoreTeam]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtInsertProjectCoreTeam
GO
CREATE PROCEDURE bgtInsertProjectCoreTeam
	@IdProject		INT,		--The Id of the Project that is connected to the Project Core Team you want to insert
	@IdAssociate		INT,		--The Id of the Associate that is connected to the Project Core Team you want to insert
	@IdFunction		INT,		--The Id of the Function that is connected to the Project Core Team you want to insert
	@IsActive		BIT
AS
DECLARE @ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(40)
	

	IF EXISTS(SELECT *
			  FROM PROJECT_CORE_TEAMS PCT(TABLOCKX)
			  WHERE	PCT.IdAssociate	= @IdAssociate AND 
					PCT.IdProject = @IdProject) 
	BEGIN
		SET @ErrorMessage = 'The associate you want to add is already defined in the core team.'
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@IdProject IS NULL OR 
	   @IdAssociate IS NULL OR 
	   @IdFunction IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	INSERT INTO PROJECT_CORE_TEAMS 	( IdProject, IdAssociate, IdFunction,IsActive,LastUpdate)
	VALUES		       		(@IdProject,@IdAssociate,@IdFunction,@IsActive,GETDATE())
	

GO



