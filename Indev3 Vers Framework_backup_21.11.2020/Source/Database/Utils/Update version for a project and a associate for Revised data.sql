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

IF object_id(N'tempdb.dbo.#RevisedVersionNo') IS not NULL 
	drop table #RevisedVersionNo
	
CREATE TABLE #RevisedVersionNo (BudgetVersion int, IsVersionActual int)
INSERT INTO #RevisedVersionNo
	EXEC bgtGetRevisedVersionNo @IdProject, @Version = N'N'

DECLARE @IdGeneration int
SELECT @IdGeneration = BudgetVersion FROM #RevisedVersionNo

SELECT @c1 = isnull(count(*),0)
	 FROM BUDGET_REVISED_DETAIL
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociate

	
SELECT @c2 = isnull(count(*),0)
	 FROM BUDGET_REVISED_DETAIL_COSTS
	 WHERE IdProject = @IdProject
		AND IdGeneration = @IdGeneration
		AND IdAssociate = @IdAssociate

if @c1 > 0 and @c2 > 0
BEGIN	
	Print 'This Associate has data with the last project version'
	RETURN
END

if @c1 = 0 
	begin
	-- create data with last version from last existing version
		INSERT INTO BUDGET_REVISED_DETAIL
			(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales)
		SELECT IdProject, @IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, HoursQty, HoursVal, SalesVal, IdCountry, IdAccountHours, IdAccountSales
		FROM BUDGET_REVISED_DETAIL
		WHERE IdProject = @IdProject
		  AND IdAssociate = @IdAssociate
		  AND IdGeneration = (select max(IdGeneration)
							  from BUDGET_REVISED_DETAIL
							  where IdProject = @IdProject
							  AND IdAssociate = @IdAssociate)
	end


if @c2 = 0 
	begin
		INSERT INTO BUDGET_REVISED_DETAIL_COSTS
		(IdProject, IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount)
		SELECT IdProject, @IdGeneration, IdPhase, IdWorkPackage, IdCostCenter, IdAssociate, YearMonth, IdCostType, CostVal, IdCountry, IdAccount
		FROM BUDGET_REVISED_DETAIL_COSTS
		WHERE IdProject = @IdProject
		  AND IdAssociate = @IdAssociate
		  AND IdGeneration = (select max(IdGeneration)
							  from BUDGET_TOCOMPLETION_DETAIL_COSTS
							  where IdProject = @IdProject
							  AND IdAssociate = @IdAssociate)

	end

print 'Operation completed'


