IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnCheckCostCenterExistenceInAllCategories]'))
	DROP FUNCTION fnCheckCostCenterExistenceInAllCategories
GO
CREATE FUNCTION fnCheckCostCenterExistenceInAllCategories
(
	@IdCostCenter INT
)
RETURNS INT
AS
BEGIN
	IF @IdCostCenter IS NULL
		RETURN 0

	IF EXISTS(
			SELECT TOP 1 BID.IdProject
			FROM BUDGET_INITIAL_DETAIL BID
			WHERE BID.IdCostCenter = @IdCostCenter
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 BRD.IdProject
			FROM BUDGET_REVISED_DETAIL BRD
			WHERE BRD.IdCostCenter = @IdCostCenter
		  )
		RETURN 1


	IF EXISTS(
			SELECT TOP 1 BCD.IdProject
			FROM BUDGET_TOCOMPLETION_DETAIL BCD
			WHERE BCD.IdCostCenter = @IdCostCenter
		  )
		RETURN 1
	
	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ACTUAL_DATA_DETAILS_HOURS AD
			WHERE AD.IdCostCenter = @IdCostCenter
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ACTUAL_DATA_DETAILS_SALES AD
			WHERE AD.IdCostCenter = @IdCostCenter
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ACTUAL_DATA_DETAILS_COSTS AD
			WHERE AD.IdCostCenter = @IdCostCenter
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ANNUAL_BUDGET_DATA_DETAILS_HOURS AD
			WHERE AD.IdCostCenter = @IdCostCenter
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ANNUAL_BUDGET_DATA_DETAILS_SALES AD
			WHERE AD.IdCostCenter = @IdCostCenter
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ANNUAL_BUDGET_DATA_DETAILS_COSTS AD
			WHERE AD.IdCostCenter = @IdCostCenter
		  )
		RETURN 1

	RETURN 0
	
END
GO

