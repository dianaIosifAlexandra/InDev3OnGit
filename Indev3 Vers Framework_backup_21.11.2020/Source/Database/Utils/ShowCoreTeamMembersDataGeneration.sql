declare @ProjectCode varchar(10)

-- this must be filled in by the user
set @ProjectCode = '' 



declare @IdProject int
select @IdProject = Id from Projects where Code=@ProjectCode

IF OBJECT_ID('tempdb..#ReforecastVersionNo') IS NOT NULL DROP TABLE #ReforecastVersionNo

CREATE TABLE #ReforecastVersionNo (BudgetVersion int, IsVersionActual int)
INSERT INTO #ReforecastVersionNo
	EXEC bgtGetReforecastVersionNo @IdProject, @Version = N'N'

IF OBJECT_ID('tempdb..#RevisedVersionNo') IS NOT NULL DROP TABLE #RevisedVersionNo
CREATE TABLE #RevisedVersionNo (BudgetVersion int, IsVersionActual int)
INSERT INTO #RevisedVersionNo
	EXEC bgtGetRevisedVersionNo @IdProject, @Version = N'N'
	

select a.IdAssociate, d.Name, c.Name as [Function], a.IsActive, isnull(max(f.IdGeneration),0) as Associate_Revised_IdGeneration, w.BudgetVersion as Revised_BudgetVersion, isnull(max(e.IdGeneration),0) as  Associate_Reforecast_IdGeneration, v.BudgetVersion as  Reforecast_BudgetVersion
from PROJECT_CORE_TEAMS a
join PROJECTS b on a.IdProject = b.Id
join FUNCTIONS c on a.IdFunction = c.Id
join ASSOCIATES d on a.IdAssociate = d.Id
left join BUDGET_TOCOMPLETION_DETAIL e on a.IdAssociate = e.IdAssociate and a.IdProject = e.IdProject
left join BUDGET_REVISED_DETAIL f on a.IdAssociate = f.IdAssociate and a.IdProject = f.IdProject
cross join #ReforecastVersionNo v 
cross join #RevisedVersionNo w
where b.Code = @ProjectCode
group by a.IdAssociate, d.Name, c.Name, a.IsActive, v.BudgetVersion, v.IsVersionActual, w.BudgetVersion 
