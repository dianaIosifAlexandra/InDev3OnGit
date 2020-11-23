--Drops the Procedure bgtUpdateProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authUpdateAssociateRole]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authUpdateAssociateRole
GO
CREATE PROCEDURE authUpdateAssociateRole
	@IdAssociate	INT,
	@IdRole		INT
AS
	IF EXISTS (
		SELECT 	IdAssociate
		FROM	ASSOCIATE_ROLES
		WHERE 	IdAssociate = @IdAssociate
	)
	BEGIN
		UPDATE 	ASSOCIATE_ROLES
		SET	IdAssociate = @IdAssociate,
			IdRole = @IdRole
		WHERE	IdAssociate = @IdAssociate
	END
	ELSE
	BEGIN
		INSERT INTO ASSOCIATE_ROLES
			(IdAssociate, IdRole)
		VALUES	(@IdAssociate, @IdRole)
	END
GO

