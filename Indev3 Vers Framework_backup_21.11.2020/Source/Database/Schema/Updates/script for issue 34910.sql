--this script moves data from associates with EmployeeNumber=0 onto the null associates fot he country eand then renames the anull --associates of the country to have the EmployeeNumber=0

BEGIN TRAN

--IdProject, IdPhase, IdWorkPackage, IdCostCenter, YearMonth, IdAssociate, IdCountry, IdAccount
DECLARE @RowsUpdated	int,
		@RowsInserted	int,
		@RowsDeleted	int

DECLARE @HoursQty		decimal (12,2),
		@HoursVal		decimal (18,2)

SELECT @RowsInserted = 0,
	   @RowsUpdated = 0,
	   @RowsDeleted = 0

DECLARE @IdProject int, 
		@IdPhase int, 
		@IdWorkPackage int, 
		@IdCostCenter int, 
		@YearMonth int, 
		@IdAssociate int, 
		@IdCountry int, 
		@IdAccount int
DECLARE @NewIdAssociate int

DECLARE @SumHoursFrom table
(
	IdCountry	int not null,
	IdAssociate int not null,
	HoursQTY decimal (12,2),
	HoursVal decimal (18,2)
)

DECLARE @SumHoursTo table
(
	IdCountry	int not null,
	IdAssociate int not null,
	HoursQTY decimal (12,2),
	HoursVal decimal (18,2)
)

insert into @SumHoursFrom
SELECT  a.IdCountry,
		a.Id,
	   (SELECT SUM(ad.HoursQty) FROM ACTUAL_DATA_DETAILS_HOURS ad WHERE IdAssociate=a.Id) as SumHoursQty, 
	   (SELECT SUM(ad.HoursVal) FROM ACTUAL_DATA_DETAILS_HOURS ad WHERE IdAssociate=a.Id) as SumHoursVal
FROM ASSOCIATES a
WHERE a.EmployeeNumber = '0'

insert into @SumHoursTo
SELECT a.IdCountry,
		a.Id,
	   (SELECT SUM(ad.HoursQty) FROM ACTUAL_DATA_DETAILS_HOURS ad WHERE IdAssociate=a.Id) as SumHoursQty, 
	   (SELECT SUM(ad.HoursVal) FROM ACTUAL_DATA_DETAILS_HOURS ad WHERE IdAssociate=a.Id) as SumHoursVal
FROM ASSOCIATES a
INNER JOIN COUNTRIES c
	on a.IdCountry = c.Id
WHERE a.InergyLogin = c.Code + '\null'


DECLARE actual_cursor_hours cursor FAST_FORWARD FOR
SELECT ad.IdProject, ad.IdPhase, ad.IdWorkPackage, ad.IdCostCenter, ad.YearMonth, ad.IdAssociate, ad.IdCountry, ad.IdAccount,
	   ad.HoursQty, ad.HoursVal
FROM ACTUAL_DATA_DETAILS_HOURS ad
INNER JOIN ASSOCIATES a
	on ad.IdAssociate = a.id
WHERE a.EmployeeNumber = '0'


open actual_cursor_hours

FETCH NEXT FROM actual_cursor_hours 
INTO @IdProject, @IdPhase, @IdWorkPackage, @IdCostCenter, @YearMonth, @IdAssociate, @IdCountry, @IdAccount, @HoursQty, @HoursVal

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @NewIdAssociate = a.Id
	FROM ASSOCIATES a
	INNER JOIN COUNTRIES c
		on a.IdCountry = c.Id
	WHERE a.InergyLogin = c.Code + '\null' and
		  a.IdCountry = @IdCountry

	UPDATE ACTUAL_DATA_DETAILS_HOURS
	SET HoursQty = 	HoursQty + @HoursQty,
		HoursVal = HoursVal + @HoursVal
	WHERE IdProject = @IdProject and 
		  IdPhase = @IdPhase and
		  IdWorkPackage = @IdWorkPackage and
		  IdCostCenter = @IdCostCenter and
		  YearMonth = @YearMonth and
		  IdAssociate = @NewIdAssociate and
		  IdCountry = @IdCountry and
		  IdAccount = @IdAccount

	if @@rowcount = 0
	BEGIN
		INSERT ACTUAL_DATA_DETAILS_HOURS
		SELECT IdProject, IdPhase, IdWorkPackage, IdCostCenter, YearMonth, @NewIdAssociate, IdCountry, IdAccount, HoursQty, HoursVal, DateImport, IdImport
		FROM ACTUAL_DATA_DETAILS_HOURS
		WHERE IdProject = @IdProject and 
			  IdPhase = @IdPhase and
			  IdWorkPackage = @IdWorkPackage and
			  IdCostCenter = @IdCostCenter and
			  YearMonth = @YearMonth and
			  IdAssociate = @IdAssociate and
			  IdCountry = @IdCountry and
			  IdAccount = @IdAccount

		Set @RowsInserted = @RowsInserted + 1
	end
	else
	BEGIN
		Set @RowsUpdated = @RowsUpdated + 1
	end

	DELETE 
	FROM ACTUAL_DATA_DETAILS_HOURS
	WHERE IdProject = @IdProject and 
		  IdPhase = @IdPhase and
		  IdWorkPackage = @IdWorkPackage and
		  IdCostCenter = @IdCostCenter and
		  YearMonth = @YearMonth and
		  IdAssociate = @IdAssociate and
		  IdCountry = @IdCountry and
		  IdAccount = @IdAccount
	set @RowsDeleted = @RowsDeleted + @@rowcount

	FETCH NEXT FROM actual_cursor_hours 	
	INTO @IdProject, @IdPhase, @IdWorkPackage, @IdCostCenter, @YearMonth, @IdAssociate, @IdCountry, @IdAccount, @HoursQty, @HoursVal

