IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].bgtGetReforecastVersions') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetReforecastVersions
GO

CREATE  PROCEDURE bgtGetReforecastVersions
(
	@IdProject INT,
	@Version CHAR(1)
)
AS

		select IdGeneration
		from BUDGET_TOCOMPLETION TABLOCKX
		WHERE 	IdProject = @IdProject
		
GO




