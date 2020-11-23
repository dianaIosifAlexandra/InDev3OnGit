--Drops the Procedure catInsertPhase if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertPhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertPhase
GO
CREATE PROCEDURE catInsertPhase
	@Code	VARCHAR(3),	--The Code of the Phase you want to Insert
	@Name	VARCHAR(50)	--The Name of the Phase you want to Insert
	
AS
DECLARE @Id	INT

	SELECT @Id = ISNULL(MAX(P.[Id]), 0) + 1
	FROM PHASES AS P (TABLOCKX)
	
	INSERT INTO PHASES ([Id],Code,[Name])
	VALUES		   (@Id,@Code,@Name)
	
	RETURN @Id
GO

