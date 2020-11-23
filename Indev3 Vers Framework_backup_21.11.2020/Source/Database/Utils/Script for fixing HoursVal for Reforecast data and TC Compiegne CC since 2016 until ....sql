begin tran

update a
set HoursVal =  HoursQty * d.HourlyRate
from BUDGET_TOCOMPLETION_DETAIL a
join
(
select IdProject, max(IdGeneration) as IdGeneration 
from BUDGET_TOCOMPLETION_DETAIL
group by IdProject
) b on a.IdProject = b.IdProject
join COST_CENTERS c on a.IdCostCenter = c.Id
join HOURLY_RATES d on c.Id = d.IdCostCenter and a.YearMonth = d.YearMonth
where isnull(HoursQty,0) <> 0
and HoursVal <> 0
and HoursVal / HoursQty < 1
and c.IdInergyLocation = 1

if @@error <> 0
  goto ex
  
update a
set HoursVal = HoursQty * dbo.fnGetHourlyRate(a.IdCostCenter, a.YearMonth)
from BUDGET_TOCOMPLETION_DETAIL a
join COST_CENTERS c on a.IdCostCenter = c.Id
where isnull(HoursQty,0) <> 0
and HoursVal <> 0
and HoursVal / HoursQty < 1
and c.IdInergyLocation = 1
and a.YearMonth >= 201701


if @@error <> 0
  goto ex

ok:
	commit
	print 'Script completed'
	goto final

ex:
   rollback
   print 'there was an error during the execution. No data was changed.'

final:
	return
  

