--Drops the Procedure catGetFunctionForUserAndProject if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catGetFunctionForUserAndProject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catGetFunctionForUserAndProject
GO
CREATE PROCEDURE catGetFunctionForUserAndProject
	@IdAssociate    AS INT,		--The Id of the Associate of the selected Function
	@IdProject 	AS INT		--The IdProject of the selected Function

AS
	
	SELECT 	PCT.IdFunction		AS 'IdFunction'
	FROM PROJECT_CORE_TEAMS AS PCT	
	WHERE 	PCT.IdAssociate = @IdAssociate AND 
		PCT.IdProject = @IdProject
GO

