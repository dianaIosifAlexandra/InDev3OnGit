
--Create totals table (without costs)
CREATE TABLE #Totals
(
	IdProject 		INT NOT NULL,
	IdGeneration		INT NOT NULL,
	IdPhase 		INT NOT NULL,
	IdWorkPackage		INT NOT NULL,
	IdCostCenter		INT NOT NULL,
	IdAssociate		INT NOT NULL,
	YearMonth		INT NOT NULL,
	HoursQty		INT,
	HoursVal		INT,
	SalesVal		INT,
	IdCountry		INT NOT NULL,
	IdAccountHours		INT NOT NULL,
	IdAccountSales		INT NOT NULL
	PRIMARY KEY (IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth)
)

--Create total costs table
CREATE TABLE #TotalCosts
(
	IdProject 		INT NOT NULL,
	IdGeneration		INT NOT NULL,
	IdPhase 		INT NOT NULL,
	IdWorkPackage		INT NOT NULL,
	IdCostCenter		INT NOT NULL,
	IdAssociate		INT NOT NULL,
	YearMonth		INT NOT NULL,
	IdCostType 		INT NOT NULL,
	CostVal			INT,
	IdCountry 		INT NOT NULL,
	IdAccount		INT NOT NULL
	PRIMARY KEY (IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, IdCostType)
)

--Create ToCompletion progress table
CREATE TABLE #Progress
(
	IdProject 		INT NOT NULL,
	IdGeneration		INT NOT NULL,
	IdPhase 		INT NOT NULL,
	IdWorkPackage		INT NOT NULL,
	IdAssociate		INT NOT NULL,
	[Percent]		DECIMAL(9)
	PRIMARY KEY (IdProject, IdGeneration, IdPhase, IdWorkPackage, IdAssociate)
)

--Create ToCompletion states table
CREATE TABLE #States
(
	IdProject 		INT NOT NULL,
	IdGeneration		INT NOT NULL,
	IdAssociate		INT NOT NULL,
	State			CHAR(1) NOT NULL,
	StateDate		SMALLDATETIME NOT NULL
	PRIMARY KEY (IdProject, IdGeneration, IdAssociate)
)



/****************************** REFORECAST BUDGET ******************************/

DELETE FROM #Totals
DELETE FROM #TotalCosts


INSERT INTO #Totals 
(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales)
SELECT 	BCD.IdProject,
	BCD.IdGeneration, 
	BCD.IdPhase, 
	BCD.IdWorkPackage, 
	BCD.IdCostCenter, 
	BCD.IdAssociate, 
	BCD.YearMonth, 
	BCD.HoursQty, 
	BCD.HoursVal, 
	BCD.SalesVal, 
	BCD.IdCountry, 
	BCD.IdAccountHours, 
	BCD.IdAccountSales
FROM BUDGET_TOCOMPLETION_DETAIL BCD
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BCD.IdProject AND
	   PCT.IdAssociate = BCD.IdAssociate
WHERE PCT.IsActive = 0 -- only data that belong to inactive core team members

INSERT INTO #TotalCosts
(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount)
SELECT 	BCDC.IdProject,
	BCDC.IdGeneration, 
	BCDC.IdPhase, 
	BCDC.IdWorkPackage, 
	BCDC.IdCostCenter, 
	BCDC.IdAssociate, 
	BCDC.YearMonth, 
	BCDC.IdCostType, 
	BCDC.CostVal, 
	BCDC.IdCountry, 
	BCDC.IdAccount
FROM BUDGET_TOCOMPLETION_DETAIL_COSTS BCDC
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BCDC.IdProject AND
	   PCT.IdAssociate = BCDC.IdAssociate
WHERE PCT.IsActive = 0 -- only data that belong to inactive core team members

INSERT INTO #Progress
(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdAssociate, [Percent])
SELECT	BCP.IdProject, 
	BCP.IdGeneration, 
	BCP.IdPhase, 
	BCP.IdWorkPackage, 
	BCP.IdAssociate, 
	BCP.[Percent]
FROM BUDGET_TOCOMPLETION_PROGRESS BCP
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BCP.IdProject AND
	   PCT.IdAssociate = BCP.IdAssociate
