--Drops the Procedure bgtIsLastRevisedVersionOpen if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtIsLastRevisedVersionOpen]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtIsLastRevisedVersionOpen
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[bgtIsLastRevisedVersionOpen]
@IdProject int

as

declare @IdVersion int

SELECT @IdVersion = MAX(IdGeneration) 
FROM BUDGET_REVISED TABLOCKX
WHERE 	IdProject = @IdProject

declare @rez int = 0

if exists (select * from BUDGET_REVISED_STATES
			where IdProject = @IdProject
			and IdGeneration = @IdVersion
			and State = 'O'
			)
	set @rez = 1

return @rez

GO

