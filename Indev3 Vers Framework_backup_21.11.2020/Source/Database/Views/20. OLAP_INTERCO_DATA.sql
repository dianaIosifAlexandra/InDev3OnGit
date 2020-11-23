IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'dbo.OLAP_INTERCO_DATA') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_INTERCO_DATA
GO

CREATE VIEW OLAP_INTERCO_DATA
AS

SELECT BTD.IdProject,
	BTD.IdPhase,
	BTD.IdWorkPackage,
	BTD.IdCostCenter,
	BTD.IdAssociate,
	BTD.YearMonth,
	BTD.HoursQty,
	BTD.HoursVal,
	BTD.Cost,
	BTD.Sales,
	BTD.CostTypeId,
	CAST(BTP.[Percent]/100 as decimal (18,2)) as Progress, --convert percent to standard percent which has max 1.
	CAST(4 as int) as CategoryId --Select Id FROM OLAP_CATEGORIES where Name = 'Reforecast Budget'
FROM OLAP_REFORECAST_DATA BTD
LEFT JOIN BUDGET_TOCOMPLETION_PROGRESS BTP
	on BTD.IdProject = BTP.IdProject and
	   dbo.fnGetToCompletionBudgetGeneration(BTP.IdProject, 'C') = BTP.IdGeneration and
	   BTD.IdPhase = BTP.IdPhase and
	   BTD.IdWorkPackage = BTP.IdWorkPackage and
	   BTD.IdAssociate = BTP.IdAssociate
UNION ALL
SELECT ATD.IdProject,
	ATD.IdPhase,
	ATD.IdWorkPackage,
	ATD.IdCostCenter,
	ATD.IdAssociate,
	ATD.YearMonth,
	ATD.HoursQty,
	ATD.HoursVal,
	ATD.Cost,
	ATD.Sales,
	ATD.CostTypeId,
	CAST(NULL as decimal (18,2)) as Progress, --we do not have progress in Revised Budget
	CAST(1 as int) as CategoryId --Select Id FROM OLAP_CATEGORIES where Name = 'Actual Data'
FROM OLAP_ACTUAL_DATA ATD
UNION ALL
SELECT ABT.IdProject,
	ABT.IdPhase,
	ABT.IdWorkPackage,
	ABT.IdCostCenter,
	ABT.IdAssociate,
	ABT.YearMonth,
	ABT.HoursQty,
	ABT.HoursVal,
	ABT.Cost,
	ABT.Sales,
	ABT.CostTypeId,
	CAST(NULL as decimal (18,2)) as Progress, --we do not have progress in Revised Budget
	CAST(2 as int) as CategoryId --Select Id FROM OLAP_CATEGORIES where Name = 'Annual Budget'
FROM OLAP_ANNUAL_BUDGET_DATA ABT
GO
