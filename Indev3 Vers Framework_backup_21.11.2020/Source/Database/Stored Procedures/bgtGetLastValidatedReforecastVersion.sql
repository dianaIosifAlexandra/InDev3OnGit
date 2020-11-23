IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].bgtGetLastValidatedReforecastVersion') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetLastValidatedReforecastVersion
GO

CREATE  PROCEDURE bgtGetLastValidatedReforecastVersion
(
	@IdProject INT
)
AS
declare @IdGeneration int
declare @IsValidated bit

		select top 1 @IdGeneration = IdGeneration, @IsValidated = IsValidated
		from BUDGET_TOCOMPLETION TABLOCKX
		WHERE 	IdProject = @IdProject
		order by IdGeneration desc
		
		if @IsValidated = 1
			select @IdGeneration
		else
			select 0

GO
