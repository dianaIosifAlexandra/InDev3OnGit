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
	print 'Script completed'
	goto final

ex:
   print 'there was on error during the execution. No data was changed.'

final:
	return
