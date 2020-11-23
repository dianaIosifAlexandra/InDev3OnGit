--Drops the Procedure bgtValidateRevisedBudget if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.bgtValidateRevisedBudget') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtValidateRevisedBudget
GO

-- bgtValidateRevisedBudget 18,'N'
CREATE PROCEDURE bgtValidateRevisedBudget
	@IdProject 		AS INT,
	@BudVersion		AS CHAR(1)
				
AS

	IF (@IdProject < 0 )
	BEGIN 
		RAISERROR('No project has been selected',16,1)		
		RETURN -1
	END 
	IF (@BudVersion IS NULL )
	BEGIN 
		RAISERROR('No budget version has been selected',16,1)		
		RETURN -2
	END	


	DECLARE @IdGeneration INT,
		@IsValidated  BIT

	SELECT  @IdGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,@BudVersion)

	--check to see if the budget is not already validated
	SELECT @IsValidated = IsValidated 
	FROM BUDGET_REVISED (tablockx)
	WHERE IdProject = @IdProject and 
	      IdGeneration = @IdGeneration 

	IF (@IsValidated = 1)
	BEGIN 
		RAISERROR('Revised budget is already validated.',16,1)		
		RETURN -3
	END 
	
	--Delete the data of the core team members that have worked on the budget but are now inactive (so
	--that their data won't be propagated into the Released version)
	DELETE BRDC 
	FROM BUDGET_REVISED_DETAIL_COSTS BRDC
	INNER JOIN PROJECT_CORE_TEAMS PCT 
		ON	BRDC.IdProject = PCT.IdProject AND
			BRDC.IdAssociate = PCT.IdAssociate
	WHERE 	BRDC.IdProject = @IdProject AND
			BRDC.IdGeneration = @IdGeneration AND
			PCT.IsActive = 0

	DELETE BRD 
	FROM BUDGET_REVISED_DETAIL BRD
	INNER JOIN PROJECT_CORE_TEAMS PCT 
		ON  BRD.IdProject = PCT.IdProject AND
			BRD.IdAssociate = PCT.IdAssociate
	WHERE 	BRD.IdProject = @IdProject AND
			BRD.IdGeneration = @IdGeneration AND
			PCT.IsActive = 0

	DELETE BRS 
	FROM BUDGET_REVISED_STATES BRS
	INNER JOIN PROJECT_CORE_TEAMS PCT 
		ON	BRS.IdProject = PCT.IdProject AND
			BRS.IdAssociate = PCT.IdAssociate
	WHERE 	BRS.IdProject = @IdProject AND
			BRS.IdGeneration = @IdGeneration AND
			PCT.IsActive = 0

	DECLARE @ValidationDate smalldatetime
	SET @ValidationDate = GETDATE()

	--update all existing states to valid
	UPDATE BRS
	SET BRS.State = 'V',
	    BRS.StateDate = CASE WHEN ISNULL(BRS.State, 'N') = 'N' then ISNULL(BRS2.StateDate, @ValidationDate) ELSE @ValidationDate END
	FROM BUDGET_REVISED_STATES BRS
	LEFT JOIN BUDGET_REVISED_STATES BRS2
		on BRS.IdProject = BRS2.IdProject and
		   BRS.IdGeneration = BRS2.IdGeneration and
		   BRS.IdAssociate = BRS2.IdAssociate
	WHERE BRS.IdProject = @IdProject AND 
	      BRS.IdGeneration = @IdGeneration


	--make the budget valid
	UPDATE BUDGET_REVISED
	SET IsValidated=1, 
		ValidationDate=@ValidationDate
	WHERE IdProject=@IdProject AND 
		  IdGeneration = @IdGeneration 


GO






