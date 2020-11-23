declare @AccountNumber varchar(50),
	@IdSource int,
	@IdCostTypeHours int,
	@IdAccount int

set @AccountNumber = '43C11046A'
set @IdSource = 1
set @IdCostTypeHours = dbo.fnGetHoursCostTypeID()

select @IdAccount = Id from GL_ACCOUNTS where Account = @AccountNumber
-------------------------------------------

update GL_ACCOUNTS
set IdCostType = @IdCostTypeHours
where Id = @IDAccount
-------------------------------------------

DELETE ACTUAL_DATA_DETAILS_HOURS where IdAccount = @IdAccount
DELETE ACTUAL_DATA_DETAILS_SALES where IdAccount = @IdAccount
DELETE ACTUAL_DATA_DETAILS_COSTS where IdAccount = @IdAccount
-------------------------------------------


DECLARE @Application_Type_Name NVARCHAR(3)
SELECT @Application_Type_Name = [NAME] 
FROM IMPORT_APPLICATION_TYPES IAT
INNER JOIN IMPORT_SOURCES [IS]
	ON IAT.Id = [IS].IdApplicationTypes
WHERE [IS].Id = @IdSource


-------------------------------------------
INSERT INTO [ACTUAL_DATA_DETAILS_HOURS]
	([IdProject], [IdPhase], [IdWorkPackage], [IdCostCenter], 
	[YearMonth], [IdAssociate], [IdCountry], [IdAccount], 
	[HoursQty], [HoursVal], [DateImport], [IdImport])
SELECT	
	P.Id as IdProject, 
	WP.IdPhase as IdPhase, 
	WP.Id as IdWorkPackage, 
	CC.Id as IdCostCenter,
	ILOGS.YearMonth,
	A.Id as IdAssociate, 
	C.Id as IdCountry, 
	dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber) as IdAccount,
	ISNULL(IMD.Quantity,0) - ISNULL((SELECT SUM(ISNULL(ADH.HoursQty,0))
					FROM ACTUAL_DATA_DETAILS_HOURS ADH 
					WHERE ADH.IdProject = WP.IdProject AND
					      ADH.IdPhase = WP.IdPhase AND
					      ADH.IdWorkPackage =WP.Id AND
					      ADH.IdCostCenter = CC.Id AND
					      ADH.YearMonth/100 = ILOGS.YearMonth/100 AND --check just year
					      ADH.IdAssociate = A.Id AND	
					      ADH.IdCountry = C.Id AND
					      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)), 0) as HoursQty,

	CASE WHEN (@Application_Type_Name ='NET' AND IMD.Quantity <> 0)
	THEN dbo.fnGetValuedHours(CC.Id, 
		ISNULL(IMD.Quantity,0) - ISNULL((SELECT SUM(ISNULL(ADH.HoursQty,0)) 
						FROM ACTUAL_DATA_DETAILS_HOURS ADH 
						WHERE ADH.IdProject = WP.IdProject AND
						      ADH.IdPhase = WP.IdPhase AND
						      ADH.IdWorkPackage =WP.Id AND
						      ADH.IdCostCenter = CC.Id AND
						      ADH.YearMonth/100 = ILOGS.YearMonth/100 AND --check just year
						      ADH.IdAssociate = A.Id AND	
						      ADH.IdCountry = C.Id AND
						      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)),0),ILOGS.YearMonth)
	ELSE
	 ISNULL(IMD.Value,0) - ISNULL((SELECT (SUM(ISNULL(ADH.HoursVal,0))) 
					  FROM ACTUAL_DATA_DETAILS_HOURS ADH 
					  WHERE ADH.IdProject = WP.IdProject AND
					      ADH.IdPhase = Wp.IdPhase AND
					      ADH.IdWorkPackage =WP.Id AND
					      ADH.IdCostCenter = CC.Id AND
					      ADH.YearMonth/100 = ILOGS.YearMonth/100 AND --check just year
					      ADH.IdAssociate = A.Id AND			      
					      ADH.IdCountry = C.Id AND
					      ADH.IdAccount = dbo.fnGetActualDetailIdAccount(C.Id,IMD.AccountNumber)),0)
	END as HoursVal,
	ISNULL(IMD.[Date], GETDATE()) as DateImport,
	IMD.IdImport

FROM IMPORT_DETAILS IMD
INNER JOIN IMPORT_LOGS ILOGS
	ON IMD.IdImport = ILOGS.IdImport
INNER JOIN PROJECTS P
	ON IMD.ProjectCode = P.Code
INNER JOIN WORK_PACKAGES WP
	ON WP.IdProject = P.ID AND 
	   WP.Code = IMD.WPCode
INNER JOIN COUNTRIES C
	ON IMD.Country = C.Code
INNER JOIN INERGY_LOCATIONS IL
	ON C.Id = IL.IdCountry
INNER JOIN COST_CENTERS CC 
	ON IL.Id = CC.IdInergyLocation and
	   IMD.CostCenter = CC.Code
INNER JOIN ASSOCIATES A
	ON C.Id = A.IdCountry AND
	   IMD.AssociateNumber = A.EmployeeNumber
WHERE  dbo.fnGetBudgetCostType(C.ID,IMD.AccountNumber) = @IdCostTypeHours 
	AND IMD.AssociateNumber IS NOT NULL 
	AND IMD.AccountNumber = @AccountNumber
	AND ILOGS.Validation = 'G'
order by IMD.IdImport

GO

