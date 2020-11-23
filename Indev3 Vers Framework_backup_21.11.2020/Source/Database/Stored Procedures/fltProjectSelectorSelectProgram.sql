--Drops the Procedure fltProjectSelectorSelectProgram if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fltProjectSelectorSelectProgram]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE fltProjectSelectorSelectProgram
GO

-- exec fltProjectSelectorSelectProgram 1

CREATE PROCEDURE fltProjectSelectorSelectProgram
	@IdProgram AS INT 	--The Id of the selected Project
AS

	--return IdOwner related to the project

	SELECT PRG.Id as IdProgram, PRG.IdOwner 
	FROM PROGRAMS PRG (nolock)
	WHERE PRG.Id = @IdProgram


GO

