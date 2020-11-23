--Drops the Procedure bgtUpdateRevisedBudgetDetail if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateRevisedBudgetDetailForUplodRevisedBudget]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateRevisedBudgetDetailForUplodRevisedBudget
GO

create  PROCEDURE [dbo].[bgtUpdateRevisedBudgetDetailForUplodRevisedBudget]
	@IdProject			INT,		--The Id of the selected Project
	@IdPhase			INT,		--The Id of a phase from project
	@IdWP				INT,		--The Id of workpackage
	@IdCostCenter		INT,		--The Id of cost center
	@IdAssociate		INT,		--The Id of associate
	@YearMonth			INT,
	@HoursQty			INT = NULL,
	@SalesVal			DECIMAL = NULL
AS
BEGIN
	Declare	@ErrorMessage		VARCHAR(255),
			@YMValidationResult	INT

	-- verify if the yearmonth value is valid
	SELECT @YMValidationResult = ValidationResult,
	       @ErrorMessage = ErrorMessage
	FROM fnValidateYearMonth(@YearMonth)

	IF (@YMValidationResult < 0)
	BEGIN
	 	RAISERROR(@ErrorMessage, 16, 1)
		RETURN -1
	END

	DECLARE @IdGeneration INT
	SELECT @IdGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,'N')

	DECLARE @WPDuration 	INT,
			@rowCount		INT


	DECLARE	@HoursVal DECIMAL(18,4)
	SET  	@HoursVal = CASE WHEN @HoursQty IS NOT NULL THEN dbo.fnGetValuedHours(@IdCostCenter, @HoursQty, @YearMonth) ELSE NULL END

	UPDATE  BUDGET_REVISED_DETAIL
	SET 	HoursQty = ISNULL(@HoursQty, HoursQty),
			SalesVal = @SalesVal,
			HoursVal = CASE WHEN @HoursVal IS NULL THEN HoursVal ELSE @HoursVal END
	WHERE	IdProject = @IdProject AND
			IdGeneration = @IdGeneration AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP AND
			IdCostCenter = @IdCostCenter AND
			IdAssociate = @IdAssociate AND
			YearMonth = @YearMonth

	Set @rowCount = @@ROWCOUNT
	If (@rowCount = 0)
	BEGIN
		RAISERROR('Save failed. Other user may have changed data you were saving.', 16, 1)
		RETURN -2
	END


END

GO

