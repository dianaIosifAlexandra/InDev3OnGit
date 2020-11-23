select addt.*
from actual_data_details addt
left join actual_data_detail_costs addc
	on addt.IdProject = addc.IdProject and
	   addt.IdPhase = addc.IdPhase and
	   addt.IdWorkPackage = addc.IdWorkPackage and
	   addt.IdCostCenter = addc. IdCostCenter and
	   addt.YearMonth = addc.YearMonth and
	   addt.IdAssociate = addc.IdAssociate
where addt.idAccountHours is null and
      addt.IdAccountSales is null and
      addc.IdAccount is null


delete addt
from actual_data_details addt
left join actual_data_detail_costs addc
	on addt.IdProject = addc.IdProject and
	   addt.IdPhase = addc.IdPhase and
	   addt.IdWorkPackage = addc.IdWorkPackage and
	   addt.IdCostCenter = addc. IdCostCenter and
	   addt.YearMonth = addc.YearMonth and
	   addt.IdAssociate = addc.IdAssociate
where addt.idAccountHours is null and
      addt.IdAccountSales is null and
      addc.IdAccount is null
