--sp_help actual_data_details_sales

begin tran
set nocount on

declare @IdCountry int,
	@IdAccount int,
	@IdCostType int

--read the country id for KOREA
select @IdCountry = Id
from Countries where Code = 'KOR'

--read the account for KOREA with specifed code
select @IdAccount = Id
from GL_ACCOUNTS 
where IdCountry = @IdCountry and 
      Account = '61129001'

--read cost type id where we want to move
select @IdCostType=Id from COST_INCOME_TYPES
where Name = 'Other expenses'

--display read information
select @IdCountry as IdCountry, 
       @IdAccount as IdAccount,
       @IdCostType as IdCostType

-----------------------------------------------------------------------

--display info about affected GL account
select * from GL_ACCOUNTS 
where IdCountry = @IdCountry and 
      Id = @IdAccount

--display info about affected imports id - SALES
select count (distinct IdImport) as ImportSalesCount
from ACTUAL_DATA_DETAILS_SALES
where IdCountry = @IdCountry and 
      IdAccount = @IdAccount

--display info about affected imports id - COSTS
select count (distinct IdImport) as ImportCostsCount
from ACTUAL_DATA_DETAILS_COSTS
where IdCountry = @IdCountry and 
      IdAccount = @IdAccount

------------------------------------------------------------------------
--update GL account type
update GL_ACCOUNTS 
set IdCostType = @IdCostType
where IdCountry = @IdCountry and 
      Id = @IdAccount

--copy data from SALES to COSTS
insert into ACTUAL_DATA_DETAILS_COSTS 
      (IdProject, IdPhase, IdWorkPackage, IdCostCenter, YearMonth, IdAssociate, IdCountry, IdAccount, IdCostType, CostVal, DateImport, IdImport)
select IdProject, IdPhase, IdWorkPackage, IdCostCenter,	YearMonth, IdAssociate, IdCountry, IdAccount, @IdCostType, SalesVal, DateImport, IdImport
 from ACTUAL_DATA_DETAILS_SALES
where IdCountry = @IdCountry and 
      IdAccount = @IdAccount

--delete copied data from SALES
delete 
 from ACTUAL_DATA_DETAILS_SALES
where IdCountry = @IdCountry and 
      IdAccount = @IdAccount

------------------------------------------------------------------------

--display info about affected GL account
select * from GL_ACCOUNTS 
where IdCountry = @IdCountry and 
      Id = @IdAccount

--display info about affected imports id - SALES
select count (distinct IdImport) as ImportSalesCount
from ACTUAL_DATA_DETAILS_SALES
where IdCountry = @IdCountry and 
      IdAccount = @IdAccount

--display info about affected imports id - COSTS
select count (distinct IdImport) as ImportCostsCount
from ACTUAL_DATA_DETAILS_COSTS
where IdCountry = @IdCountry and 
      IdAccount = @IdAccount

rollback


