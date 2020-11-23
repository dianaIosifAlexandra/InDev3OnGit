--Drops the Procedure authDeleteAssociateRole if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authDeleteAssociateRole]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authDeleteAssociateRole
GO
CREATE PROCEDURE authDeleteAssociateRole
	@IdAssociate	INT
AS
	IF EXISTS (
		SELECT 	IdAssociate
		FROM	ASSOCIATE_ROLES
		WHERE 	IdAssociate = @IdAssociate
	)
	BEGIN
		DELETE FROM ASSOCIATE_ROLES
		WHERE	IdAssociate = @IdAssociate
	END
	
GO

