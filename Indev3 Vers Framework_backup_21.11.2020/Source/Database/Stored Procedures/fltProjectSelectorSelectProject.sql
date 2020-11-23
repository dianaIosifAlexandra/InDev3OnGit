--Drops the Procedure fltProjectSelectorSelectProject if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fltProjectSelectorSelectProject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE fltProjectSelectorSelectProject
GO

CREATE PROCEDURE fltProjectSelectorSelectProject
	@IdProject AS INT 	--The Id of the selected Project
AS

	--return IdProgram and IdOwner related to the project

	SELECT PRJ.Id AS IdProject,
            PRJ.Name + ' [' + PRJ.Code + ']' AS ProjectName,
            PRJ.IdProgram, 
            PRG.IdOwner 
	FROM PROJECTS PRJ (nolock)
	INNER JOIN PROGRAMS PRG (nolock) 
		ON PRG.Id = PRJ.IdProgram
	WHERE PRJ.Id = @IdProject


GO
