--Drops the Function fnGetAnnualDefaultGLAccount if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetAnnualDefaultGLAccount]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetAnnualDefaultGLAccount]
GO


CREATE   FUNCTION fnGetAnnualDefaultGLAccount
(
	@AccountNumber VARCHAR(20)
)	
RETURNS INT

AS
BEGIN
	DECLARE @DefaultAccount varchar(20)
		
	SELECT @DefaultAccount = DefaultAccount
	FROM COST_INCOME_TYPES
	WHERE Name = @AccountNumber	


RETURN @DefaultAccount
END

GO

