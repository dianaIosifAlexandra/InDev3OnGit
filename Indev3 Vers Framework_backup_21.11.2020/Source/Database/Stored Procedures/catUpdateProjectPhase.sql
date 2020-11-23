--Drops the Procedure catUpdateProjectPhase if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateProjectPhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateProjectPhase
GO
CREATE PROCEDURE catUpdateProjectPhase
	@Id		INT,		--The Id of the selected ProjectPhase
 	@Code		VARCHAR(3),	--The Code of the ProjectPhase you want to Update
	@Name		VARCHAR(50)	--The Name of the ProjectPhase you want to Update
	
AS
DECLARE @IdUpdate	INT,
	@Rowcount 	INT

	SELECT @IdUpdate = PP.[Id]
	FROM PROJECT_PHASES AS PP(HOLDLOCK)
	WHERE PP.[Id] = @Id

	IF(@IdUpdate = NULL)
	BEGIN
		RAISERROR('The selected Id of the ProjectPhase does not exists in the PROJECT_PHASES table',16,1)
	END

	UPDATE PROJECT_PHASES 	
	SET Code = @Code,
	    [Name] = @Name
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

