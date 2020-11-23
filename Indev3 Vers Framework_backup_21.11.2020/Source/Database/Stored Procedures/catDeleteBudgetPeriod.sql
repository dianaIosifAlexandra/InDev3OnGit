--Drops the Procedure catDeleteBudgetPeriod if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteBudgetPeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteBudgetPeriod
GO
CREATE PROCEDURE catDeleteBudgetPeriod
	@Id AS INT 	--The Id of the selected Budget Period
AS
DECLARE @RowCount INT

	DELETE FROM BUDGET_PERIODS
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

