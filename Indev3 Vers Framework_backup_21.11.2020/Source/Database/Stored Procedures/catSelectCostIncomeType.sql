--Drops the Procedure catSelectCostIncomeType if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectCostIncomeType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectCostIncomeType
GO
CREATE PROCEDURE catSelectCostIncomeType
	@Id AS INT 	--The Id of the selected Cost Income Type
AS
	--If @Id has the value -1, it will return all Cost Income Types
	IF (@Id = -1)
	BEGIN 
		SELECT 	
			CIT.Name	AS 'Name',
			CIT.Id		AS 'Id',
			CIT.DefaultAccount AS 'DefaultAccount'
		FROM COST_INCOME_TYPES CIT(nolock)
		ORDER BY Rank
		RETURN
	END

	--If @Id doesn't have the value -1 it will return the selected Cost Income Type
	SELECT 	CIT.Id		AS 'Id',
		CIT.Name	AS 'Name',
		CIT.DefaultAccount AS 'DefaultAccount'
	FROM COST_INCOME_TYPES CIT(nolock)
	WHERE CIT.Id = @Id
GO

