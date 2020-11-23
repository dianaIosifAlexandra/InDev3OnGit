--Drops the Procedure catUpdateFunction if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateFunction]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateFunction
GO
CREATE PROCEDURE catUpdateFunction
	@Id		INT,		--The Id of the selected Function
	@Name		VARCHAR(50)	--The Name of the Function you want to Update
	
AS
DECLARE @IdUpdate	INT,
	@Rowcount 	INT

	SELECT @IdUpdate = F.[Id]
	FROM [FUNCTION] AS F(HOLDLOCK)
	WHERE F.[Id] = @Id

	IF(@IdUpdate = NULL)
	BEGIN
		RAISERROR('The selected Id of the Function does not exists in the FUNCTION table',16,1)
	END

	UPDATE [FUNCTION] 	
	SET   [Name] = @Name
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

