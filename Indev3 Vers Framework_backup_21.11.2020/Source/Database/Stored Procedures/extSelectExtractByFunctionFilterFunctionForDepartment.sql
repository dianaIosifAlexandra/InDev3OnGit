--Drops the Procedure extSelectExtractByFunctionFilterFunctionForDepartment if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extSelectExtractByFunctionFilterFunctionForDepartment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extSelectExtractByFunctionFilterFunctionForDepartment
GO
CREATE PROCEDURE extSelectExtractByFunctionFilterFunctionForDepartment
	@IdDepartment AS INT --The Id of the selected department
AS
	--If @Id has the value -1, it will return all FUNCTIONS
	IF @IdDepartment = -1
		SELECT 	F.[Id]		AS 'Id',		
			F.[Name]	AS 'Name'		
		FROM [FUNCTIONS] AS F(nolock)	
		LEFT JOIN DEPARTMENTS D
			ON F.[Id] = D.IdFunction
		GROUP BY F.[Id], F.[Name], F.Rank
		ORDER BY F.[Rank]
	ELSE
		SELECT 	F.[Id]		AS 'Id',		
			F.[Name]	AS 'Name'		
		FROM [FUNCTIONS] AS F(nolock)	
		LEFT JOIN DEPARTMENTS D
			ON F.ID = D.IdFunction 
		WHERE ISNULL(D.[Id],0) =@IdDepartment
		GROUP BY F.[Id], F.[Name], F.Rank
		ORDER BY F.[Rank]
GO
