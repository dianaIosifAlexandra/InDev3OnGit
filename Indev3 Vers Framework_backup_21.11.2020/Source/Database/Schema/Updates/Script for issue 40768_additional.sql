if object_id(N'tempdb.dbo.#temp_IdImport') is null create table #temp_IdImport (Id int identity, IdImport int)

declare @AccountNumber varchar(50),
	@IdSource int,
	@IdCostTypeHours int,
	@IdAccount int

set @AccountNumber = '43C11046A'
set @IdSource = 1
set @IdCostTypeHours = dbo.fnGetHoursCostTypeID()

select @IdAccount = Id from GL_ACCOUNTS where Account = @AccountNumber
--------------------------------------------------------------------------
DELETE ACTUAL_DATA_DETAILS_HOURS where IdAccount = @IdAccount
DELETE ACTUAL_DATA_DETAILS_SALES where IdAccount = @IdAccount
DELETE ACTUAL_DATA_DETAILS_COSTS where IdAccount = @IdAccount
--------------------------------------------------------------------------

declare @Application_Type_Name nvarchar(3)
select @Application_Type_Name = [NAME] 
from IMPORT_APPLICATION_TYPES IAT
inner join IMPORT_SOURCES [IS]
	on IAT.Id = [IS].IdApplicationTypes
where [IS].Id = @IdSource

--------------------------------------------------------------------------
--put in #temp_IdImport all Import Ids with AccountNumber = '43C11046A'
delete from #temp_IdImport
insert into #temp_IdImport (IdImport)
select distinct IMD.IdImport
from IMPORT_DETAILS IMD
inner join IMPORT_LOGS ILOGS
	on IMD.IdImport = ILOGS.IdImport
inner join PROJECTS P
	on IMD.ProjectCode = P.Code
inner join WORK_PACKAGES WP
	on WP.IdProject = P.ID and 
	   WP.Code = IMD.WPCode
inner join COUNTRIES C
	on IMD.Country = C.Code
inner join INERGY_LOCATIONS IL
	on C.Id = IL.IdCountry
inner join COST_CENTERS CC 
	on IL.Id = CC.IdInergyLocation and
	   IMD.CostCenter = CC.Code
inner join ASSOCIATES A
	on C.Id = A.IdCountry and
	   IMD.AssociateNumber = A.EmployeeNumber
where dbo.fnGetBudgetCostType(C.Id,IMD.AccountNumber) = @IdCostTypeHours 
	and IMD.AssociateNumber is not null 
	and IMD.AccountNumber = @AccountNumber
	and ILOGS.Validation = 'G'
order by IMD.IdImport

declare @NrRows int,
	@i int,
	@CurrentIdImport int

select @NrRows = max(Id) from #temp_IdImport
set @i = 1


begin transaction

--insert every IdImport separately
while @i <= @NrRows
begin
	select @CurrentIdImport = IdImport
	from #temp_IdImport
	where Id = @i

	insert into [ACTUAL_DATA_DETAILS_HOURS]
		([IdProject], [IdPhase], [IdWorkPackage], [IdCostCenter], 
		[YearMonth], [IdAssociate], [IdCountry], [IdAccount], 
		[HoursQty], [HoursVal], [DateImport], [IdImport])
	select	
		P.Id as IdProject, 
		WP.IdPhase as IdPhase, 
		WP.Id as IdWorkPackage, 
		CC.Id as IdCostCenter,
		ILOGS.YearMonth,
		A.Id as IdAssociate, 
		C.Id as IdCountry, 
		dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber) as IdAccount,
		isnull(IMD.Quantity,0) - isnull((select sum(isnull(ADH.HoursQty,0))
						from ACTUAL_DATA_DETAILS_HOURS ADH 
						where ADH.IdProject = WP.IdProject AND
						      ADH.IdPhase = WP.IdPhase AND
						      ADH.IdWorkPackage =WP.Id AND
						      ADH.IdCostCenter = CC.Id AND
						      ADH.YearMonth/100 = ILOGS.YearMonth/100 AND --check just year
						      ADH.IdAssociate = A.Id AND	
						      ADH.IdCountry = C.Id AND
						      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)), 0) as HoursQty,
	
		case when (@Application_Type_Name ='NET' AND IMD.Quantity <> 0)
		then dbo.fnGetValuedHours(CC.Id, 
			isnull(IMD.Quantity,0) - isnull((select sum(isnull(ADH.HoursQty,0)) 
							from ACTUAL_DATA_DETAILS_HOURS ADH 
							where ADH.IdProject = WP.IdProject AND
							      ADH.IdPhase = WP.IdPhase AND
							      ADH.IdWorkPackage =WP.Id AND
							      ADH.IdCostCenter = CC.Id AND
							      ADH.YearMonth/100 = ILOGS.YearMonth/100 AND --check just year
							      ADH.IdAssociate = A.Id AND	
							      ADH.IdCountry = C.Id AND
							      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)),0),ILOGS.YearMonth)
		else
		 	isnull(IMD.Value,0) - isnull((select (sum(isnull(ADH.HoursVal,0))) 
						  from ACTUAL_DATA_DETAILS_HOURS ADH 
						  where ADH.IdProject = WP.IdProject AND
						      ADH.IdPhase = Wp.IdPhase AND
						      ADH.IdWorkPackage =WP.Id AND
						      ADH.IdCostCenter = CC.Id AND
						      ADH.YearMonth/100 = ILOGS.YearMonth/100 AND --check just year
						      ADH.IdAssociate = A.Id AND			      
						      ADH.IdCountry = C.Id AND
						      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)),0)
		end as HoursVal,
		isnull(IMD.[Date], getdate()) as DateImport,
		IMD.IdImport
	from IMPORT_DETAILS IMD
	inner join IMPORT_LOGS ILOGS
		on IMD.IdImport = ILOGS.IdImport
	inner join PROJECTS P
		on IMD.ProjectCode = P.Code
	inner join WORK_PACKAGES WP
		on WP.IdProject = P.ID and 
		   WP.Code = IMD.WPCode
	inner join COUNTRIES C
		on IMD.Country = C.Code
	inner join INERGY_LOCATIONS IL
		on C.Id = IL.IdCountry
	inner join COST_CENTERS CC 
		on IL.Id = CC.IdInergyLocation and
		   IMD.CostCenter = CC.Code
	inner join ASSOCIATES A
		on C.Id = A.IdCountry and
		   IMD.AssociateNumber = A.EmployeeNumber
	WHERE  dbo.fnGetBudgetCostType(C.ID,IMD.AccountNumber) = @IdCostTypeHours 
		and IMD.AssociateNumber is not null 
		and IMD.AccountNumber = @AccountNumber
		and ILOGS.Validation = 'G'
		and IMD.IdImport = @CurrentIdImport

	if @@error <> 0
	begin
		goto err
	end

	set @i = @i + 1
end --end while


ok:	
	commit
	return

err:	
	rollback
	return

