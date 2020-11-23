--Drops the Procedure catUpdatePhase if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdatePhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdatePhase
GO
CREATE PROCEDURE catUpdatePhase
	@Id		INT,		--The Id of the selected Phase
 	@Code		VARCHAR(3),	--The Code of the Phase you want to Update
	@Name		VARCHAR(50)	--The Name of the Phase you want to Update
	
AS
DECLARE @IdUpdate	INT,
	@Rowcount 	INT

	SELECT @IdUpdate = P.[Id]
	FROM PHASES AS P(HOLDLOCK)
	WHERE P.[Id] = @Id

	IF(@IdUpdate = NULL)
	BEGIN
		RAISERROR('The selected Id of the Phase does not exists in the PHASES table',16,1)
	END

	UPDATE PHASES 	
	SET Code = @Code,
	    [Name] = @Name
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

