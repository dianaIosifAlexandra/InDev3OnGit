--Drops the Procedure fltProjectSelectorSelectProjectWithWPCodeSuffix if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fltProjectSelectorSelectProjectWithWPCodeSuffix]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE fltProjectSelectorSelectProjectWithWPCodeSuffix
GO

CREATE PROCEDURE fltProjectSelectorSelectProjectWithWPCodeSuffix
	@IdProject AS INT, 	--The Id of the selected Project
	@IdAssociate AS INT
AS

	--return IdProgram and IdOwner related to the project

	SELECT 
		PRJ.Id AS IdProject,
		PRJ.Name + ' [' + PRJ.Code + ']' AS ProjectName,
		PRJ.IdProgram, 
		PRG.IdOwner,
		ISNULL(PF.WPCodeSuffixes, '') AS 'ProjectFunctionWPCodeSuffix' 
	FROM PROJECTS PRJ (nolock)
	INNER JOIN PROGRAMS PRG (nolock) 
		ON PRG.Id = PRJ.IdProgram
	LEFT JOIN PROJECT_CORE_TEAMS PCT (nolock)
		ON PCT.IdProject = PRJ.Id AND
		   PCT.IdAssociate = @IdAssociate
	LEFT JOIN PROJECT_FUNCTIONS PF(nolock)
		ON PCT.IdFunction = PF.[Id]
	WHERE PRJ.Id = @IdProject

GO
