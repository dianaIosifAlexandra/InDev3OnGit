--Drops the Function fnGetActualDetailIdAccount if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetActualDetailIdAccount]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetActualDetailIdAccount]
GO


CREATE   FUNCTION fnGetActualDetailIdAccount
(
	@IdCountry INT,
	@AccountNumber VARCHAR(20)	
)	
RETURNS INT
AS
BEGIN
    DECLARE @IDAccount	INT
	SELECT @IDAccount = [Id] 
	FROM [GL_ACCOUNTS] 
	WHERE 	IdCountry = @IdCountry AND
	        [Account]=@AccountNumber

    RETURN @IDAccount
END

GO

