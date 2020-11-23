-------------------------------------------------------------------------------------------------------
/* Set the parameter values in order to narrow the search */

DECLARE @IdProject 	INT,
	@IdGeneration 	INT,
	@IdPhase 	INT,
	@IdWorkPackage	INT,
	@IdCostCenter	INT,
	@IdAssociate	INT

SET @IdProject 		= NULL
SET @IdGeneration 	= NULL
SET @IdPhase 		= NULL
SET @IdWorkPackage	= NULL
SET @IdCostCenter	= NULL
SET @IdAssociate	= NULL
-------------------------------------------------------------------------------------------------------
CREATE TABLE #CheckPeriods
(
	IdProject 			INT NOT NULL,
	IdGeneration			INT NOT NULL,
	IdPhase 			INT NOT NULL,
	IdWorkPackage			INT NOT NULL,
	IdCostCenter			INT NOT NULL,
	IdAssociate			INT NOT NULL,
	BudgetRevisedDetailMonths	INT NOT NULL,
	WorkPackageMonths		INT NOT NULL
	PRIMARY KEY (IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate)
)

INSERT INTO #CheckPeriods
(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, BudgetRevisedDetailMonths, WorkPackageMonths)
SELECT 	BRD.IdProject,
	BRD.IdGeneration,
	BRD.IdPhase,
	BRD.IdWorkPackage, 
	BRD.IdCostCenter,
	BRD.IdAssociate,
	BRD.BudgetRevisedDetailMonths,
	((WP.EndYearMonth/100 - WP.StartYearMonth/100)*12 + (WP.EndYearMonth%100 - WP.StartYearMonth%100)+1)
FROM
(
	SELECT 	IdProject,
		IdGeneration,
		IdPhase,
		IdWorkPackage,
		IdCostCenter,
		IdAssociate,
		COUNT(*) AS BudgetRevisedDetailMonths
	FROM BUDGET_REVISED_DETAIL
	WHERE 	(IdProject = @IdProject OR @IdProject IS NULL) AND
		(IdGeneration = @IdGeneration OR @IdGeneration IS NULL) AND
		(IdPhase = @IdPhase OR @IdPhase IS NULL) AND
		(IdWorkPackage = @IdWorkPackage OR @IdWorkPackage IS NULL) AND
		(IdCostCenter = @IdCostCenter OR @IdCostCenter IS NULL) AND
		(IdAssociate = @IdAssociate OR @IdAssociate IS NULL)
	GROUP BY IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate
) BRD
INNER JOIN WORK_PACKAGES WP
	ON WP.IdProject = BRD.IdProject AND
	   WP.IdPhase = BRD.IdPhase AND
	   WP.Id = BRD.IdWorkPackage

select * from #CheckPeriods where BudgetRevisedDetailMonths <> WorkPackageMonths

drop table #CheckPeriods


