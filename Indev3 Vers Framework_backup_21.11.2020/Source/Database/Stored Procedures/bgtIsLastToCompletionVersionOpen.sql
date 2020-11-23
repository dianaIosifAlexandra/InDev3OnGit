--Drops the Procedure bgtIsLastToCompletionVersionOpen if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtIsLastToCompletionVersionOpen]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtIsLastToCompletionVersionOpen
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[bgtIsLastToCompletionVersionOpen]
@IdProject int

as

declare @IdVersion int

SELECT @IdVersion = MAX(IdGeneration) 
FROM BUDGET_TOCOMPLETION TABLOCKX
WHERE 	IdProject = @IdProject

declare @rez int = 0

if exists (select * from BUDGET_TOCOMPLETION_STATES
			where IdProject = @IdProject
			and IdGeneration = @IdVersion
			and State = 'O'
			)
	set @rez = 1

return @rez

GO