END

close actual_cursor_hours
deallocate actual_cursor_hours

SELECT @RowsInserted as RowsInsertedHours,
	   @RowsUpdated as RowsUpdatedHours,
	   @RowsDeleted as RowsDeletedHours

SELECT a.IdCountry,
	   (SELECT ISNULL(SUM(ad.HoursQty),0) FROM ACTUAL_DATA_DETAILS_HOURS ad WHERE IdAssociate=a.Id) as HoursQtyAfter, 
	   (SELECT ISNULL(SUM(ad.HoursVal),0) FROM ACTUAL_DATA_DETAILS_HOURS ad WHERE IdAssociate=a.Id) as HoursValAfter,
		ISNULL(sf.HoursQty,0) + ISNULL(st.HoursQty,0) as HoursQtyBefore,
		ISNULL(sf.HoursVal,0) + ISNULL(st.HoursVal,0) as HoursValBefore
FROM ASSOCIATES a
INNER JOIN @SumHoursTo st
	on a.IdCountry = st.IdCountry 
LEFT JOIN @SumHoursFrom sf
	on a.IdCountry = sf.IdCountry
INNER JOIN COUNTRIES c
	on a.IdCountry = c.Id
WHERE a.InergyLogin = c.Code + '\null'



--costs
DECLARE @CostVal		decimal (18,2)

SELECT @RowsInserted = 0,
	   @RowsUpdated = 0,
	   @RowsDeleted = 0

DECLARE @SumCostsFrom table
(
	IdCountry int not null,
	IdAssociate int not null,
	CostVal decimal (18,2)
)

DECLARE @SumCostsTo table
(
	IdCountry int not null,
	IdAssociate int not null,
	CostVal decimal (18,2)
)

insert into @SumCostsFrom
SELECT  a.IdCountry,
		a.Id, 
	   (SELECT SUM(ad.CostVal) FROM ACTUAL_DATA_DETAILS_COSTS ad WHERE IdAssociate=a.Id)
FROM ASSOCIATES a
WHERE a.EmployeeNumber = '0'

insert into @SumCostsTo
SELECT a.IdCountry,
	   a.Id, 
	   (SELECT SUM(ad.CostVal) FROM ACTUAL_DATA_DETAILS_COSTS ad WHERE IdAssociate=a.Id)
FROM ASSOCIATES a
INNER JOIN COUNTRIES c
	on a.IdCountry = c.Id
WHERE a.InergyLogin = c.Code + '\null'


DECLARE actual_cursor_costs cursor FAST_FORWARD FOR
SELECT ad.IdProject, ad.IdPhase, ad.IdWorkPackage, ad.IdCostCenter, ad.YearMonth, ad.IdAssociate, ad.IdCountry, ad.IdAccount,
	   ad.CostVal
FROM ACTUAL_DATA_DETAILS_COSTS ad
INNER JOIN ASSOCIATES a
	on ad.IdAssociate = a.id
WHERE a.EmployeeNumber = '0'

open actual_cursor_costs

