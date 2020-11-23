--Drops the Procedure bgtInsertInitialBudget if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtInsertInitialBudget]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtInsertInitialBudget
GO

CREATE  PROCEDURE bgtInsertInitialBudget
	@IdProject	INT		--The Id of the selected Project
	
AS
BEGIN
	
	IF NOT EXISTS( SELECT *
	FROM PROJECTS AS P(TABLOCKX)
	WHERE 	P.[Id] = @IdProject) 
	BEGIN
		RAISERROR('The selected project does not exists anymore',16,1)
		RETURN
	END

	IF NOT EXISTS (SELECT IdProject FROM BUDGET_INITIAL WHERE IdProject = @IdProject)
	BEGIN
		INSERT INTO BUDGET_INITIAL 
			(IdProject, IsValidated, ValidationDate)
		VALUES	(@IdProject, 0, GETDATE())
	END
END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

