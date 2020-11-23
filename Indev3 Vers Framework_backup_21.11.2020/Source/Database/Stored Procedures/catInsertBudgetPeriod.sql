--Drops the Procedure catInsertBudgetPeriod if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertBudgetPeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertBudgetPeriod
GO
CREATE PROCEDURE catInsertBudgetPeriod
	@Code	VARCHAR(1),	--The Code of the Budget Period you want to Insert
	@Name	VARCHAR(50)	--The Name of the Budget Period you want to Insert
	
AS
DECLARE @Id	INT

	SELECT @Id = ISNULL(MAX(C.[Id]), 0) + 1
	FROM BUDGET_PERIODS AS C (TABLOCKX)
	
	INSERT INTO BUDGET_PERIODS ([Id],Code,[Name])
	VALUES		      	   (@Id,@Code,@Name)
	
	RETURN @Id
GO