FETCH NEXT FROM actual_cursor_costs 
INTO @IdProject, @IdPhase, @IdWorkPackage, @IdCostCenter, @YearMonth, @IdAssociate, @IdCountry, @IdAccount, @CostVal

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @NewIdAssociate = a.Id
	FROM ASSOCIATES a
	INNER JOIN COUNTRIES c
		on a.IdCountry = c.Id
	WHERE a.InergyLogin = c.Code + '\null' and
		  a.IdCountry = @IdCountry

	UPDATE ACTUAL_DATA_DETAILS_COSTS
	SET CostVal = CostVal + @CostVal
	WHERE IdProject = @IdProject and 
		  IdPhase = @IdPhase and
		  IdWorkPackage = @IdWorkPackage and
		  IdCostCenter = @IdCostCenter and
		  YearMonth = @YearMonth and
		  IdAssociate = @NewIdAssociate and
		  IdCountry = @IdCountry and
		  IdAccount = @IdAccount

	if @@rowcount = 0
	BEGIN
		INSERT ACTUAL_DATA_DETAILS_COSTS
		SELECT IdProject, IdPhase, IdWorkPackage, IdCostCenter, YearMonth, @NewIdAssociate, IdCountry, IdAccount, IdCostType, CostVal, DateImport, IdImport
		FROM ACTUAL_DATA_DETAILS_COSTS
		WHERE IdProject = @IdProject and 
			  IdPhase = @IdPhase and
			  IdWorkPackage = @IdWorkPackage and
			  IdCostCenter = @IdCostCenter and
			  YearMonth = @YearMonth and
			  IdAssociate = @IdAssociate and
			  IdCountry = @IdCountry and
			  IdAccount = @IdAccount

		Set @RowsInserted = @RowsInserted + 1
	end
	else
	BEGIN
		Set @RowsUpdated = @RowsUpdated + 1
	end

	DELETE 
	FROM ACTUAL_DATA_DETAILS_COSTS
	WHERE IdProject = @IdProject and 
		  IdPhase = @IdPhase and
		  IdWorkPackage = @IdWorkPackage and
		  IdCostCenter = @IdCostCenter and
		  YearMonth = @YearMonth and
		  IdAssociate = @IdAssociate and
		  IdCountry = @IdCountry and
		  IdAccount = @IdAccount

	SET @RowsDeleted = @RowsDeleted + @@rowcount

	FETCH NEXT FROM actual_cursor_costs 	
	INTO @IdProject, @IdPhase, @IdWorkPackage, @IdCostCenter, @YearMonth, @IdAssociate, @IdCountry, @IdAccount, @CostVal

END

close actual_cursor_costs
deallocate actual_cursor_costs

SELECT @RowsInserted as RowsInsertedCosts,
	   @RowsUpdated as RowsUpdatedCosts,
	   @RowsDeleted as RowsDeletedCosts

SELECT a.IdCountry,
	   (SELECT isnull(SUM(ad.CostVal),0) FROM ACTUAL_DATA_DETAILS_COSTS ad WHERE IdAssociate=a.Id) as CostValAfter,
		isnull(sf.CostVal,0) + isnull(st.CostVal,0) as CostValBefore
FROM ASSOCIATES a
INNER JOIN @SumCostsTo st
	on a.IdCountry = st.IdCountry 
LEFT JOIN @SumCostsFrom sf
	on a.IdCountry = sf.IdCountry
INNER JOIN COUNTRIES c
	on a.IdCountry = c.Id
WHERE a.InergyLogin = c.Code + '\null'

--sales
DECLARE @SalesVal		decimal (18,2)

SELECT @RowsInserted = 0,
	   @RowsUpdated = 0,
	   @RowsDeleted = 0



DECLARE @SumSalesFrom table
(
	IdCountry int not null,
	IdAssociate int not null,
	SalesVal decimal (18,2)
)

DECLARE @SumSalesTo table
(
	IdCountry int not null,
	IdAssociate int not null,
	SalesVal decimal (18,2)
)

insert into @SumSalesFrom
SELECT  a.IdCountry,
		a.Id, 
	   (SELECT SUM(ad.SalesVal) FROM ACTUAL_DATA_DETAILS_SALES ad WHERE IdAssociate=a.Id)
FROM ASSOCIATES a
WHERE a.EmployeeNumber = '0'

insert into @SumSalesTo
SELECT a.IdCountry,
	   a.Id, 
	   (SELECT SUM(ad.SalesVal) FROM ACTUAL_DATA_DETAILS_SALES ad WHERE IdAssociate=a.Id)
FROM ASSOCIATES a
INNER JOIN COUNTRIES c
	on a.IdCountry = c.Id
