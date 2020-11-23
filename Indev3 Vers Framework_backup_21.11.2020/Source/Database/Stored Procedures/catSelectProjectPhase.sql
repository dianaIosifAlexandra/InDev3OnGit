--Drops the Procedure catSelectProjectPhase if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectProjectPhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectProjectPhase
GO
CREATE PROCEDURE catSelectProjectPhase
	@Id AS INT 	--The Id of the selected ProjectPhase
AS
	--If @Id has the value -1, it will return all PROJECT_PHASES
	IF (@Id = -1)
	BEGIN 
		SELECT 	P.[Id]		AS 'Id',
			P.Code		AS 'Code',
			P.[Name]	AS 'Name'
		FROM PROJECT_PHASES P(nolock)

		RETURN
	END

	SELECT 	P.[Id]		AS 'Id',
		P.Code 		AS 'Code',
		P.[Name]	AS 'Name'
	FROM PROJECT_PHASES P(nolock)
	WHERE P.[Id] = @Id
GO

