--Drops the Procedure catUpdateCurrency if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateCurrency]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateCurrency
GO
CREATE PROCEDURE catUpdateCurrency
	@Id		INT,		--The Id of the selected Currency
 	@Code		VARCHAR(3),	--The Code of the Currency you want to Update
	@Name		VARCHAR(50)	--The Name of the Currency you want to Update
	
AS
DECLARE @IdUpdate	INT,
	@Rowcount 	INT

	SELECT @IdUpdate = C.[Id]
	FROM CURRENCIES AS C(HOLDLOCK)
	WHERE C.[Id] = @Id

	IF(@IdUpdate = NULL)
	BEGIN
		RAISERROR('The selected Id of the Currency does not exists in the CURRENCIES table',16,1)
	END

	UPDATE CURRENCIES 	
	SET Code = @Code,
	    [Name] = @Name
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

