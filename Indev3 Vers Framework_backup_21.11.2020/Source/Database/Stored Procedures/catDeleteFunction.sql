--Drops the Procedure catDeleteFunction if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteFunction]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteFunction
GO
CREATE PROCEDURE catDeleteFunction
	@Id AS INT 	--The Id of the selected Function
AS
DECLARE @RowCount INT

	DELETE FROM [FUNCTIONS]
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

