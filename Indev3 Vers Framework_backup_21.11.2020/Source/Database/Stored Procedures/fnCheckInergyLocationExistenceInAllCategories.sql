IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnCheckInergyLocationExistenceInAllCategories]'))
	DROP FUNCTION fnCheckInergyLocationExistenceInAllCategories
GO
CREATE FUNCTION fnCheckInergyLocationExistenceInAllCategories
(
	@IdInergyLocation INT
)
RETURNS INT
AS
BEGIN
	IF @IdInergyLocation IS NULL
		RETURN 0

	IF EXISTS(
			SELECT TOP 1 BID.IdProject
			FROM BUDGET_INITIAL_DETAIL BID
			INNER JOIN COST_CENTERS CC
				ON BID.IdCostCenter = CC.Id
			WHERE CC.IdInergyLocation = @IdInergyLocation
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 BRD.IdProject
			FROM BUDGET_REVISED_DETAIL BRD
			INNER JOIN COST_CENTERS CC
				ON BRD.IdCostCenter = CC.Id
			WHERE CC.IdInergyLocation = @IdInergyLocation
		  )
		RETURN 1


	IF EXISTS(
			SELECT TOP 1 BCD.IdProject
			FROM BUDGET_TOCOMPLETION_DETAIL BCD
			INNER JOIN COST_CENTERS CC
				ON BCD.IdCostCenter = CC.Id
			WHERE CC.IdInergyLocation = @IdInergyLocation
		  )
		RETURN 1
	
	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ACTUAL_DATA_DETAILS_HOURS AD
			INNER JOIN COST_CENTERS CC
				ON AD.IdCostCenter = CC.Id
			WHERE CC.IdInergyLocation = @IdInergyLocation
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ACTUAL_DATA_DETAILS_SALES AD
			INNER JOIN COST_CENTERS CC
				ON AD.IdCostCenter = CC.Id
			WHERE CC.IdInergyLocation = @IdInergyLocation
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ACTUAL_DATA_DETAILS_COSTS AD
			INNER JOIN COST_CENTERS CC
				ON AD.IdCostCenter = CC.Id
			WHERE CC.IdInergyLocation = @IdInergyLocation
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ANNUAL_BUDGET_DATA_DETAILS_HOURS AD
			INNER JOIN COST_CENTERS CC
				ON AD.IdCostCenter = CC.Id
			WHERE CC.IdInergyLocation = @IdInergyLocation
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ANNUAL_BUDGET_DATA_DETAILS_SALES AD
			INNER JOIN COST_CENTERS CC
				ON AD.IdCostCenter = CC.Id
			WHERE CC.IdInergyLocation = @IdInergyLocation
		  )
		RETURN 1

	IF EXISTS(
			SELECT TOP 1 AD.IdProject
			FROM ANNUAL_BUDGET_DATA_DETAILS_COSTS AD
			INNER JOIN COST_CENTERS CC
				ON AD.IdCostCenter = CC.Id
			WHERE CC.IdInergyLocation = @IdInergyLocation
		  )
		RETURN 1

RETURN 0
	
END
GO

