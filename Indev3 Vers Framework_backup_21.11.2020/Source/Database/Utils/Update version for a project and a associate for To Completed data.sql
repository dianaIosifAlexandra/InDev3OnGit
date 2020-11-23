declare @IdAssociate int
declare @ProjectCode varchar(10)

-- This IdAssociate and ProjectCode must be provided by the operator
set @IdAssociate = 0
set @ProjectCode = ''

-- Code below must not be changed

declare @c1 int
declare @c2 int
declare @IdProject int

select @IdProject = Id from Projects where Code=@ProjectCode

if @IdProject is null
  begin
	Raiserror('Error: There is no project having provided project code', 16, 1) 
	return
  end

IF object_id(N'tempdb.dbo.#ReforecastVersionNo') IS not NULL 
	drop table #ReforecastVersionNo
	
CREATE TABLE #ReforecastVersionNo (BudgetVersion int, IsVersionActual int)
INSERT INTO #ReforecastVersionNo
	EXEC bgtGetReforecastVersionNo @IdProject, @Version = N'N'

DECLARE @IdGeneration int
SELECT @IdGeneration = BudgetVersion FROM #ReforecastVersionNo

SELECT @c1 = isnull(count(*),0)
	 FROM BUDGET_TOCOMPLETION_DETAIL
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociate

	
SELECT @c2 = isnull(count(*),0)
	 FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociate

if @c1 > 0 and @c2 > 0
BEGIN	
	Print 'This Associate has data with the last project version'
	RETURN
END

declare @IdOldGeneration int
select @IdOldGeneration = max(IdGeneration)
						  from BUDGET_TOCOMPLETION_DETAIL
						  where IdProject = @IdProject
						  AND IdAssociate = @IdAssociate
	
INSERT INTO BUDGET_TOCOMPLETION_PROGRESS (IdProject,IdGeneration,IdPhase,IdWorkPackage, IdAssociate, [Percent])
SELECT  BTP.IdProject,
		@IdGeneration,
		BTP.IdPhase,
		BTP.IdWorkPackage,
		BTP.IdAssociate,
		BTP.[Percent]
FROM 	BUDGET_TOCOMPLETION_PROGRESS BTP
INNER 	JOIN WORK_PACKAGES WP 
	ON	BTP.IdProject = WP.IdProject AND
		BTP.IdPhase = WP.IdPhase AND
		BTP.IdWorkPackage = WP.Id
INNER 	JOIN PROJECT_CORE_TEAMS PCT 
	ON	PCT.IdProject = BTP.IdProject AND
		PCT.IdAssociate = BTP.IdAssociate
WHERE	BTP.IdProject = @IdProject AND
		BTP.IdGeneration = @IdOldGeneration AND
		BTP.IdAssociate = @IdAssociate AND
		WP.IsActive = 1 AND 	--copy only active work packages
		PCT.IsActive = 1

if @c1 = 0 
	begin
	-- create data with last version from last existing version
		INSERT INTO BUDGET_TOCOMPLETION_DETAIL
			(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales)
		SELECT IdProject, @IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales
		FROM BUDGET_TOCOMPLETION_DETAIL
		WHERE IdProject = @IdProject
		  AND IdAssociate = @IdAssociate
		  AND IdGeneration = (select max(IdGeneration)
							  from BUDGET_TOCOMPLETION_DETAIL
							  where IdProject = @IdProject
							  AND IdAssociate = @IdAssociate)
	end


if @c2 = 0 
	begin
		INSERT INTO BUDGET_TOCOMPLETION_DETAIL_COSTS
			(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount)
		SELECT IdProject, @IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount
		FROM BUDGET_TOCOMPLETION_DETAIL_COSTS
		WHERE IdProject = @IdProject
		  AND IdAssociate = @IdAssociate
		  AND IdGeneration = (select max(IdGeneration)
							  from BUDGET_TOCOMPLETION_DETAIL_COSTS
							  where IdProject = @IdProject
							  AND IdAssociate = @IdAssociate)

	end

print 'Operation completed'

