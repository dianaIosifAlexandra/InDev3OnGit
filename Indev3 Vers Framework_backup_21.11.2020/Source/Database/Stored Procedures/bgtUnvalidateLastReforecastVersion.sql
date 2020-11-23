IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].bgtUnvalidateLastReforecastVersion') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUnvalidateLastReforecastVersion
GO

CREATE  PROCEDURE bgtUnvalidateLastReforecastVersion
(
	@IdProject INT
)
AS
	declare @IdGeneration int
	declare @errMessage varchar(500)

	select @IdGeneration = max(IdGeneration)
	from BUDGET_TOCOMPLETION TABLOCKX
	WHERE 	IdProject = @IdProject
	and IsValidated = 1
	
	if isnull(@IdGeneration,0) > 0
	   begin
			begin tran


			Update BUDGET_TOCOMPLETION
			set ValidationDate = null,
				YearMonthActualData = null,
				IsValidated = 0
			where IdProject = @IdProject and IdGeneration = @IdGeneration
			
			if @@error <> 0
			   begin
				set @errMessage = 'BUDGET_TOCOMPLETION for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be updated'
				goto err
			   end


			Update BUDGET_TOCOMPLETION_STATES
				set State = 'W'
			where IdProject = @IdProject and 
			IdGeneration = @IdGeneration and 
			State <> 'N'
				  
			if @@error <> 0
			   begin
				set @errMessage = 'BUDGET_TOCOMPLETION_STATES for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be updated'
				goto err
			   end
				  
				commit
				goto retur
	   end
	   
	err:	   
		rollback
		raiserror(@errMessage,16,1)
	
	retur:
		return
		
GO

