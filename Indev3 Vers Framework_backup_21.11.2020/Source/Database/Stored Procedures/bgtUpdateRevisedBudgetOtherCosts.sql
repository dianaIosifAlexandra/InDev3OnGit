--Drops the Procedure bgtUpdateRevisedBudgetOtherCost if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateRevisedBudgetOtherCosts]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateRevisedBudgetOtherCosts
GO

CREATE  PROCEDURE bgtUpdateRevisedBudgetOtherCosts
	@IdProject				INT,		--The Id of project
	@IdPhase				INT,		--The Id of phase
	@IdWP					INT,		--The Id of workpackage
	@IdCostCenter			INT,		--The Id of cost center
	@IdAssociate			INT,		--The Id of associate
	@YearMonth				INT,		--Year and month
	@IdCostType				INT,
	@CostVal				DECIMAL(18,2)
AS
BEGIN

	Declare	@ErrorMessage		VARCHAR(255),
			@YMValidationResult	INT

	-- verify if the yearmonth value is valid
	Select @YMValidationResult = ValidationResult,
	       @ErrorMessage = ErrorMessage
	from fnValidateYearMonth(@YearMonth)

	if (@YMValidationResult < 0)
	begin
	 	RAISERROR(@ErrorMessage, 16, 1)
		RETURN -1
	end

	DECLARE @IdGeneration INT,
			@rowCount	  INT
	SELECT @IdGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,'N')

	IF (@IdGeneration IS NULL)
	BEGIN
		RAISERROR('No new budget version found for Revised Budget', 16, 1)
		RETURN -2
	END
		
	--update other costs
	UPDATE BUDGET_REVISED_DETAIL_COSTS
	SET CostVal = @CostVal
	WHERE IdProject = @IdProject AND
		  IdGeneration = @IdGeneration AND
		  IdPhase = @IdPhase AND
		  IdWorkPackage = @IdWP AND
		  IdCostCenter = @IdCostCenter AND
		  IdAssociate = @IdAssociate AND
		  YearMonth = @YearMonth AND
		  IdCostType = @IdCostType

	Set @rowCount = @@ROWCOUNT
	If (@rowCount = 0)
	BEGIN
		RAISERROR('Save failed. Other user may have changed data you were saving.', 16, 1)
		RETURN -3
	END
	
END
GO

