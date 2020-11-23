
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impRemoveActualImport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[impRemoveActualImport]
GO


CREATE procedure [impRemoveActualImport]
@IdImport int
as

declare @errMessage varchar(500)

if not exists (select IdImport from IMPORTS (nolock) where IdImport=@IdImport)
  return


begin tran

DELETE ACTUAL_DATA_DETAILS_HOURS where IdImport=@IdImport

if @@error <> 0
  begin
     set @errMessage = 'ACTUAL_DATA_DETAILS_HOURS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end
  
DELETE ACTUAL_DATA_DETAILS_SALES where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'ACTUAL_DATA_DETAILS_SALES for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE ACTUAL_DATA_DETAILS_COSTS where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'ACTUAL_DATA_DETAILS_COSTS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end
 
DELETE IMPORT_LOGS_DETAILS where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'IMPORT_LOGS_DETAILS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE IMPORT_LOGS where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'IMPORT_LOGS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE IMPORT_DETAILS_KEYROWS_MISSING where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'IMPORT_DETAILS_KEYROWS_MISSING for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE IMPORT_DETAILS where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'IMPORT_DETAILS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE IMPORTS where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'IMPORTS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
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