WHERE a.InergyLogin = c.Code + '\null'


DECLARE actual_cursor_sales cursor FAST_FORWARD FOR
SELECT ad.IdProject, ad.IdPhase, ad.IdWorkPackage, ad.IdCostCenter, ad.YearMonth, ad.IdAssociate, ad.IdCountry, ad.IdAccount,
	   ad.SalesVal
FROM ACTUAL_DATA_DETAILS_SALES ad
INNER JOIN ASSOCIATES a
	on ad.IdAssociate = a.id
WHERE a.EmployeeNumber = '0'

open actual_cursor_sales

FETCH NEXT FROM actual_cursor_sales 
INTO @IdProject, @IdPhase, @IdWorkPackage, @IdCostCenter, @YearMonth, @IdAssociate, @IdCountry, @IdAccount, @SalesVal

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @NewIdAssociate = a.Id
	FROM ASSOCIATES a
	INNER JOIN COUNTRIES c
		on a.IdCountry = c.Id
	WHERE a.InergyLogin = c.Code + '\null' and
		  a.IdCountry = @IdCountry


	UPDATE ACTUAL_DATA_DETAILS_SALES
	SET SalesVal = SalesVal + @SalesVal
	WHERE IdProject = @IdProject and 
		  IdPhase = @IdPhase and
		  IdWorkPackage = @IdWorkPackage and
		  IdCostCenter = @IdCostCenter and
		  YearMonth = @YearMonth and
		  IdAssociate = @NewIdAssociate and
		  IdCountry = @IdCountry and
		  IdAccount = @IdAccount

	if @@rowcount = 0
	BEGIN
		INSERT ACTUAL_DATA_DETAILS_SALES
		SELECT IdProject, IdPhase, IdWorkPackage, IdCostCenter, YearMonth, @NewIdAssociate, IdCountry, IdAccount, SalesVal, DateImport, IdImport
		FROM ACTUAL_DATA_DETAILS_SALES
		WHERE IdProject = @IdProject and 
			  IdPhase = @IdPhase and
			  IdWorkPackage = @IdWorkPackage and
			  IdCostCenter = @IdCostCenter and
			  YearMonth = @YearMonth and
			  IdAssociate = @IdAssociate and
			  IdCountry = @IdCountry and
			  IdAccount = @IdAccount

		Set @RowsInserted = @RowsInserted + 1
	end
	else
	BEGIN
		Set @RowsUpdated = @RowsUpdated + 1
	end

	DELETE 
	FROM ACTUAL_DATA_DETAILS_SALES
	WHERE IdProject = @IdProject and 
		  IdPhase = @IdPhase and
		  IdWorkPackage = @IdWorkPackage and
		  IdCostCenter = @IdCostCenter and
		  YearMonth = @YearMonth and
		  IdAssociate = @IdAssociate and
		  IdCountry = @IdCountry and
		  IdAccount = @IdAccount

	SET @RowsDeleted = @RowsDeleted + @@rowcount

	FETCH NEXT FROM actual_cursor_sales 	
	INTO @IdProject, @IdPhase, @IdWorkPackage, @IdCostCenter, @YearMonth, @IdAssociate, @IdCountry, @IdAccount, @SalesVal

END

close actual_cursor_sales
deallocate actual_cursor_sales

SELECT @RowsInserted as RowsInsertedSales,
	   @RowsUpdated as RowsUpdatedSales,
	   @RowsDeleted as RowsDeletedSales


SELECT a.IdCountry,
	   (SELECT isnull(SUM(ad.SalesVal),0) FROM ACTUAL_DATA_DETAILS_SALES ad WHERE IdAssociate=a.Id) as SalesValAfter,
		isnull(sf.SalesVal,0) + isnull(st.SalesVal,0) as SalesValBefore
FROM ASSOCIATES a
INNER JOIN @SumSalesTo st
	on a.IdCountry = st.IdCountry 
LEFT JOIN @SumSalesFrom sf
	on a.IdCountry = sf.IdCountry
INNER JOIN COUNTRIES c
	on a.IdCountry = c.Id
WHERE a.InergyLogin = c.Code + '\null'


DELETE a
FROM ASSOCIATES a
WHERE a.EmployeeNumber = '0'


UPDATE a
SET EmployeeNumber = 0,
	Name = 'NA, cost or sales'
FROM ASSOCIATES a
INNER JOIN COUNTRIES c
	on a.IdCountry = c.Id
WHERE a.InergyLogin = c.Code + '\null'

COMMIT
