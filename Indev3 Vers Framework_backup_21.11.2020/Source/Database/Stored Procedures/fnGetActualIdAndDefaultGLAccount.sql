--Drops the Function fnGetActualIdAndDefaultGLAccount if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetActualIdAndDefaultGLAccount]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetActualIdAndDefaultGLAccount]
GO


CREATE   FUNCTION fnGetActualIdAndDefaultGLAccount
(
	@AccountNumber VARCHAR(20),
	@IdImport INT
)	
RETURNS @tablevalues TABLE (IdAccount int, DefaultAccount varchar(20))

AS
BEGIN
	DECLARE @DefaultAccount varchar(20),
		@IdAccount INT,
		@CountryCode varchar(3),
		@IdCountry	INT

	SELECT @DefaultAccount = DefaultAccount
	FROM COST_INCOME_TYPES
	WHERE Name = @AccountNumber


	SELECT @CountryCode=  SUBSTRING(FileName,4,3)
	FROM IMPORTS 
	WHERE IdImport = @IdImport 
	
	SELECT @IdCountry = Id
	FROM COUNTRIES
	WHERE Code = @CountryCode
	
	SELECT @IdAccount = dbo.fnGetActualDetailCostsIdAccount(@IdCountry,@DefaultAccount)

	INSERT INTO @tablevalues (IdAccount, DefaultAccount) VALUES (@IdAccount, @DefaultAccount)
RETURN
END

GO

