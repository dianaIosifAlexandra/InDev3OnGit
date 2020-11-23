--departments
--costcenters


--insert departments -------------------------
declare @depnum int,
	@deppos int,
	@IdFunctionRandom int

declare	@depname varchar(30)
select  @depnum = 1000,
	@deppos = 1

While @deppos <= @depnum
begin
	SELECT TOP 1 @IdFunctionRandom=Id 
	FROM Functions 
	ORDER BY NEWID()

	insert into Departments (Id, Name, idFunction, Rank) 
	values (@deppos, 
		'Department_MMMMMMMMMM' + cast(@deppos as varchar (6)),
		@IdFunctionRandom,
		@deppos*2-1)

	-- de inclocuit cu catInsertDepartment ('Department_MMMMMMMMMM' + cast(@deppos as varchar (6), @IdFunctionRandom, @deppos*2-1)
	-- in momentul cand procedurile vor fi updata-te

	set @deppos = @deppos +1
end
---------------------end departments ----------------------------

--select * from cost_centers
--insert cost centers
declare @ccnum int,
	@ccpos int,
	@IdDepartmentRandom int,
	@IdInergyLocationRandom int

declare	@cccode varchar(15),
	@ccname varchar(30),
	@isactive bit

select  @ccnum = 3000,
	@ccpos = 1

While @ccpos <= @ccnum
begin
	SELECT TOP 1 @IdDepartmentRandom=Id 
	FROM DEPARTMENTS
	ORDER BY NEWID()

	SELECT TOP 1 @IdInergyLocationRandom=Id 
	FROM INERGY_LOCATIONS 
	ORDER BY NEWID()

	--sp_help COST_CENTERS	

	insert into COST_CENTERS (Id, IdInergyLocation, Code, Name, IsActive, IdDepartment) 
	values (@ccpos, 
		@IdInergyLocationRandom,
		'CCenterCode'+cast(@ccpos as varchar (4)),
		'CCenterName_MMMMMMMMMM' + cast(@ccpos as varchar (6)),
		case when (@ccpos % 20)=0 then 0 else 1 end,
		@IdDepartmentRandom)

	-- de inclocuit cu catInsertCostCenter ()
	-- in momentul cand procedurile vor fi updatate cu Rank

	set @ccpos = @ccpos +1
end
--end cost centers

--exchange_rates
declare @ernum int,
	@erpos int,
	@IdCategoryRandom   int,
	@IdCurrencyTo int

declare	@Year int,
	@Month int,
	@YearMonth int

Declare	@ConversionRate decimal(18,4)

select  @ernum = 3000,
	@erpos = 1,
	@Year = 1999,
	@Month = 12,
	@IdCurrencyTo = 0

While @erpos <= @ernum
begin
	SELECT TOP 1 @IdCategoryRandom=Id 
	FROM EXCHANGE_RATE_CATEGORIES
	ORDER BY NEWID()

	SELECT @IdCurrencyTo = 	ISNULL((SELECT TOP 1 Id
					FROM CURRENCIES 
					WHERE ID > @IdCurrencyTo
					ORDER BY Id),1)
	if @IdCurrencyTo = 1
	begin
		set @year = case when @month = 12 then @year+1 else @year end
		set @month = case when @month = 12 then 1 else @month+1 end
	end
	Set @YearMonth = @Year*100+@Month

	set @ConversionRate = CAST(CAST((RAND()*(POWER(10,(@IdCurrencyTo) % 7) + 3)) AS int) as DECIMAL(18,4))/100

	insert into EXCHANGE_RATES (IdCategory, YearMonth, IdCurrencyTo, ConversionRate) 
	values (@IdCategoryRandom, 
		@YearMonth,
		@IdCurrencyTo,
		@ConversionRate)

	-- de inclocuit cu catInsertOrUpdateExchangeRates ()
	-- in momentul cand procedurile vor fi updatate cu Rank

	set @erpos = @erpos +1
end
--select * from exchange_rates order by yearmonth, idCurrencyTo
--delete exchange_rates


--select * from gl_accounts
--gl accounts
declare @glnum int,
	@glpos int,
	@IdCostTypeRandom int

declare	@IdCountry int,
	@Account varchar(20),
	@Name 	 varchar(30)

select  @glnum = 50000,
	@glpos = 10

While @glpos <= @glnum
begin
	SELECT TOP 1 @IdCostTypeRandom=Id
	FROM COST_INCOME_TYPES
	ORDER BY NEWID()

	SELECT @IdCountry = ISNULL((SELECT TOP 1 Id
				    FROM COUNTRIES
				    WHERE ID > @IdCountry
				    ORDER BY Id),1)

	insert into GL_ACCOUNTS (IdCountry, Id, Account, Name, IdCostType)
	values (@IdCountry, 
		@glpos,
		'2312434R43445' + cast (@glpos as varchar(6)),
		'GLName' + cast(@glpos as varchar (6)),
		@IdCostTypeRandom)

	-- de inclocuit cu catInsertGl_Account ()
	-- in momentul cand procedurile vor fi updatate cu Rank

	set @glpos = @glpos +1
end
--end gl accounts



--select * from hourly_rates
--hourly rates accounts
declare @hrnum int,
	@hrpos int

declare	@IdCostCenter int,
	@Year int,
	@Month int,
	@YearMonth    varchar(20),
	@HourlyRate   decimal(18,4)

select  @hrnum = 2000000,
	@hrpos = 1,
	@Year = 1999,
	@Month = 12,
	@IdCostCenter = 0

While @hrpos <= @hrnum
begin
	SELECT @IdCostCenter = ISNULL((SELECT TOP 1 Id
				    FROM COST_CENTERS
				    WHERE ID > @IdCostCenter
				    ORDER BY Id),1)

	if @IdCostCenter = 1
	begin
		set @year = case when @month = 12 then @year+1 else @year end
		set @month = case when @month = 12 then 1 else @month+1 end
	end
	Set @YearMonth = @Year*100+@Month

	set @HourlyRate = CAST(CAST((RAND()*(POWER(10,(@IdCostCenter) % 7) + 3)) AS int) as DECIMAL(18,4))/100

	insert into HOURLY_RATES (IdCostCenter, YearMonth, HourlyRate)
	values (@IdCostCenter, 
		@YearMonth,
		@HourlyRate)

	-- de inclocuit cu catInsertGl_Account ()
	-- in momentul cand procedurile vor fi updatate cu Rank

	set @hrpos = @hrpos +1
end
--end hourly rates



--select * from user_settings
--hourly rates accounts
declare @usnum int,
	@uspos int

declare	@IdAssociate int,
	@AmountScale int,
	@NumberOfRecordsPerPage int,
	@CurrencyRepresentation  varchar(20)

select  @usnum = (SELECT count(Id) from associates)
select	@uspos = 1,
	@IdAssociate = 0

While @uspos <= @usnum
begin
	SELECT @IdAssociate = ISNULL((SELECT TOP 1 Id
				    FROM COST_CENTERS
				    WHERE ID > @IdAssociate
				    ORDER BY Id),1)


	insert into USER_SETTINGS (AssociateId, AmountScaleOption, NumberOfrecordsPerPage, CurrencyRepresentation)
	values (@IdAssociate, 
		@IdAssociate % 3,
		(@IdAssociate % 15) +15,
		@IdAssociate % 2)

	-- de inclocuit cu catInsertUserSettings ()
	-- in momentul cand procedurile vor fi updatate cu Rank

	set @uspos = @uspos +1
end
