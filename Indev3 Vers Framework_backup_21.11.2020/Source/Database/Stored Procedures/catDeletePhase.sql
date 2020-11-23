--Drops the Procedure catDeletePhase if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeletePhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeletePhase
GO
CREATE PROCEDURE catDeletePhase
	@Id AS INT 	--The Id of the selected Phase
AS
DECLARE @Rowcount INT
	DELETE FROM PHASES
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

