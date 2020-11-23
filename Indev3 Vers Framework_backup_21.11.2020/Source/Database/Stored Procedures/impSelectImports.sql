--Drops the Procedure impSelectImports if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impSelectImports]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectImports
GO
CREATE PROCEDURE impSelectImports
(
	@IdImport INT
)

AS
	

	IF(@IdImport >0)
	BEGIN
		SELECT [IdImport], [ImportDate], [FileName], [IdAssociate] 
		FROM [IMPORTS]
		WHERE IdImport = @IdImport
			
	END
	ELSE
	BEGIN
		SELECT [IdImport], [ImportDate], [FileName], [IdAssociate] 
		FROM [IMPORTS]
	END

GO
