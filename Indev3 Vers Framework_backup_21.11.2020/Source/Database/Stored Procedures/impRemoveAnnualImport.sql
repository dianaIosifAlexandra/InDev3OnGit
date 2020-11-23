/****** Object:  StoredProcedure [dbo].[impRemoveAnnualImport]    Script Date: 9/29/2015 5:28:14 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impRemoveAnnualImport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[impRemoveAnnualImport]
GO


Create procedure [impRemoveAnnualImport]
@IdImport int
as

declare @errMessage varchar(500)

if not exists (select IdImport from ANNUAL_BUDGET_IMPORTS (nolock) where IdImport=@IdImport)
  return
  
begin tran

DELETE ANNUAL_BUDGET_DATA_DETAILS_HOURS where IdImport=@IdImport

if @@error <> 0
  begin
     set @errMessage = 'ANNUAL_BUDGET_DATA_DETAILS_HOURS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end
  
DELETE ANNUAL_BUDGET_DATA_DETAILS_SALES where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'ANNUAL_BUDGET_DATA_DETAILS_SALES for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE ANNUAL_BUDGET_DATA_DETAILS_COSTS where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'ANNUAL_BUDGET_DATA_DETAILS_COSTS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end
 
DELETE ANNUAL_BUDGET_IMPORT_LOGS_DETAILS where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'ANNUAL_BUDGET_IMPORT_LOGS_DETAILS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE ANNUAL_BUDGET_IMPORT_LOGS where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'ANNUAL_BUDGET_IMPORT_LOGS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE IMPORT_DETAILS where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'IMPORT_DETAILS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end

DELETE ANNUAL_BUDGET_IMPORT_DETAILS where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'ANNUAL_BUDGET_IMPORT_DETAILS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
	 goto err
  end

  
DELETE ANNUAL_BUDGET_IMPORTS where IdImport=@IdImport
if @@error <> 0
  begin
     set @errMessage = 'ANNUAL_BUDGET_IMPORTS for IdImport = ' + cast(@IdImport as varchar) + ' couldn''t be deleted'
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
