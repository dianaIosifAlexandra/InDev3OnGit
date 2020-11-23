IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtRestoreBudgetToInitialState]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[bgtRestoreBudgetToInitialState]
GO


Create procedure [bgtRestoreBudgetToInitialState]
@IdProject int
as

declare @errMessage varchar(500)

if not exists (select IdProject from BUDGET_INITIAL (nolock) WHERE IdProject = @IdProject and IsValidated = 1)
  return
  

begin tran

--deletes all the information for TOCOMPLETION budget (all generations)
DELETE FROM BUDGET_TOCOMPLETION_DETAIL_COSTS WHERE IdProject = @IdProject
if @@error <> 0
  begin
     set @errMessage = 'BUDGET_TOCOMPLETION_DETAIL_COSTS for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be deleted'
	 goto err
  end
  
DELETE FROM BUDGET_TOCOMPLETION_DETAIL WHERE IdProject = @IdProject
if @@error <> 0
  begin
     set @errMessage = 'BUDGET_TOCOMPLETION_DETAIL for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE FROM BUDGET_TOCOMPLETION_PROGRESS WHERE IdProject = @IdProject
if @@error <> 0
  begin
     set @errMessage = 'BUDGET_TOCOMPLETION_PROGRESS for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be deleted'
	 goto err
  end
  
DELETE FROM BUDGET_TOCOMPLETION_STATES WHERE IdProject = @IdProject
if @@error <> 0
  begin
     set @errMessage = 'BUDGET_TOCOMPLETION_STATES for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be deleted'
	 goto err
  end
  
DELETE FROM BUDGET_TOCOMPLETION WHERE IdProject = @IdProject
if @@error <> 0
  begin
     set @errMessage = 'BUDGET_TOCOMPLETION for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be deleted'
	 goto err
  end

--deletes all the information for REVISED budget (all generations)
DELETE FROM BUDGET_REVISED_DETAIL_COSTS WHERE IdProject = @IdProject
if @@error <> 0
  begin
     set @errMessage = 'BUDGET_REVISED_DETAIL_COSTS for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be deleted'
	 goto err
  end
  
DELETE FROM BUDGET_REVISED_DETAIL WHERE IdProject = @IdProject
if @@error <> 0
  begin
     set @errMessage = 'BUDGET_REVISED_DETAIL for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE FROM BUDGET_REVISED_STATES WHERE IdProject = @IdProject
if @@error <> 0
  begin
     set @errMessage = 'BUDGET_REVISED_STATES for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE FROM BUDGET_REVISED WHERE IdProject = @IdProject
if @@error <> 0
  begin
     set @errMessage = 'BUDGET_REVISED for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be deleted'
	 goto err
  end

--sets the state to 'Waiting for approval' for all initial budget members 
UPDATE BUDGET_INITIAL_STATES SET State='W' WHERE IdProject = @IdProject
if @@error <> 0
  begin
     set @errMessage = 'BUDGET_INITIAL_STATES for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be updated'
	 goto err
  end


UPDATE BUDGET_INITIAL SET IsValidated = 0 WHERE IdProject = @IdProject
if @@error <> 0
  begin
     set @errMessage = 'BUDGET_INITIAL for IdProject = ' + cast(@IdProject as varchar) + ' couldn''t be updated'
	 goto err
  end
  
	commit
	select 0
	goto retur

err:
	rollback
	raiserror(@errMessage,16,1)
	select -1

retur:
    return


GO

