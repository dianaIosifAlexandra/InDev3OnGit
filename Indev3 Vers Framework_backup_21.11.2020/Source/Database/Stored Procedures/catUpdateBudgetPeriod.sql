--Drops the Procedure catUpdateBudgetPeriod if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateBudgetPeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateBudgetPeriod
GO
CREATE PROCEDURE catUpdateBudgetPeriod
	@Id		INT,		--The Id of the selected Budget Period
 	@Code		VARCHAR(3),	--The Code of the Budget Period you want to Update
	@Name		VARCHAR(50)	--The Name of the Budget Period you want to Update
	
AS
DECLARE @IdUpdate		INT,
	@Rowcount 	INT

	SELECT @IdUpdate = BP.[Id]
	FROM BUDGET_PERIODS AS BP(HOLDLOCK)
	WHERE BP.[Id] = @Id

	IF(@IdUpdate = NULL)
	BEGIN
		RAISERROR('The selected Id of the Budget Period does not exists in the BUDGET_PERIODS table',16,1)
	END

	UPDATE BUDGET_PERIODS 	
	SET Code = @Code,
	    [Name] = @Name
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

