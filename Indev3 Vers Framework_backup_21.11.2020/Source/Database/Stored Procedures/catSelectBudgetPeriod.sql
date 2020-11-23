--Drops the Procedure catSelectBudgetPeriod if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectBudgetPeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectBudgetPeriod
GO
CREATE PROCEDURE catSelectBudgetPeriod
	@Id AS INT 	--The Id of the selected Budget Period
AS
	--If @Id has the value -1, it will return all Budget Periods
	IF (@Id = -1)
	BEGIN 
		SELECT 	
			BP.Code		AS 'Code',
			BP.Id		AS 'Id',
			BP.Name		AS 'Name'
		FROM BUDGET_PERIODS AS BP(nolock)
		
		RETURN
	END

	--If @Id doesn't have the value -1 it will return the selected Budget Period
	SELECT 	BP.Id		AS 'Id',
		BP.Code 	AS 'Code',
		BP.Name		AS 'Name'
	FROM BUDGET_PERIODS AS BP(nolock)
	WHERE BP.Id = @Id
GO

