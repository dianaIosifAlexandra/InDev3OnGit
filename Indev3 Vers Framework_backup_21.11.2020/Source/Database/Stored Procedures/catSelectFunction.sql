--Drops the Procedure catSelectFunction if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectFunction]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectFunction
GO
CREATE PROCEDURE catSelectFunction
	@Id AS INT 	--The Id of the selected Function
AS
	--If @Id has the value -1, it will return all Functions
	IF (@Id = -1)
	BEGIN 
		SELECT 	
			F.[Name]	AS 'Name',
			F.[Id]		AS 'Id'
		FROM FUNCTIONS F(nolock)
		ORDER BY F.Rank

		RETURN
	END

	--If @Id doesn't have the value -1 it will return the selected Function
	SELECT 	F.[Id]		AS 'Id',
		F.[Name]	AS 'Name'
	FROM FUNCTIONS AS F(nolock)
	WHERE F.[Id] = @Id
GO

