--Drops the Procedure bgtDeleteCompletionBudgetStates if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.bgtDeleteCompletionBudgetStates') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtDeleteCompletionBudgetStates
GO

CREATE PROCEDURE bgtDeleteCompletionBudgetStates
	@IdProject 		INT,
	@BudVersion		CHAR(1),
	@IdAssociate	INT
AS
BEGIN
	declare @retVal int	

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
	IF (@BudVersion IS NULL )
	BEGIN 
		RAISERROR('No budget version has been selected',16,1)		
		RETURN -3
	END 

	DECLARE @IdGeneration INT
	SELECT  @IdGeneration = dbo.fnGetToCompletionBudgetGeneration(@IdProject,@BudVersion)	
	
	DECLARE @IsValidated BIT,
			@IsPMProject BIT,	
			@IsBAOrTA BIT
	
	
	SELECT @IsValidated = IsValidated 
	FROM BUDGET_TOCOMPLETION 
	WHERE IdProject = @IdProject AND
	      IdGeneration = @IdGeneration
	
	SELECT @IsBAOrTA = dbo.fnCheckAssociateIsBaOrTa(@IdAssociate)
	SELECT @IsPMProject = dbo.fnCheckAssociateIsPM(@IdAssociate,@IdProject)
	
	IF((@IsBAOrTA=1 OR @IsPMProject=1) AND @IsValidated=0)
	BEGIN
		--1. delete all the data for the current associate	
		DELETE FROM BUDGET_TOCOMPLETION_DETAIL_COSTS	
		WHERE IdProject = @IdProject AND
		      IdGeneration = @IdGeneration AND
		      IdAssociate = @IdAssociate
	
	
		DELETE FROM BUDGET_TOCOMPLETION_DETAIL	
		WHERE IdProject = @IdProject AND
			  IdAssociate = @IdAssociate AND
			  IdGeneration = @IdGeneration
	
	
		DELETE FROM BUDGET_TOCOMPLETION_PROGRESS	
		WHERE IdProject = @IdProject AND
		      IdGeneration = @IdGeneration AND
		      IdAssociate = @IdAssociate

		DELETE FROM BUDGET_TOCOMPLETION_STATES	
		WHERE IdProject = @IdProject AND
		      IdGeneration = @IdGeneration AND
		      IdAssociate = @IdAssociate

		--2. recreate his data from the previous version
		EXEC @retVal = bgtToCompletionBudgetCreateNewFromCurrent @IdProject, @IdGeneration, @IdAssociate
		IF (@@ERROR <> 0 OR @retVal < 0)
		BEGIN
			raiserror ('There was error re-creating the budget for one active associate.',16,1)
			RETURN -4
		END
	END
	ELSE
	BEGIN
		RAISERROR('Either you do not have rights for this operations or the budget state does not permit it!',16,1)		
		RETURN -5
	END

END
GO






