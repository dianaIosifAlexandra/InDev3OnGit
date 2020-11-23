--Drops the Procedure catInsertFunction if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertFunction]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertFunction
GO
CREATE PROCEDURE catInsertFunction
	@Name		VARCHAR(50)	--The Name of the Function you want to Insert
	
AS
DECLARE @Id		INT

	SELECT @Id = ISNULL(MAX(F.[Id]), 0) + 1
	FROM [FUNCTIONS] AS F (TABLOCKX)

	INSERT INTO [FUNCTIONS] ([Id],[Name])
	VALUES		      	(@Id,@Name)
	
	RETURN @Id
GO

