declare @Year int
set @Year = 2016

delete a
from ANNUAL_BUDGET_DATA_DETAILS_SALES a
join ANNUAL_BUDGET_IMPORT_LOGS b on a.IdImport = b.IdImport 
where b.[Year]=@Year

delete a
from ANNUAL_BUDGET_DATA_DETAILS_COSTS a
join ANNUAL_BUDGET_IMPORT_LOGS b on a.IdImport = b.IdImport 
where b.[Year]=@Year

delete a
from ANNUAL_BUDGET_DATA_DETAILS_HOURS a
join ANNUAL_BUDGET_IMPORT_LOGS b on a.IdImport = b.IdImport 
where b.[Year]=@Year
