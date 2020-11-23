declare @IdProject int
select @IdProject = Id from Projects where Code='C150728'

if @IdProject is null
begin
	print 'Project Code C150728 was not found in Projects table. Script stopped.'
	goto er
end

begin tran
delete BUDGET_INITIAL_DETAIL_COSTS where IdProject=@IdProject

if @@error <> 0
  begin
	print 'Error at deleting BUDGET_INITIAL_DETAIL_COSTS'
	goto er
  end


delete BUDGET_INITIAL_DETAIL where IdProject=@IdProject

if @@error <> 0
  begin
	print 'Error at deleting BUDGET_INITIAL_DETAIL'
	goto er
  end

delete BUDGET_INITIAL_STATES where IdProject=@IdProject
if @@error <> 0
  begin
	print 'Error at deleting BUDGET_INITIAL_STATES'
	goto er
  end

delete BUDGET_INITIAL where IdProject=@IdProject
if @@error <> 0
  begin
	print 'Error at deleting BUDGET_INITIAL'
	goto er
  end

commit
print 'Initial Project was deleted.'
goto ex

er:
	rollback

ex:
go





