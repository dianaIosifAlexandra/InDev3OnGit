--Drops the Procedure bgtValidateCompletionBudget if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtValidateCompletionBudget]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtValidateCompletionBudget
GO

-- bgtValidateCompletionBudget 18,'N'
CREATE PROCEDURE bgtValidateCompletionBudget
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
	SELECT  @IdGeneration = dbo.fnGetToCompletionBudgetGeneration(@IdProject,@BudVersion)

	--check to see if the budget is not already validated
	SELECT @IsValidated = IsValidated 
	FROM BUDGET_TOCOMPLETION (tablockx)
	WHERE IdProject = @IdProject and 
	      IdGeneration = @IdGeneration 

	IF (@IsValidated = 1)
	BEGIN 
		RAISERROR('To Completion budget is already validated.',16,1)		
		RETURN -3
	END 
	

	--Delete the data of the core team members that have worked on the budget but are now inactive (so
	--that their data won't be propagated into the Released version)
	DELETE BCDC 
	FROM BUDGET_TOCOMPLETION_DETAIL_COSTS BCDC
	INNER JOIN PROJECT_CORE_TEAMS PCT 
		ON	BCDC.IdProject = PCT.IdProject AND
			BCDC.IdAssociate = PCT.IdAssociate
	WHERE 	BCDC.IdProject = @IdProject AND
			BCDC.IdGeneration = @IdGeneration AND
			PCT.IsActive = 0

	DELETE BCD 
	FROM BUDGET_TOCOMPLETION_DETAIL BCD
	INNER JOIN PROJECT_CORE_TEAMS PCT 
		ON	BCD.IdProject = PCT.IdProject AND
			BCD.IdAssociate = PCT.IdAssociate
	WHERE 	BCD.IdProject = @IdProject AND
			BCD.IdGeneration = @IdGeneration AND
			PCT.IsActive = 0

	DELETE BCP 
	FROM BUDGET_TOCOMPLETION_PROGRESS BCP
	INNER JOIN PROJECT_CORE_TEAMS PCT 
		ON	BCP.IdProject = PCT.IdProject AND
			BCP.IdAssociate = PCT.IdAssociate
	WHERE 	BCP.IdProject = @IdProject AND
			BCP.IdGeneration = @IdGeneration AND
			PCT.IsActive = 0

	DELETE BCS 
	FROM BUDGET_TOCOMPLETION_STATES BCS
	INNER JOIN PROJECT_CORE_TEAMS PCT 
		ON	BCS.IdProject = PCT.IdProject AND
			BCS.IdAssociate = PCT.IdAssociate
	WHERE 	BCS.IdProject = @IdProject AND
			BCS.IdGeneration = @IdGeneration AND
			PCT.IsActive = 0

	
	--read the validation date from OS
	DECLARE @ValidationDate smalldatetime
	SET @ValidationDate = GETDATE()

	--update all existing states to valid
	UPDATE BTS
	SET BTS.State = 'V',
	    BTS.StateDate = CASE WHEN ISNULL(BTS.State, 'N') = 'N' then ISNULL(BTS2.StateDate, @ValidationDate) ELSE @ValidationDate END
	FROM BUDGET_TOCOMPLETION_STATES BTS
	LEFT JOIN BUDGET_TOCOMPLETION_STATES BTS2
		on BTS.IdProject = BTS2.IdProject and
		   BTS.IdGeneration = BTS2.IdGeneration and
		   BTS.IdAssociate = BTS2.IdAssociate
	WHERE BTS.IdProject = @IdProject AND 
	      BTS.IdGeneration = @IdGeneration


	-- update the Yearmonth Actual Data column with the last actual data found in actual tables at the moment of validation.
	-- the user must see the situation of actual/tocompletion as it was at the date of validation
	DECLARE @YearMonthActualData INT
	SET @YearMonthActualData =  dbo.fnGetYearMonthOfPreviousMonth(getdate())


	UPDATE BUDGET_TOCOMPLETION
	SET YearMonthActualData = @YearMonthActualData
	WHERE IdProject = @IdProject AND 
	      IdGeneration = @IdGeneration 

	--validate the budget
	UPDATE BUDGET_TOCOMPLETION
	SET IsValidated=1, 
	    ValidationDate=@ValidationDate
	WHERE IdProject=@IdProject AND
	      IdGeneration = @IdGeneration 


GO






