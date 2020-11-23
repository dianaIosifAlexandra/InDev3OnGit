--Drops the Procedure bgtInitialBudgetEvidenceCheck if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtInitialBudgetEvidenceCheck]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtInitialBudgetEvidenceCheck
GO

CREATE  PROCEDURE bgtInitialBudgetEvidenceCheck
	@IdProject		INT		--The Id of the selected Project
AS

DECLARE @Rowcount    INT
  
-- There is a project selected and the project is active
SET @Rowcount = (SELECT  count([Id]) AS 'ProjectsCount'
        FROM 	 PROJECTS
	WHERE   [Id]=@IdProject 
			AND [IsActive]=1);
IF (@Rowcount = 0)
BEGIN
	RAISERROR('The selected project must be active',16,1)
	RETURN -1
END

-- The project has at least 1 work package
SET @Rowcount = (SELECT count([Id]) 
		FROM WORK_PACKAGES
		WHERE	[IdProject] = @IdProject)
IF (@Rowcount = 0)
BEGIN
	RAISERROR('The selected project does not have any Work Packages defined',16,1)
	RETURN -2
END

RETURN 1
GO

