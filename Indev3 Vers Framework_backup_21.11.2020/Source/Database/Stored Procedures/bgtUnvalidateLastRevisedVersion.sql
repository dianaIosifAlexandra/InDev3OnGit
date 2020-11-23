IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].bgtUnvalidateLastRevisedVersion') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUnvalidateLastRevisedVersion
GO

CREATE  PROCEDURE bgtUnvalidateLastRevisedVersion
(
	@IdProject INT
)
AS
	declare @IdGeneration int
	declare @errMessage varchar(500)

	select @IdGeneration = max(IdGeneration)
	from BUDGET_REVISED TABLOCKX
	WHERE 	IdProject = @IdProject
	and IsValidated = 1
	
	if isnull(@IdGeneration,0) > 0
	   begin
		begin tran

			Update BUDGET_REVISED
				set IsValidated = 0
			where IdProject = @IdProject and IdGeneration = @IdGeneration
			
			if @@error <> 0
			   begin
				set @errMessage = 'BUDGET_REVISED for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be updated'
				goto err
			   end

			Update BUDGET_REVISED_STATES
			set State = 'W'
			where IdProject = @IdProject and 
				  IdGeneration = @IdGeneration and 
				  State <> 'N'
				  
			if @@error <> 0
			   begin
				set @errMessage = 'BUDGET_REVISED_STATES for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be updated'
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

