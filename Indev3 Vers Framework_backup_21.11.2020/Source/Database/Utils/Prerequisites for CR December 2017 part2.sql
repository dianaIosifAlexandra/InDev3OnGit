  if not exists(select * from [BUDGET_STATES] where StateCode='U')
	  insert into [BUDGET_STATES]
	  select 'U', 'Uploaded'


