if not exists(select * from IMPORT_SOURCES where Code='SAP_US')
 begin
	declare @Id int
	if not exists(select Id from IMPORT_SOURCES where Id=9)
	   set @Id = 9
	else
	   select @Id = max(Id) + 1 from IMPORT_SOURCES

	insert into IMPORT_SOURCES
	(Id, IdApplicationTypes, Code, SourceName, Active, [Rank])
	values
	(@Id, 1, 'SAP_US', 'USA', 1, 9)
  end
go

if not exists(select * from IMPORT_SOURCES where Code='SAP_MEX')
   begin
	declare @Id2 int
	select @Id2 = max(Id) + 1 from IMPORT_SOURCES

	insert into IMPORT_SOURCES
	(Id, IdApplicationTypes, Code, SourceName, Active, [Rank])
	values
	(@Id2, 1, 'SAP_MEX', 'Mexico', 1, 11)
   end
go

if not exists(select *
		from IMPORT_SOURCES_COUNTRIES x
				join
				(
				select a.Id as IDSource, b.Id as IdCountry
				from 
				(select Id from IMPORT_SOURCES where Code='SAP_US') a
				cross join
				(select ID from Countries where Code='USA') b
		) y on x.IdCountry = y.IdCountry and x.IdImportSource = y.IDSource
)
	insert into IMPORT_SOURCES_COUNTRIES 
	select a.Id as IDSource, b.Id as IdCountry
	from 
	(select Id from IMPORT_SOURCES where Code='SAP_US') a
	cross join
	(select ID from Countries where Code='USA') b


if not exists(select *
		from IMPORT_SOURCES_COUNTRIES x
				join
				(
				select a.Id as IDSource, b.Id as IdCountry
				from 
				(select Id from IMPORT_SOURCES where Code='SAP_MEX') a
				cross join
				(select ID from Countries where Code='MEX') b
		) y on x.IdCountry = y.IdCountry and x.IdImportSource = y.IDSource
)
	insert into IMPORT_SOURCES_COUNTRIES 
	select a.Id as IDSource, b.Id as IdCountry
	from 
	(select Id from IMPORT_SOURCES where Code='SAP_MEX') a
	cross join
	(select ID from Countries where Code='MEX') b


if not exists(select * from ROLES where Name='Trainer')
insert into ROLES
select max(Id) + 1 as Id, 'Trainer' as Name from ROLES


declare @IdRoleTrainer int
declare @IdRoleFunctionalManager int

select @IdRoleTrainer = ID from ROLES where Name='Trainer'
select @IdRoleFunctionalManager = ID from ROLES where Name='Functional Manager'

if not exists(select * from ROLE_RIGHTS where IdRole=@IdRoleTrainer)
insert into ROLE_RIGHTS
select @IdRoleTrainer as IdRole, CodeModule, IdOperation, IdPermission
from ROLE_RIGHTS
where IdRole=@IdRoleFunctionalManager


update Role_rights
set IdPermission=2
where IdRole=8 and CodeModule='CRT'

update ROLE_RIGHTS
set IdPermission=2
where IdROle=8 and CodeModule in ( 'INI', 'REF', 'REV')
