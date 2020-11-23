IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].bgtGetLastValidatedRevisedVersion') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetLastValidatedRevisedVersion
GO

CREATE  PROCEDURE bgtGetLastValidatedRevisedVersion
(
	@IdProject INT
)
AS

declare @IdGeneration int
declare @IsValidated bit

		select top 1 @IdGeneration = IdGeneration, @IsValidated = IsValidated
		from BUDGET_REVISED TABLOCKX
		WHERE 	IdProject = @IdProject
		order by IdGeneration desc
		
		if @IsValidated = 1
			select @IdGeneration
		else
			select 0
GO
