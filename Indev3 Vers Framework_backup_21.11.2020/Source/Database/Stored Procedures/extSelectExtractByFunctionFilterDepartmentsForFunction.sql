--Drops the Procedure extSelectExtractByFunctionFilterDepartmentsForFunction if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extSelectExtractByFunctionFilterDepartmentsForFunction]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extSelectExtractByFunctionFilterDepartmentsForFunction
GO
CREATE PROCEDURE extSelectExtractByFunctionFilterDepartmentsForFunction
	@IdFunction AS INT --The Id of the selected function
AS
	IF @IdFunction = -1
		SELECT 	D.[Id]		AS 'Id',		
			D.[Name]	AS 'Name',
			D.IdFunction	AS 'IdFunction'		
		FROM DEPARTMENTS AS D(nolock)
		ORDER BY D.[Rank]
	ELSE
		SELECT 	D.[Id]		AS 'Id',		
			D.[Name]	AS 'Name',
			D.IdFunction	AS 'IdFunction'					
		FROM DEPARTMENTS AS D(nolock)	
		WHERE IdFunction = @IdFunction
		ORDER BY D.[Rank]

GO
