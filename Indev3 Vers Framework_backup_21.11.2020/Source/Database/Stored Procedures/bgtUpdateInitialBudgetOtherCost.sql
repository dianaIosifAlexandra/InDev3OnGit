--Drops the Procedure bgtUpdateInitialBudgetOtherCost if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateInitialBudgetOtherCost]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateInitialBudgetOtherCost
GO

CREATE  PROCEDURE bgtUpdateInitialBudgetOtherCost
	@IdProject		INT,
	@IdPhase		INT,
	@IdWP			INT,
	@IdCostCenter		INT,
	@IdAssociate		INT,
	@YearMonth		INT,
	@IdCostType		INT,		--The Id of other cost type
	@CostVal		DECIMAL(18,4) = NULL	--The other cost value
	
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


	--update other costs
	UPDATE BUDGET_INITIAL_DETAIL_COSTS
		SET CostVal = @CostVal
		WHERE IdProject = @IDProject
		AND IdPhase = @IdPhase
		AND IdWorkPackage = @IdWP
		AND IdCostCenter = @IdCostCenter
		AND IdAssociate = @IdAssociate
		AND YearMonth = @YearMonth
		AND IdCostType = @IdCostType

END
GO

