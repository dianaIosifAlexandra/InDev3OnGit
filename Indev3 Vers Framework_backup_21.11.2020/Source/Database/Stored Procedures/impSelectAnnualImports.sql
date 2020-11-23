--Drops the Procedure impSelectAnnualImports if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impSelectAnnualImports]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectAnnualImports
GO
CREATE PROCEDURE impSelectAnnualImports
(
	@IdImport INT
)

AS


	IF(@IdImport >0)
	BEGIN
		SELECT [IdImport], [ImportDate], [FileName]
		FROM [ANNUAL_BUDGET_IMPORTS]
		WHERE IdImport = @IdImport
			
	END
	ELSE
	BEGIN
		SELECT [IdImport], [ImportDate], [FileName]
		FROM [ANNUAL_BUDGET_IMPORTS]
	END

GO
