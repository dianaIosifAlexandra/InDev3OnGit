IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnGetBudgetCostType]'))
	DROP FUNCTION fnGetBudgetCostType
GO

CREATE FUNCTION fnGetBudgetCostType
(
	@IdCountry int,
	@AccountNumber nvarchar(10)
)
RETURNS INT
AS
BEGIN
	DECLARE @Return INT,
		@CostTypeID INT

	SELECT @CostTypeID = GL.IdCostType 
	FROM GL_ACCOUNTS GL 
	WHERE IdCountry = @IdCountry AND
	      GL.Account = @AccountNumber

	return @CostTypeID
	--PRINT @return
	
END
GO

