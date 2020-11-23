ALTER TABLE TRACKING_ACTIVITY_LOG
ALTER COLUMN IdRole INT null

go

if not exists(select * from [IMPORT_SOURCES] where Code = 'SAPROM')
begin
	declare @id int 
	declare @rank int
	select @id = max(id) from [IMPORT_SOURCES]
	select @rank = max([rank])  from [IMPORT_SOURCES]
	set @id = @id + 1
	set @rank = @rank + 1

	insert into [IMPORT_SOURCES]
	(Id, IdApplicationTypes, Code, SourceName, Active, [Rank])
	select @id, 1, 'SAPROM', 'Romania', 1, @rank
end

go

if (select count(*) from [IMPORT_SOURCES] where Code = 'SAPROM') > 1
begin 
	declare @id int
	select @id = min(Id) from [IMPORT_SOURCES] where Code = 'SAPROM'
	delete [IMPORT_SOURCES] where Code = 'SAPROM'
	and Id > @id
end
go

if not exists(select * from IMPORT_SOURCES_COUNTRIES where IdImportSource = (select Id from IMPORT_SOURCES where Code='SAPROM'))
insert into IMPORT_SOURCES_COUNTRIES
select (select Id from IMPORT_SOURCES where Code='SAPROM'), (select Id from Countries where Name='Romania')

go