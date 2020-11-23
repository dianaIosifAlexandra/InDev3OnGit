--Drops the Procedure catDeleteCostCenter if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteCostCenter]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteCostCenter
GO
CREATE PROCEDURE catDeleteCostCenter
	@Id AS INT 	--The Id of the selected Cost Center
AS
DECLARE @Rowcount 	INT,
	@CountDep 	INT,
	@ChildName	VARCHAR(50),
	@MasterName	VARCHAR(50),
	@ErrorMessage	VARCHAR(255)

	SELECT 	@CountDep = HR.IdCostCenter
	FROM HOURLY_RATES AS HR
	WHERE HR.IdCostCenter = @Id
	
	SET @ChildName	= 'Cost center'
	SET @MasterName = 'Hourly Rate'
	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	DECLARE @CCName VARCHAR(30)

	IF 
	(
		EXISTS
		(
			SELECT 	IdCostCenter 
			FROM	BUDGET_INITIAL_DETAIL
			WHERE	IdCostCenter = @Id
		)
		OR EXISTS
		(
			SELECT 	IdCostCenter 
			FROM	BUDGET_REVISED_DETAIL
			WHERE	IdCostCenter = @Id
		)
		OR EXISTS
		(
			SELECT 	IdCostCenter 
			FROM	BUDGET_TOCOMPLETION_DETAIL
			WHERE	IdCostCenter = @Id
		)
	)
	BEGIN
		SELECT 	@CCName = [Name]
		FROM	COST_CENTERS
		WHERE 	[Id] = @Id
		RAISERROR('Cost Center %s is used in budget data.', 16, 1, @CCName)
		RETURN -2
	END

	IF 
	(
		EXISTS
		(
			SELECT 	IdCostCenter 
			FROM	ACTUAL_DATA_DETAILS_HOURS
			WHERE	IdCostCenter = @Id
		)
		OR EXISTS
		(
			SELECT 	IdCostCenter 
			FROM	ACTUAL_DATA_DETAILS_SALES
			WHERE	IdCostCenter = @Id
		)
		OR EXISTS
		(
			SELECT 	IdCostCenter 
			FROM	ACTUAL_DATA_DETAILS_COSTS
			WHERE	IdCostCenter = @Id
		)
	)
	BEGIN
		SELECT 	@CCName = [Name]
		FROM	COST_CENTERS
		WHERE 	[Id] = @Id
		RAISERROR('Cost Center %s is used in actual data.', 16, 1, @CCName)
		RETURN -3
	END

	IF 
	(
		EXISTS
		(
			SELECT 	IdCostCenter 
			FROM	ANNUAL_BUDGET_DATA_DETAILS_HOURS
			WHERE	IdCostCenter = @Id
		)
		OR EXISTS
		(
			SELECT 	IdCostCenter 
			FROM	ANNUAL_BUDGET_DATA_DETAILS_SALES
			WHERE	IdCostCenter = @Id
		)
		OR EXISTS
		(
			SELECT 	IdCostCenter 
			FROM	ANNUAL_BUDGET_DATA_DETAILS_COSTS
			WHERE	IdCostCenter = @Id
		)
	)
	BEGIN
		SELECT 	@CCName = [Name]
		FROM	COST_CENTERS
		WHERE 	[Id] = @Id
		RAISERROR('Cost Center %s is used in annual budget data.', 16, 1, @CCName)
		RETURN -3
	END

	DELETE FROM COST_CENTERS
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

