if (select count(*)
	from ACTUAL_DATA_DETAILS_COSTS
	where IdAccount = 357 and IdCountry = 13
	) > 0
begin
	begin tran

	insert into ACTUAL_DATA_DETAILS_SALES
	(IdProject, IdPhase, IdWorkPackage, IdCostCenter, YearMonth, IdAssociate, IdCountry, IdAccount, SalesVal, DateImport, IdImport)
	select IdProject, IdPhase, IdWorkPackage, IdCostCenter, YearMonth, IdAssociate, IdCountry, IdAccount, CostVal,DateImport, IdImport
	from ACTUAL_DATA_DETAILS_COSTS
	where IdAccount = 357 and IdCountry = 13

	if @@error <> 0
	  goto ex

	delete ACTUAL_DATA_DETAILS_COSTS where IdAccount = 357 and IdCountry = 13

	if @@error <> 0
	  goto ex

	update GL_Accounts 
	set IdCostType = 7
	where IdCountry=13 and Account='7051031000'

	if @@error <> 0
	  goto ex

	commit
	print 'Execution completed'
	goto ret

	ex:
	rollback
	print 'Execution failed. Please send any error message you got'

end
else
   Print 'There is no data in ACTUAL_DATA_DETAILS_COSTS with Account = 7051031000 and Country = Slovakia'
ret:

