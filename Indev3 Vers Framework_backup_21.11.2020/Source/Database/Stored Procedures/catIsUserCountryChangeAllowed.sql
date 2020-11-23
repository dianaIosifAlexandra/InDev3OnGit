--Drops the Procedure catIsUserCountryChangeAllowed if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catIsUserCountryChangeAllowed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catIsUserCountryChangeAllowed
GO
CREATE PROCEDURE catIsUserCountryChangeAllowed
	@IdAssociate	INT		--The Id of the associate
AS
BEGIN
	--Check actual data
	IF 
	(
		EXISTS
		(
			SELECT	IdAssociate
			FROM	ACTUAL_DATA_DETAILS_COSTS
			WHERE	IdAssociate = @IdAssociate	
		)
		OR
		EXISTS
		(
			SELECT	IdAssociate
			FROM	ACTUAL_DATA_DETAILS_HOURS
			WHERE	IdAssociate = @IdAssociate	
		)
		OR
		EXISTS
		(
			SELECT	IdAssociate
			FROM	ACTUAL_DATA_DETAILS_SALES
			WHERE	IdAssociate = @IdAssociate	
		)
	)
	BEGIN
		RAISERROR('Country cannot be changed when actual data exists for associate.', 16, 1)
		RETURN -1
	END

	--Check initial budget
	IF EXISTS
	(
		SELECT	IdAssociate
		FROM	BUDGET_INITIAL_STATES
		WHERE	IdAssociate = @IdAssociate	
	)
	BEGIN
		RAISERROR('Country cannot be changed when initial budget data exists for associate.', 16, 1)
		RETURN -2
	END

	--Check revised budget
	IF EXISTS
	(
		SELECT	IdAssociate
		FROM	BUDGET_REVISED_STATES
		WHERE	IdAssociate = @IdAssociate	
	)
	BEGIN
		RAISERROR('Country cannot be changed when revised budget data exists for associate.', 16, 1)
		RETURN -3
	END

	--Check budget to completion
	IF EXISTS
	(
		SELECT	IdAssociate
		FROM	BUDGET_TOCOMPLETION_STATES
		WHERE	IdAssociate = @IdAssociate	
	)
	BEGIN
		RAISERROR('Country cannot be changed when budget to completion data exists for associate.', 16, 1)
		RETURN -4
	END
END
GO

