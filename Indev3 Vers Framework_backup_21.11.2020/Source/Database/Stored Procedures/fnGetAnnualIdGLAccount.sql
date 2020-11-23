--Drops the Function fnGetAnnualIdGLAccount if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetAnnualIdGLAccount]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetAnnualIdGLAccount]
GO


CREATE   FUNCTION fnGetAnnualIdGLAccount
(
	@AccountNumber VARCHAR(20),
	@CountryCode VARCHAR(3)
)	
RETURNS INT

AS
BEGIN
	DECLARE @IdAccount INT,		
		@IdCountry	INT


	
	SELECT @IdCountry = Id
	FROM COUNTRIES
	WHERE Code = @CountryCode
	
	SELECT @IdAccount = ID
	FROM GL_ACCOUNTS
	WHERE IdCountry = @IdCountry AND
	Account = @AccountNumber


RETURN @IdAccount
END

GO

