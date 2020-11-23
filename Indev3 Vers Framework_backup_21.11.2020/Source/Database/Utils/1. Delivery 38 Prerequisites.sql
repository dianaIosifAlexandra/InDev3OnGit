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


if not exists(Select * from Associates a join Countries b on a.IdCountry = b.Id where b.Code='ZON' and  InergyLogin='ZON\null')
begin
declare @Id int, @idAsoc int
select @id = id from countries where Code ='ZON'
select @idAsoc = max(Id) + 1 from Associates
insert into Associates
(Id, IdCountry, EmployeeNumber, Name, InergyLogin, IsActive, PercentageFullTime, IsSubContractor)
values
(@IdAsoc, @Id, '0','NA, cost or sales', 'ZON\null', 0, 0, 0)
end
go