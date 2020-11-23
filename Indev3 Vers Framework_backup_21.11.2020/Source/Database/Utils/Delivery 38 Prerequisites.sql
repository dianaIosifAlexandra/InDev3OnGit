if not exists(select * from [IMPORT_SOURCES] where Code = 'SAPZON')
begin
	declare @id int 
	declare @rank int
	select @id = max(id) from [IMPORT_SOURCES]
	select @rank = max([rank])  from [IMPORT_SOURCES]
	set @id = @id + 1
	set @rank = @rank + 1

	insert into [IMPORT_SOURCES]
	(Id, IdApplicationTypes, Code, SourceName, Active, [Rank])
	select @id, 1, 'SAPZON', 'Zonhoven', 1, @rank
end
go

if not exists(select * from Countries where Code='ZON')
begin

declare @Rank int 
declare @Id int
select @Rank = max([Rank]), @Id = max(Id) from Countries
set @Rank = @Rank + 1
set @Id = @Id + 1

insert into Countries
(Id, Code, Name, IdRegion, IdCurrency, EMail,[Rank])
values (@Id, 'ZON', 'Zonhoven', 6, 1, null, @Rank)
end
go

if not exists(select * from IMPORT_SOURCES_COUNTRIES where IdImportSource = (select Id from IMPORT_SOURCES where Code='SAPZON'))
insert into IMPORT_SOURCES_COUNTRIES
select (select Id from IMPORT_SOURCES where Code='SAPZON'), (select Id from Countries where Name='Zonhoven')
go

if not exists(select * from Information_Schema.Columns where table_name='IMPORT_SOURCES' and column_name='DiscontinuationYear')
alter table IMPORT_SOURCES
add DiscontinuationYear int
go

update IMPORT_SOURCES
set Active=0, DiscontinuationYear = 2019
where SourceName in ('NetConsole ROW','NAO (NetConsole)','NAO (MFG Pro)')
go


update IMPORT_SOURCES 
set IdApplicationTypes = 1
where Id in (select IdImportSource from IMPORT_SOURCES_COUNTRIES a
													join Countries b on a.IdCountry = b.Id
													where b.Name='Brazil')
and Active=1
go


update Countries
set IdCurrency=(select Id from Currencies where Code='RON')
where Name='Romania'
go


select * from IMPORT_SOURCES_COUNTRIES where IdCountry in (
select * from Countries where Name='Romania')
select * from IMPORT_SOURCES where Id in (10,25)

update IMPORT_SOURCES
where Id in (select 
select * from IMPORT_SOURCES

2- Currently the files of Actuals of Brazil are named OTHBRAxx2019.csv.  Brazil is now using SAP and I would like to change the files name for SAPBRAxx2019.csv.

select * from IMPORT_SOURCES where Id in (6,12)
select * from IMPORT_APPLICATION_TYPES 
begin tran


select Id from Currencies where Code='RON'
rollback

exec impSelectDataStatus @Year=2019
select * from Imports where FileName like 'SAPROM%'
select * from IMPORT_DETAILS where IdImport=6382
select * from ACTUAL_DATA_DETAILS_COSTS where IdImport=6382
select * from COST_CENTERS where Id=1108
select * from INERGY_LOCATIONS where IdCountry=11
exec extExtractProgramActualData @IdProgram=588,@WPActiveStatus=N'L',@IdCurrencyAssociate=1
exec extExtractByFunctionReforcastData @Year=2018,@IdRegion=2,@IdCountry=4,@IdInergyLocation=-1,@IdFunction=-1,@IdDepartment=-1,@WPActiveStatus=N'L',@CostTypeCategory=N'A',@IdCurrencyAssociate=1

exec extExtractByFunctionReforcastData @Year=2018,@IdRegion=1,@IdCountry=11,@IdInergyLocation=-1,@IdFunction=-1,@IdDepartment=-1,@WPActiveStatus=N'L',@CostTypeCategory=N'A',@IdCurrencyAssociate=1

exec extExtractProgramActualData @IdProgram=588,@WPActiveStatus=N'L',@IdCurrencyAssociate=1

C070200

exec extExtractProjectActualData @IdProject=193,@WPActiveStatus=N'L',@IdCurrencyAssociate=1
exec extExtractProjectActualData @IdProject=876,@WPActiveStatus=N'L',@IdCurrencyAssociate=1

exec extExtractByFunctionActualData @Year=2018,@IdRegion=1,@IdCountry=11,@IdInergyLocation=-1,@IdFunction=-1,@IdDepartment=-1,@WPActiveStatus=N'L',@CostTypeCategory=N'A',@IdCurrencyAssociate=1

exec extExtractProjectActualData @IdProject=1335,@WPActiveStatus=N'L',@IdCurrencyAssociate=1
exec extExtractProjectActualData @IdProject=1552,@WPActiveStatus=N'L',@IdCurrencyAssociate=1

select * from Projects where Code='C090211'
select * from PROGRAMS where Id=588
select * from OWNERS where Id=6

select * from COST_CENTERS where Code='A51021'
select * from INERGY_LOCATIONS where Id=17

select * from COST_CENTERS where Code='KYO6640'
select * from INERGY_LOCATIONS where Id=27


select * from Countries where Id=15