WHERE PCT.IsActive = 0 -- only data that belong to inactive core team members

INSERT INTO #States
(IdProject, IdGeneration, IdAssociate, State, StateDate)
SELECT 	BCS.IdProject, 
	BCS.IdGeneration, 
	BCS.IdAssociate, 
	BCS.State, 
	BCS.StateDate
FROM BUDGET_TOCOMPLETION_STATES BCS
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BCS.IdProject AND
	   PCT.IdAssociate = BCS.IdAssociate
WHERE PCT.IsActive = 0 -- only data that belong to inactive core team members
-------------------------------------------------------------------------------------


DELETE BCDC
FROM BUDGET_TOCOMPLETION_DETAIL_COSTS BCDC
INNER JOIN #TotalCosts tc
	ON tc.IdProject = BCDC.IdProject AND
	   tc.IdGeneration = BCDC.IdGeneration AND
	   tc.IdPhase = BCDC.IdPhase AND
	   tc.IdWorkPackage = BCDC.IdWorkPackage AND
	   tc.IdCostCenter = BCDC.IdCostCenter AND
	   tc.YearMonth = BCDC.YearMonth AND
	   tc.IdCostType = BCDC.IdCostType AND
	   tc.CostVal = BCDC.CostVal AND
	   tc.IdCountry = BCDC.IdCountry AND
	   tc.IdAccount = BCDC.IdAccount
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BCDC.IdProject AND
	   PCT.IdAssociate = BCDC.IdAssociate
WHERE PCT.IsActive = 1

DELETE BCD
FROM BUDGET_TOCOMPLETION_DETAIL BCD
INNER JOIN #Totals t
	ON t.IdProject = BCD.IdProject AND
	   t.IdGeneration = BCD.IdGeneration AND
	   t.IdPhase = BCD.IdPhase AND
	   t.IdWorkPackage = BCD.IdWorkPackage AND
	   t.IdCostCenter = BCD.IdCostCenter AND
	   t.YearMonth = BCD.YearMonth AND
	   t.HoursQty = BCD.HoursQty AND
	   t.HoursVal = BCD.HoursVal AND
	   t.SalesVal = BCD.SalesVal AND
	   t.IdCountry = BCD.IdCountry AND
	   t.IdAccountHours = BCD.IdAccountHours AND
	   t.IdAccountSales = BCD.IdAccountSales
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BCD.IdProject AND
	   PCT.IdAssociate = BCD.IdAssociate
WHERE PCT.IsActive = 1

DELETE BCP
FROM BUDGET_TOCOMPLETION_PROGRESS BCP
INNER JOIN #Progress p
	ON p.IdProject = BCP.IdProject AND
	   p.IdGeneration = BCP.IdGeneration AND
	   p.IdPhase = BCP.IdPhase AND
	   p.IdWorkPackage = BCP.IdWorkPackage AND
	   p.[Percent] = BCP.[Percent]
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BCP.IdProject AND
	   PCT.IdAssociate = BCP.IdAssociate
WHERE PCT.IsActive = 1

DELETE BCS
FROM BUDGET_TOCOMPLETION_STATES BCS
INNER JOIN #States s
	ON s.IdProject = BCS.IdProject AND
	   s.IdGeneration = BCS.IdGeneration AND
	   s.State = BCS.State AND
	   s.StateDate = BCS.StateDate
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BCS.IdProject AND
	   PCT.IdAssociate = BCS.IdAssociate	
WHERE PCT.IsActive = 1

/****************************** END REFORECAST BUDGET ******************************/



/****************************** REVISED BUDGET ******************************/

DELETE FROM #Totals
DELETE FROM #TotalCosts


INSERT INTO #Totals 
(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales)
SELECT 	BRD.IdProject,
	BRD.IdGeneration, 
	BRD.IdPhase, 
	BRD.IdWorkPackage, 
	BRD.IdCostCenter, 
	BRD.IdAssociate, 
	BRD.YearMonth, 
	BRD.HoursQty, 
	BRD.HoursVal, 
	BRD.SalesVal, 
	BRD.IdCountry, 
	BRD.IdAccountHours, 
	BRD.IdAccountSales
