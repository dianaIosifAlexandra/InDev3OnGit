if not exists(select * from [IMPORT_SOURCES] where SourceName = 'SAPROM')
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
