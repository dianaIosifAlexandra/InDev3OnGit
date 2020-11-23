--Drops the Procedure extExtractTrackingData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractTrackingData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractTrackingData
GO


create  PROCEDURE [dbo].extExtractTrackingData
@Year int,
@IdProgram int,
@IdProject int,
@IdRole int

as
if @IdProgram <= 0
  set @IdProgram = null

if @IdProject <= 0
   set @IdProject = null

select b. EmployeeNumber, b.Name, isnull(s.Name,'') as Role, isnull(c.Name,'') as ImpersonatedName, isnull(d.Name,'') as FunctionImpersonated,  isnull(p.Code,'') as ProjectCode, isnull(p.Name,'') as ProjectName,
k.ActionName as Action, isnull(cast(a.IdGeneration as varchar),'') as Version, a.LogDate as Date
from
TRACKING_ACTIVITY_LOG a
join Associates b on a.IdAssociate = b.ID
left join ROLES s on s.Id = a.IdRole
join TRACKING_ACTIONS k on a.IdAction = k.IdAction
left join Associates c on a.IdMemberImpersonated = c.Id
left join PROJECT_FUNCTIONS d on a.IdFunctionImpersonated = d.Id
left join PROJECTS p on a.IdProject = p.Id
where 
year(a.LogDate) = @Year
and p.IdProgram = case when @IdProgram is null then p.IdProgram else @IdProgram end
and p.Id = case when @IdProject is null then p.Id else @IdProject end
and isnull(a.IdRole,0) = case when @IdRole <= 0 then a.IdRole else @IdRole end
order by Logdate


go

