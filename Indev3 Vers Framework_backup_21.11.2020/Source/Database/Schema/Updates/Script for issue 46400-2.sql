if exists(select * from COST_INCOME_TYPES where DefaultAccount='10000007')
begin
  delete COST_INCOME_TYPES where DefaultAccount='10000007'
end
go

if exists(select * from COST_INCOME_TYPES where DefaultAccount='10000008')
begin
  delete COST_INCOME_TYPES where DefaultAccount='10000008'
end
go

if exists(select * from COST_INCOME_TYPES where DefaultAccount='10000009')
begin
  delete COST_INCOME_TYPES where DefaultAccount='10000009'
end
go