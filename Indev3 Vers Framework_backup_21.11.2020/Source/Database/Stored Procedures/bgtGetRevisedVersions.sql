IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].bgtGetRevisedVersions') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetRevisedVersions
GO

CREATE  PROCEDURE bgtGetRevisedVersions
(
	@IdProject INT,
	@Version CHAR(1)
)
AS

		select IdGeneration
		from BUDGET_REVISED TABLOCKX
		WHERE 	IdProject = @IdProject
GO
