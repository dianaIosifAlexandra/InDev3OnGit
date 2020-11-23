--Drops the Procedure bgtUpdateInitialBudgetDetail if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateInitialBudgetDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateInitialBudgetDetail
GO

CREATE  PROCEDURE bgtUpdateInitialBudgetDetail
	@IdProject	INT,		--The Id of the selected Project
	@IdPhase	INT,		--The Id of a phase from project
	@IdWP		INT,		--The Id of workpackage
	@IdCostCenter	INT,		--The Id of cost center
	@IdAssociate	INT,		--The Id of associate
	@YearMonth	INT,
	@HoursQty	INT,
	@HoursVal	DECIMAL(18,4),
	@SalesVal	DECIMAL(18,4)	
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
	
	--If the value of @HoursVal is not null (has been inserted by the user in the application, store it in the db)
	IF (@HoursVal IS NOT NULL)
	BEGIN
		UPDATE  BUDGET_INITIAL_DETAIL
		SET 
			HoursQty = @HoursQty, 
			HoursVal = @HoursVal,
			SalesVal = @SalesVal
		WHERE
		IdProject = @IdProject AND
		IdPhase = @IdPhase AND
		IdWorkPackage = @IdWP AND
		IdCostCenter = @IdCostCenter AND
		IdAssociate = @IdAssociate AND
		YearMonth = @YearMonth
	END
	ELSE
	BEGIN
		DECLARE @NewHoursVal DECIMAL(18,4)
		SET @NewHoursVal = dbo.fnGetValuedHours(@IdCostCenter, @HoursQty, @YearMonth)
		
		UPDATE  BUDGET_INITIAL_DETAIL
		SET 
			HoursQty = @HoursQty, 
			HoursVal = @NewHoursVal,
			SalesVal = @SalesVal
		WHERE	IdProject = @IdProject AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP AND
			IdCostCenter = @IdCostCenter AND
			IdAssociate = @IdAssociate AND
			YearMonth = @YearMonth
	END
END
GO

