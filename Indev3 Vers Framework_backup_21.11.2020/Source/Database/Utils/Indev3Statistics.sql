select  p.Name as ProjectName, 
	p.Code as ProjectCode, 
	c.Name as CountryName, 
	a.Name as AssociateName, 
	a.EmployeeNumber as AssociateNumber, 
	pf.Name as FunctionName,
	case when pct.IsActive=1 then 'Yes' else 'No' end as IsActive
from PROJECT_CORE_TEAMS pct
inner join PROJECTS p
	on pct.IdProject = P.id
inner join ASSOCIATES a
	on pct.IdAssociate = a.Id
inner join COUNTRIES c
	on a.IdCountry = c.Id
inner join PROJECT_FUNCTIONS pf
	on pct.IdFunction = pf.Id
order by P.Name

select  p.Name as ProjectName, 
	p.Code as ProjectCode,
	(SELECT COUNT(*) 
	from PROJECT_CORE_TEAMS pct
	where pct.IdProject = P.id) as CoreTeamMembers,
	(SELECT COUNT(*) 
	from WORK_PACKAGES wp
	where wp.IdProject = P.id) as WPCount,
	(SELECT COUNT(*) 
	from WORK_PACKAGES wp
	where wp.IdProject = P.id and
	      wp.StartYearMonth is not null and
	      wp.EndYearMonth is not null) as WPCountWithTiming,
	(SELECT COUNT(*) from 
		(SELECT DISTINCT IdProject, IdPhase, IdWorkPackage 
		from PROJECTS_INTERCO pin
		where pin.IdProject = P.id) as a) as WPCountWithInterco
FROM PROJECTS p
order by P.Name


SELECT  p.Name as ProjectName, 
	p.Code as ProjectCode, 
	c.Name as CountryName, 
	a.Name as AssociateName, 
	a.EmployeeNumber as AssociateNumber,
	bs.Description as State,
	bis.StateDate as StateDate,
	(SELECT ISNULL(SUM (HoursQty),0) 
	FROM BUDGET_INITIAL_DETAIL bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdAssociate = bis.IdAssociate) as HoursQty,
	(SELECT ISNULL(SUM (HoursVal),0) 
	FROM BUDGET_INITIAL_DETAIL bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdAssociate = bis.IdAssociate) as HoursVal,
	(SELECT ISNULL(SUM (SalesVal),0) 
	FROM BUDGET_INITIAL_DETAIL bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdAssociate = bis.IdAssociate) as SalesVal,
	(SELECT ISNULL(SUM (CostVal),0) 
	FROM BUDGET_INITIAL_DETAIL_COSTS bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdAssociate = bis.IdAssociate) as CostVal
FROM BUDGET_INITIAL_STATES bis
inner join PROJECTS p
	on bis.IdProject = P.id
inner join ASSOCIATES a
	on bis.IdAssociate = a.Id
inner join COUNTRIES c
	on a.IdCountry = c.Id
inner join BUDGET_STATES bs
	on bis.state = bs.StateCode
order by P.Name


SELECT  p.Name as ProjectName, 
	p.Code as ProjectCode, 
	c.Name as CountryName, 
	a.Name as AssociateName, 
	a.EmployeeNumber as AssociateNumber,
	bis.IdGeneration as LastVersion,
	bs.Description as State,
	bis.StateDate as StateDate,
	(SELECT ISNULL(SUM (HoursQty),0) 
	FROM BUDGET_REVISED_DETAIL bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdGeneration = bis.IdGeneration and
	      bid.IdAssociate = bis.IdAssociate) as HoursQty,
	(SELECT ISNULL(SUM (HoursVal),0) 
	FROM BUDGET_REVISED_DETAIL bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdGeneration = bis.IdGeneration and
	      bid.IdAssociate = bis.IdAssociate) as HoursVal,
	(SELECT ISNULL(SUM (SalesVal),0) 
	FROM BUDGET_REVISED_DETAIL bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdGeneration = bis.IdGeneration and
	      bid.IdAssociate = bis.IdAssociate) as SalesVal,
	(SELECT ISNULL(SUM (CostVal),0) 
	FROM BUDGET_REVISED_DETAIL_COSTS bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdGeneration = bis.IdGeneration and
	      bid.IdAssociate = bis.IdAssociate) as CostVal
FROM BUDGET_REVISED_STATES bis
inner join PROJECTS p
	on bis.IdProject = P.id
inner join ASSOCIATES a
	on bis.IdAssociate = a.Id
inner join COUNTRIES c
	on a.IdCountry = c.Id
inner join BUDGET_STATES bs
	on bis.state = bs.StateCode
where bis.IdGeneration = (Select max(IdGeneration) 
			  from BUDGET_REVISED bd
			  where bis.IdProject = bd.IdProject)
order by P.Name



SELECT  p.Name as ProjectName, 
	p.Code as ProjectCode, 
	c.Name as CountryName, 
	a.Name as AssociateName, 
	a.EmployeeNumber as AssociateNumber,
	bis.IdGeneration as LastVersion,
	bs.Description as State,
	bis.StateDate as StateDate,
	(SELECT ISNULL(SUM (HoursQty),0) 
	FROM BUDGET_TOCOMPLETION_DETAIL bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdGeneration = bis.IdGeneration and
	      bid.IdAssociate = bis.IdAssociate) as HoursQty,
	(SELECT ISNULL(SUM (HoursVal),0) 
	FROM BUDGET_TOCOMPLETION_DETAIL bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdGeneration = bis.IdGeneration and
	      bid.IdAssociate = bis.IdAssociate) as HoursVal,
	(SELECT ISNULL(SUM (SalesVal),0) 
	FROM BUDGET_TOCOMPLETION_DETAIL bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdGeneration = bis.IdGeneration and
	      bid.IdAssociate = bis.IdAssociate) as SalesVal,
	(SELECT ISNULL(SUM (CostVal),0) 
	FROM BUDGET_TOCOMPLETION_DETAIL_COSTS bid
	WHERE bid.IdProject = bis.IdProject and
	      bid.IdGeneration = bis.IdGeneration and
	      bid.IdAssociate = bis.IdAssociate) as CostVal
FROM BUDGET_TOCOMPLETION_STATES bis
inner join PROJECTS p
	on bis.IdProject = P.id
inner join ASSOCIATES a
	on bis.IdAssociate = a.Id
inner join COUNTRIES c
	on a.IdCountry = c.Id
inner join BUDGET_STATES bs
	on bis.state = bs.StateCode
where bis.IdGeneration = (Select max(IdGeneration) 
			  from BUDGET_TOCOMPLETION bd
			  where bis.IdProject = bd.IdProject)
order by P.Name


/* check functionality phrases
SELECT ISNULL(SUM (CostVal),0) 
FROM BUDGET_REVISED_DETAIL_COSTS bid
where bid.IdGeneration = (Select max(IdGeneration) 
			  from BUDGET_REVISED bd
			  where bid.IdProject = bd.IdProject)

SELECT  ISNULL(SUM (HoursQty),0),
	ISNULL(SUM (HoursVal),0),
	ISNULL(SUM (SalesVal),0)
FROM BUDGET_REVISED_DETAIL bid
where bid.IdGeneration = (Select max(IdGeneration) 
			  from BUDGET_REVISED bd
			  where bid.IdProject = bd.IdProject)
*/