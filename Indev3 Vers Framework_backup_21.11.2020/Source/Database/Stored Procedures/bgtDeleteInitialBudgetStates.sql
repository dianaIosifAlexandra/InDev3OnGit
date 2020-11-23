--Drops the Procedure bgtDeleteInitialBudgetStates if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtDeleteInitialBudgetStates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtDeleteInitialBudgetStates
GO

CREATE PROCEDURE bgtDeleteInitialBudgetStates
	@IdProject 		INT, 	-- The Id of the Project
	@IdAssociate 	INT     -- The Id of Associate
	
AS
BEGIN
	IF (@IdProject < 0 )
		BEGIN 
			RAISERROR('No project has been selected',16,1)		
			RETURN -1
		END 
	
	IF (@IdAssociate < 0 )
		BEGIN 
			RAISERROR('No associate has been selected',16,1)		
			RETURN -2
		END 
	
	DECLARE @IsValidated BIT,
		@IsPMProject BIT,	
		@IsBAOrTA BIT
	
	
	SELECT @IsValidated = IsValidated 
	FROM BUDGET_INITIAL 
	WHERE IdProject = @IdProject
	
	SELECT @IsBAOrTA = dbo.fnCheckAssociateIsBaOrTa(@IdAssociate)
	SELECT @IsPMProject = dbo.fnCheckAssociateIsPM(@IdAssociate,@IdProject)
	
	IF((@IsBAOrTA=1 OR @IsPMProject=1) AND @IsValidated=0)
	BEGIN
	
		DELETE FROM BUDGET_INITIAL_DETAIL_COSTS
		WHERE IdProject = @IdProject AND
			IdAssociate = @IdAssociate
		
		DELETE FROM BUDGET_INITIAL_DETAIL
		WHERE IdProject = @IdProject AND
			IdAssociate = @IdAssociate
	
		UPDATE BUDGET_INITIAL_STATES
		SET State = 'N',
			StateDate = GetDate()
		WHERE IdProject = @IdProject AND
			IdAssociate = @IdAssociate
	END
	ELSE
	BEGIN
		RAISERROR('Either you do not have rights for this operations or the budget state does not permit it!',16,1)		
		RETURN -3
	END

END
GO




