--Drops the Procedure catInsertProjectPhase if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertProjectPhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertProjectPhase
GO
CREATE PROCEDURE catInsertProjectPhase
	@Code		VARCHAR(3),	--The Code of the ProjectPhase you want to Insert
	@Name		VARCHAR(50)	--The Name of the ProjectPhase you want to Insert
	
AS
DECLARE @Id	INT

	SELECT @Id = ISNULL(MAX(PP.[Id]), 0) + 1
	FROM PROJECT_PHASES AS PP (TABLOCKX)
	
	INSERT INTO PROJECT_PHASES ([Id],Code,[Name])
	VALUES		   	   (@Id,@Code,@Name)
	
	RETURN @Id
GO

