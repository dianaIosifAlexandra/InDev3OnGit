--Drops the Procedure catInsertCurrency if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catInsertCurrency]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catInsertCurrency
GO
CREATE PROCEDURE catInsertCurrency
	@Code	VARCHAR(3),	--The Code of the Currency you want to Insert
	@Name	VARCHAR(50)	--The Name of the Currency you want to Insert
	
AS
DECLARE @Id	INT

	SELECT @Id = ISNULL(MAX(C.[Id]), 0) + 1
	FROM CURRENCIES AS C (TABLOCKX)
	
	INSERT INTO CURRENCIES ([Id],Code,[Name])
	VALUES		      (@Id,@Code,@Name)
	
	RETURN @Id
GO