FROM BUDGET_REVISED_DETAIL BRD
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BRD.IdProject AND
	   PCT.IdAssociate = BRD.IdAssociate
WHERE PCT.IsActive = 0 -- only data that belong to inactive core team members

INSERT INTO #TotalCosts
(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount)
SELECT 	BRDC.IdProject,
	BRDC.IdGeneration, 
	BRDC.IdPhase, 
	BRDC.IdWorkPackage, 
	BRDC.IdCostCenter, 
	BRDC.IdAssociate, 
	BRDC.YearMonth, 
	BRDC.IdCostType, 
	BRDC.CostVal, 
	BRDC.IdCountry, 
	BRDC.IdAccount
FROM BUDGET_REVISED_DETAIL_COSTS BRDC
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BRDC.IdProject AND
	   PCT.IdAssociate = BRDC.IdAssociate
WHERE PCT.IsActive = 0 -- only data that belong to inactive core team members
-------------------------------------------------------------------------------------


DELETE BRDC
FROM BUDGET_REVISED_DETAIL_COSTS BRDC
INNER JOIN #TotalCosts tc
	ON tc.IdProject = BRDC.IdProject AND
	   tc.IdGeneration = BRDC.IdGeneration AND
	   tc.IdPhase = BRDC.IdPhase AND
	   tc.IdWorkPackage = BRDC.IdWorkPackage AND
	   tc.IdCostCenter = BRDC.IdCostCenter AND
	   tc.YearMonth = BRDC.YearMonth AND
	   tc.IdCostType = BRDC.IdCostType AND
	   tc.CostVal = BRDC.CostVal AND
	   tc.IdCountry = BRDC.IdCountry AND
	   tc.IdAccount = BRDC.IdAccount
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BRDC.IdProject AND
	   PCT.IdAssociate = BRDC.IdAssociate
WHERE PCT.IsActive = 1

DELETE BRD
FROM BUDGET_REVISED_DETAIL BRD
INNER JOIN #Totals t
	ON t.IdProject = BRD.IdProject AND
	   t.IdGeneration = BRD.IdGeneration AND
	   t.IdPhase = BRD.IdPhase AND
	   t.IdWorkPackage = BRD.IdWorkPackage AND
	   t.IdCostCenter = BRD.IdCostCenter AND
	   t.YearMonth = BRD.YearMonth AND
	   t.HoursQty = BRD.HoursQty AND
	   t.HoursVal = BRD.HoursVal AND
	   t.SalesVal = BRD.SalesVal AND
	   t.IdCountry = BRD.IdCountry AND
	   t.IdAccountHours = BRD.IdAccountHours AND
	   t.IdAccountSales = BRD.IdAccountSales
INNER JOIN PROJECT_CORE_TEAMS PCT
	ON PCT.IdProject = BRD.IdProject AND
	   PCT.IdAssociate = BRD.IdAssociate
WHERE PCT.IsActive = 1

/****************************** END REVISED BUDGET ******************************/


DROP TABLE #Totals
DROP TABLE #TotalCosts
DROP TABLE #Progress
DROP TABLE #States


--------------------------------------------------------------------------------------------------------------
-- fix data for the case described in issue #0045161
DECLARE @IdProject INT,
	@IdAssociate INT
SET @IdProject = 1180
SET @IdAssociate = 345
-------------------------------------------------------

DELETE 
FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
WHERE IdProject = @IdProject
  AND IdAssociate = @IdAssociate

DELETE
FROM BUDGET_TOCOMPLETION_DETAIL
WHERE IdProject = @IdProject
  AND IdAssociate = @IdAssociate

DELETE
FROM BUDGET_TOCOMPLETION_PROGRESS
WHERE IdProject = @IdProject
  AND IdAssociate = @IdAssociate

DELETE
FROM BUDGET_REVISED_DETAIL_COSTS
WHERE IdProject = @IdProject
  AND IdAssociate = @IdAssociate 

DELETE
FROM BUDGET_REVISED_DETAIL 
WHERE IdProject = @IdProject
  AND IdAssociate = @IdAssociate
--------------------------------------------------------------------------------------------------------------
