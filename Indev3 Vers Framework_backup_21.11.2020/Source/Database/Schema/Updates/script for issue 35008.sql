begin tran

DELETE A
FROM ACTUAL_DATA_DETAILS_HOURS A
WHERE HoursQty = 0 AND
      HoursVal = 0 AND
       (((Select SUM(HoursQty)
	    from ACTUAL_DATA_DETAILS_HOURS
	    Where IdProject = A.IdProject AND 
		  IdPhase = A.IdPhase AND 
		  IdWorkPackage = A.IdWorkPackage AND
		  IdCostCenter = A.IdCostCenter AND
		  IdAssociate = A.IdAssociate AND
		  IdCountry = A.IdCountry AND
		  IdAccount = A.IdAccount AND
		  YearMonth/100 = A.YearMonth/100 AND
		  YearMonth < A.YearMonth) IS NOT NULL) OR
      ((Select SUM(HoursVal)
	    from ACTUAL_DATA_DETAILS_HOURS
	    Where IdProject = A.IdProject AND 
		  IdPhase = A.IdPhase AND 
		  IdWorkPackage = A.IdWorkPackage AND
		  IdCostCenter = A.IdCostCenter AND
		  IdAssociate = A.IdAssociate AND
		  IdCountry = A.IdCountry AND
		  IdAccount = A.IdAccount AND
		  YearMonth/100 = A.YearMonth/100 AND
		  YearMonth < A.YearMonth) IS NOT NULL))
SELECT @@ROWCOUNT as RowsDeletedHours


DELETE A
FROM ACTUAL_DATA_DETAILS_COSTS A
WHERE CostVal = 0 AND
      (SELECT SUM(CostVal)
	  FROM ACTUAL_DATA_DETAILS_COSTS
	  WHERE IdProject = A.IdProject AND 
			  IdPhase = A.IdPhase AND 
			  IdWorkPackage = A.IdWorkPackage AND
			  IdCostCenter = A.IdCostCenter AND
			  IdAssociate = A.IdAssociate AND
			  IdCountry = A.IdCountry AND
			  IdAccount = A.IdAccount AND
			  YearMonth/100 = A.YearMonth/100 AND
			  YearMonth < A.YearMonth) IS NOT NULL
SELECT @@ROWCOUNT as RowsDeletedCosts

 

DELETE A
FROM ACTUAL_DATA_DETAILS_SALES A
WHERE SalesVal = 0 AND
      (SELECT SUM(SalesVal)
	  FROM ACTUAL_DATA_DETAILS_SALES
	  WHERE IdProject = A.IdProject AND 
			  IdPhase = A.IdPhase AND 
			  IdWorkPackage = A.IdWorkPackage AND
			  IdCostCenter = A.IdCostCenter AND
			  IdAssociate = A.IdAssociate AND
			  IdCountry = A.IdCountry AND
			  IdAccount = A.IdAccount AND
			  YearMonth/100 = A.YearMonth/100 AND
			  YearMonth < A.YearMonth) IS NOT NULL
SELECT @@ROWCOUNT as RowsDeletedSales

COMMIT


