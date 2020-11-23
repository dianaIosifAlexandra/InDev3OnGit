--Drops the Procedure impWriteAnnualTableHours if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteAnnualTableHours]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteAnnualTableHours
GO

create PROCEDURE [dbo].[impWriteAnnualTableHours]
	@IdImport INT,
	@SkipStartEndPhaseErrors bit = 0
AS

DECLARE @IdCostTypeHours INT
SET @IdCostTypeHours = dbo.fnGetHoursCostTypeID()

declare @CurrentRow int,
	@CurrentMonth int,
	@CurrentMonth2 int

declare @IdProject	int,
	@IdPhase	int,
	@IdWorkPackage	int,
	@StartYearMonth	int,
	@EndYearMonth	int,
	@YearImport	int,
	@IdCostCenter	int,
	@IdCountry	int,
	@IdAccount	int,
	@HoursQty1	decimal(18,2),
	@HoursQty2	decimal(18,2),
	@HoursQty3	decimal(18,2),
	@HoursQty4	decimal(18,2),
	@HoursQty5	decimal(18,2),
	@HoursQty6	decimal(18,2),
	@HoursQty7	decimal(18,2),
	@HoursQty8	decimal(18,2),
	@HoursQty9	decimal(18,2),
	@HoursQty10	decimal(18,2),
	@HoursQty11	decimal(18,2),
	@HoursQty12	decimal(18,2),
	@HoursVal1	decimal(18,2),
	@HoursVal2	decimal(18,2),
	@HoursVal3	decimal(18,2),
	@HoursVal4	decimal(18,2),
	@HoursVal5	decimal(18,2),
	@HoursVal6	decimal(18,2),
	@HoursVal7	decimal(18,2),
	@HoursVal8	decimal(18,2),
	@HoursVal9	decimal(18,2),
	@HoursVal10	decimal(18,2),
	@HoursVal11	decimal(18,2),
	@HoursVal12	decimal(18,2),
	@DateImport	smalldatetime,
	@StartWPYear	int,
	@StartWPMonth	int,
	@EndWPYear	int,
	@EndWPMonth	int,
	@MonthCount	int,
	@EndMonth	int,
	@IdProjectType int
	
declare @ProjectIsBillable bit	

declare @CumulativeQty int,
	@CurrentHoursQty int,
	@CumulativeHoursVal decimal(18,2),
	@CurrentHoursVal decimal(18,2),
	@CurrentHoursValfromDB decimal(18,2),
	@ErrStr varchar(200),
	@EndDevelopmentPhaseYM int,
	@StartDevelopmentPhaseYM int

declare @ProjectCode varchar(10)

DECLARE @YEAR int
SELECT @YEAR = SUBSTRING([FileName], 4, 4) FROM ANNUAL_BUDGET_IMPORTS WHERE IdImport = @IdImport

DECLARE @Module varchar(10)
DECLARE @IdRow int,
		@Message varchar(510)

create table #ImportBudgetAnnualDetailsHours 
	(
	IdProject	int NOT NULL,
	IdProjectType int not null,
	IdPhase		int NOT NULL,
	IdWorkPackage	int NOT NULL,
	StartYearMonth	int,
	EndYearMonth	int,
	YearImport	int,
	IdCostCenter	int NOT NULL,
	IdCountry	int NOT NULL,
	IdAccount	int NOT NULL,
	HoursQty1	decimal(18,2),
	HoursQty2	decimal(18,2),
	HoursQty3	decimal(18,2),
	HoursQty4	decimal(18,2),
	HoursQty5	decimal(18,2),
	HoursQty6	decimal(18,2),
	HoursQty7	decimal(18,2),
	HoursQty8	decimal(18,2),
	HoursQty9	decimal(18,2),
	HoursQty10	decimal(18,2),
	HoursQty11	decimal(18,2),
	HoursQty12	decimal(18,2),
	HoursVal1	decimal(18,2),
	HoursVal2	decimal(18,2),
	HoursVal3	decimal(18,2),
	HoursVal4	decimal(18,2),
	HoursVal5	decimal(18,2),
	HoursVal6	decimal(18,2),
	HoursVal7	decimal(18,2),
	HoursVal8	decimal(18,2),
	HoursVal9	decimal(18,2),
	HoursVal10	decimal(18,2),
	HoursVal11	decimal(18,2),
	HoursVal12	decimal(18,2),
	DateImport	smalldatetime,
	IdRow		int NOT NULL,
	StartDevelopmentPhaseYM int,
	EndDevelopmentPhaseYM int
	) 

declare @Command nvarchar(200)
set @Command = 'create index ImportBudgetAnnualDetails_IdRow_' + cast(@@SPID as varchar(10)) + ' on #ImportBudgetAnnualDetailsHours (IdRow)'
exec(@Command)

INSERT INTO #ImportBudgetAnnualDetailsHours
	(IdProject,
	IdProjectType,
	IdPhase, 
	IdWorkPackage,
	StartYearMonth,	
	EndYearMonth,
	YearImport,
	IdCostCenter,
	IdCountry,
	IdAccount,
	HoursQty1,
	HoursQty2,
	HoursQty3,
	HoursQty4,
	HoursQty5,
	HoursQty6,
	HoursQty7,
	HoursQty8,
	HoursQty9,
	HoursQty10,
	HoursQty11,
	HoursQty12,
	HoursVal1,
	HoursVal2,
	HoursVal3,
	HoursVal4,
	HoursVal5,
	HoursVal6,
	HoursVal7,
	HoursVal8,
	HoursVal9,
	HoursVal10,
	HoursVal11,
	HoursVal12,
	DateImport,
	IdRow
	)
SELECT 
	P.Id,
	P.IdProjectType,
	WP.IdPhase,
	WP.Id,
	case when PH.Code in ('1', '7') 
	then
		WP.StartYearMonth
	else 
		isnull(WP.StartYearMonth, IMD.Year*100 + 1)
	end,
	case when PH.Code in ('1', '7')  
	then
		WP.EndYearMonth
	else 
		isnull(WP.EndYearMonth, IMD.Year*100 + 12)
	end,
	IMD.Year,
	CC.Id,
	C.Id, 
	dbo.fnGetAnnualIdGLAccount(IMD.AccountNumber, IMD.Country), 
	IMD.Quantity1,
	IMD.Quantity2,
	IMD.Quantity3,
	IMD.Quantity4,
	IMD.Quantity5,
	IMD.Quantity6,
	IMD.Quantity7,
	IMD.Quantity8,
	IMD.Quantity9,
	IMD.Quantity10,
	IMD.Quantity11,
	IMD.Quantity12,
	isnull(IMD.Value1, 0),
	isnull(IMD.Value2, 0),
	isnull(IMD.Value3, 0),
	isnull(IMD.Value4, 0),
	isnull(IMD.Value5, 0),
	isnull(IMD.Value6, 0),
	isnull(IMD.Value7, 0),
	isnull(IMD.Value8, 0),
	isnull(IMD.Value9, 0),
	isnull(IMD.Value10, 0),
	isnull(IMD.Value11, 0),
	isnull(IMD.Value12, 0),
	IMD.[Date],
	IMD.IdRow
FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
INNER JOIN PROJECTS P 
	ON IMD.ProjectCode = P.Code
INNER JOIN WORK_PACKAGES WP 
	ON IMD.WPCode = WP.Code AND 
	P.ID = WP.IdProject
INNER JOIN COUNTRIES C
	ON IMD.Country = C.Code 
INNER JOIN COST_CENTERS CC 
	ON IMD.Country = dbo.fnGetCountryCodeFromCostCenter(CC.Id) and
	   IMD.CostCenter = CC.Code
INNER JOIN GL_ACCOUNTS GL
	ON C.Id = GL.IdCountry AND
	   IMD.AccountNumber = GL.Account
INNER JOIN PROJECT_PHASES PH 
	ON WP.IdPhase = PH.Id
WHERE  IMD.IdImport = @IdImport AND
       GL.IdCostType = @IdCostTypeHours
ORDER BY IdRow

update #ImportBudgetAnnualDetailsHours
set StartDevelopmentPhaseYM = ISNULL(dbo.fnGetNormalizedDevelopmentPhase(IdProject, IdPhase, YearImport, StartYearMonth, EndYearMonth, N'S'), YearImport*100 + 1),
      EndDevelopmentPhaseYM = ISNULL(dbo.fnGetNormalizedDevelopmentPhase(IdProject, IdPhase, YearImport, StartYearMonth, EndYearMonth, N'E'), YearImport*100 + 12)


if @SkipStartEndPhaseErrors = 0
   begin
	if exists (
		select IdRow
		from #ImportBudgetAnnualDetailsHours
		where IdPhase in (1,2,3,4,5,6,7,8)	
			AND (
				(StartDevelopmentPhaseYM/100 < YearImport and EndDevelopmentPhaseYM/100 < YearImport)
				OR
				(StartDevelopmentPhaseYM/100 > YearImport and EndDevelopmentPhaseYM/100 > YearImport)
				 )
		   )
	begin
		INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS]
		( [IdImport], [Year], [Validation] )
		VALUES (@IdImport, @YEAR, 'O')

		SELECT  @Module = RTRIM(Code) FROM MODULES WHERE NAME =N'Work Package'

		DECLARE alog_cursor CURSOR FAST_FORWARD FOR
		select 
			t.IdRow,
			'Development Phase [' + dbo.fnGetYMStringRepresentation(t.StartDevelopmentPhaseYM) + 
						', ' + dbo.fnGetYMStringRepresentation(t.EndDevelopmentPhaseYM) + 
						'] for project ' + PRJ.Code + ' is outside the import year. Row number ' + cast(t.IdRow as varchar(10)) + '.'
		from #ImportBudgetAnnualDetailsHours t
		inner join PROJECTS PRJ
			on t.IdProject = PRJ.Id
		where t.IdPhase in (1,2,3,4,5,6,7,8)	
				and (
					(t.StartDevelopmentPhaseYM/100 < t.YearImport and t.EndDevelopmentPhaseYM/100 < t.YearImport)
					or
					(t.StartDevelopmentPhaseYM/100 > t.YearImport and t.EndDevelopmentPhaseYM/100 > t.YearImport)
					 )
		OPEN alog_cursor
		FETCH NEXT FROM alog_cursor INTO @IdRow, @Message

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
			( [IdImport], [IdRow], [Details], [Module] )
			VALUES (@IdImport, @IdRow, @Message, @Module)
		
			FETCH NEXT FROM alog_cursor INTO @IdRow, @Message
		END
	
		CLOSE alog_cursor
		DEALLOCATE alog_cursor

		return -1000
	end
   end

-- Check if a Value or Quantity is in a month outside WP interval
declare @ErrorQVOutsideInterval int = 0
declare @ErrorOnRow int = 0
------------------------------------------
if @SkipStartEndPhaseErrors = 0
   begin
		select @CurrentRow = Min(IdRow)
		from #ImportBudgetAnnualDetailsHours
		where IdRow > 0

		set @CurrentMonth = 0

		while @CurrentRow is not null
		begin
			select 
				@IdProject = IdProject,
				@IdPhase = IdPhase,
				@IdWorkPackage = IdWorkPackage,
				@StartYearMonth = StartYearMonth,
				@EndYearMonth = EndYearMonth,
				@YearImport = YearImport,
				@IdCostCenter = IdCostCenter,
				@IdCountry = IdCountry,
				@IdAccount = IdAccount,
				@HoursQty1 = round(HoursQty1, 0),
				@HoursQty2 = round(HoursQty2, 0),
				@HoursQty3 = round(HoursQty3, 0),
				@HoursQty4 = round(HoursQty4, 0),
				@HoursQty5 = round(HoursQty5, 0),
				@HoursQty6 = round(HoursQty6, 0),
				@HoursQty7 = round(HoursQty7, 0),
				@HoursQty8 = round(HoursQty8, 0),
				@HoursQty9 = round(HoursQty9, 0),
				@HoursQty10 = round(HoursQty10, 0),
				@HoursQty11 = round(HoursQty11, 0),
				@HoursQty12 = round(HoursQty12, 0),
				@HoursVal1 = HoursVal1,
				@HoursVal2 = HoursVal2,
				@HoursVal3 = HoursVal3,
				@HoursVal4 = HoursVal4,
				@HoursVal5 = HoursVal5,
				@HoursVal6 = HoursVal6,
				@HoursVal7 = HoursVal7,
				@HoursVal8 = HoursVal8,
				@HoursVal9 = HoursVal9,
				@HoursVal10 = HoursVal10,
				@HoursVal11 = HoursVal11,
				@HoursVal12 = HoursVal12,
				@DateImport = DateImport,
				@StartDevelopmentPhaseYM = StartDevelopmentPhaseYM,
				@EndDevelopmentPhaseYM = EndDevelopmentPhaseYM,
				@IdProjectType = IdProjectType
			from #ImportBudgetAnnualDetailsHours
			where IdRow = @CurrentRow

			set @ErrorOnRow = 0

			set @ProjectIsBillable = case when @IdProjectType = 5 or @IdProjectType = 6 then 0 else 1 end

			--Phases 1-6 and also 7:   - for WPs belonging to phases 1-6 the split is done to the month inside the interval 
						  -- [Min StartYearMonth WPs Phase 2 - Max EndYearMonth Phase 6]

			if @IdPhase in (1,2,3,4,5,6,7,8)
			begin	
				set @StartYearMonth = @StartDevelopmentPhaseYM 
				set @EndYearMonth = @EndDevelopmentPhaseYM

				set @StartWPYear	= @StartYearMonth/100
				set @StartWPMonth	= @StartYearMonth%100
				set @EndWPYear		= @EndYearMonth/100
				set @EndWPMonth		= @EndYearMonth%100

				-- adjust the lower and upper limit of the WP period in case the overlap 
				-- with the year of upload is outside the year of upload.
				if (@StartWPYear = @YearImport  AND @EndWPYear > @YearImport)
				BEGIN
					set @EndWPMonth = 12
				END
	
				if (@StartWPYear < @YearImport  AND @EndWPYear = @YearImport)
				BEGIN
					set @StartWPMonth = 1
				END
	
				if (@StartWPYear < @YearImport  AND @EndWPYear > @YearImport)
				BEGIN
					set @StartWPMonth = 1
					set @EndWPMonth = 12
				END

				set @CurrentMonth2 = 1
				while @CurrentMonth2 < @StartWPMonth
				   begin 

					if ((case @CurrentMonth2
							when 1 then @HoursQty1 when 2 then @HoursQty2 when 3 then @HoursQty3 when 4 then @HoursQty4
							when 5 then @HoursQty5 when 6 then @HoursQty6 when 7 then @HoursQty7 when 8 then @HoursQty8
							when 9 then @HoursQty9 when 10 then @HoursQty10 when 11 then @HoursQty11 when 12 then @HoursQty12
						end <> 0
						or
					   case @CurrentMonth2
							when 1 then @HoursVal1 when 2 then @HoursVal2 when 3 then @HoursVal3 when 4 then @HoursVal4
							when 5 then @HoursVal5 when 6 then @HoursVal6 when 7 then @HoursVal7 when 8 then @HoursVal8
							when 9 then @HoursVal9 when 10 then @HoursVal10 when 11 then @HoursVal11 when 12 then @HoursVal12
						end <> 0)) and @ErrorOnRow = 0
						   begin
								set @ErrorOnRow = 1
								select @ProjectCode = Code
								FROM PROJECTS
								where Id = @IdProject

								set @Message = 'Quantity or Value cannot be different from zero before Start Development Phase (' + dbo.fnGetYMStringRepresentation(@StartDevelopmentPhaseYM) + 
										') for project ' + @ProjectCode + '.' + 'Row number ' + cast(@CurrentRow as varchar(10))+ ', month on the row ' + cast(@currentMonth2 as varchar(2)) + '.'

								if @ErrorQVOutsideInterval = 0
								begin
									set @ErrorQVOutsideInterval = 1

									INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS]
									( [IdImport], [Year], [Validation] )
									VALUES (@IdImport, @YEAR, 'O')

									SELECT  @Module = RTRIM(Code) FROM MODULES WHERE NAME =N'Work Package'
								end

								INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
								( [IdImport], [IdRow], [Details], [Module] )
								VALUES (@IdImport, @CurrentRow, @Message, @Module)
						   end

					set @CurrentMonth2 = @CurrentMonth2 + 1
				   end

				set @CurrentMonth2 = @EndWPMonth + 1
				while @CurrentMonth2 <= 12
				   begin 
					if ((case @CurrentMonth2
							when 1 then @HoursQty1 when 2 then @HoursQty2 when 3 then @HoursQty3 when 4 then @HoursQty4
							when 5 then @HoursQty5 when 6 then @HoursQty6 when 7 then @HoursQty7 when 8 then @HoursQty8
							when 9 then @HoursQty9 when 10 then @HoursQty10 when 11 then @HoursQty11 when 12 then @HoursQty12
						end <> 0
						or
					   case @CurrentMonth2
							when 1 then @HoursVal1 when 2 then @HoursVal2 when 3 then @HoursVal3 when 4 then @HoursVal4
							when 5 then @HoursVal5 when 6 then @HoursVal6 when 7 then @HoursVal7 when 8 then @HoursVal8
							when 9 then @HoursVal9 when 10 then @HoursVal10 when 11 then @HoursVal11 when 12 then @HoursVal12
						end <> 0)) and @ErrorOnRow = 0
						   begin
								 set @ErrorOnRow = 1

								select @ProjectCode = Code
								FROM PROJECTS
								where Id = @IdProject

								set @Message = 'Quantity or Value cannot be different from zero after End Development Phase (' + dbo.fnGetYMStringRepresentation(@EndDevelopmentPhaseYM) + 
										') for project ' + @ProjectCode + '.' + 'Row number ' + cast(@CurrentRow as varchar(10))+  ', month on the row ' + cast(@currentMonth2 as varchar(2)) + '.'
						
								if @ErrorQVOutsideInterval = 0
								begin
									set @ErrorQVOutsideInterval = 1

									INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS]
									( [IdImport], [Year], [Validation] )
									VALUES (@IdImport, @YEAR, 'O')

									SELECT  @Module = RTRIM(Code) FROM MODULES WHERE NAME =N'Work Package'
								end

								INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
								( [IdImport], [IdRow], [Details], [Module] )
								VALUES (@IdImport, @CurrentRow, @Message, @Module)
						   end

					set @CurrentMonth2 = @CurrentMonth2 + 1
				   end
			end

			SELECT @CurrentRow = Min(IdRow)
			from #ImportBudgetAnnualDetailsHours
			where IdRow > @CurrentRow
		end

		if @ErrorQVOutsideInterval = 1
		   begin
			  return -1000
		   end

   end
------------------------------------------

select @CurrentRow = Min(IdRow)
from #ImportBudgetAnnualDetailsHours
where IdRow > 0

set @CurrentMonth = 0

while @CurrentRow is not null
begin
	select 
		@IdProject = IdProject,
		@IdPhase = IdPhase,
		@IdWorkPackage = IdWorkPackage,
		@StartYearMonth = StartYearMonth,
		@EndYearMonth = EndYearMonth,
		@YearImport = YearImport,
		@IdCostCenter = IdCostCenter,
		@IdCountry = IdCountry,
		@IdAccount = IdAccount,
		@HoursQty1 = round(HoursQty1, 0),
		@HoursQty2 = round(HoursQty2, 0),
		@HoursQty3 = round(HoursQty3, 0),
		@HoursQty4 = round(HoursQty4, 0),
		@HoursQty5 = round(HoursQty5, 0),
		@HoursQty6 = round(HoursQty6, 0),
		@HoursQty7 = round(HoursQty7, 0),
		@HoursQty8 = round(HoursQty8, 0),
		@HoursQty9 = round(HoursQty9, 0),
		@HoursQty10 = round(HoursQty10, 0),
		@HoursQty11 = round(HoursQty11, 0),
		@HoursQty12 = round(HoursQty12, 0),
		@HoursVal1 = HoursVal1,
		@HoursVal2 = HoursVal2,
		@HoursVal3 = HoursVal3,
		@HoursVal4 = HoursVal4,
		@HoursVal5 = HoursVal5,
		@HoursVal6 = HoursVal6,
		@HoursVal7 = HoursVal7,
		@HoursVal8 = HoursVal8,
		@HoursVal9 = HoursVal9,
		@HoursVal10 = HoursVal10,
		@HoursVal11 = HoursVal11,
		@HoursVal12 = HoursVal12,
		@DateImport = DateImport,
		@StartDevelopmentPhaseYM = StartDevelopmentPhaseYM,
		@EndDevelopmentPhaseYM = EndDevelopmentPhaseYM,
		@IdProjectType = IdProjectType
	from #ImportBudgetAnnualDetailsHours
	where IdRow = @CurrentRow

	set @ProjectIsBillable = case when @IdProjectType = 5 or @IdProjectType = 6 then 0 else 1 end

	if @IdPhase in (9)
	begin 
		declare @PhaseName varchar(50)
		set @PhaseName = case 
					when @IdPhase = 9 then 'Not Allocated Phase'
				 end
		set @ErrStr = 'Work Packages belonging to ' + @PhaseName + ' are not allowed (line number ' + cast(@CurrentRow as varchar(10)) + ').'

		raiserror(@ErrStr,16,1)		
		return -1
	end


	--Phases 1-6 and also 7:   - for WPs belonging to phases 1-6 the split is done to the month inside the interval 
				  -- [Min StartYearMonth WPs Phase 2 - Max EndYearMonth Phase 6]

	if @IdPhase in (1,2,3,4,5,6,7,8)
	begin	
		--set @StartYearMonth = @StartDevelopmentPhaseYM 
		--set @EndYearMonth = @EndDevelopmentPhaseYM

		set @StartYearMonth =@Year*100 + 1
		set @EndYearMonth = @Year*100 + 12


		--if @StartYearMonth > @EndYearMonth
		--BEGIN 
		--	select @ProjectCode = Code
		--	FROM PROJECTS
		--	where Id = @IdProject

		--	set @ErrStr = 'Start Development Phase (' + dbo.fnGetYMStringRepresentation(@StartDevelopmentPhaseYM) + 
		--			') is not allowed to be greater than End Development Phase (' + dbo.fnGetYMStringRepresentation(@EndDevelopmentPhaseYM) + 
		--			') for project ' + @ProjectCode + '.' + 'Row number ' + cast(@CurrentRow as varchar(10))+ '.'
		--	raiserror(@ErrStr,16,1)		
		--	return -3
		--END

		set @StartWPYear	= @StartYearMonth/100
		set @StartWPMonth	= @StartYearMonth%100
		set @EndWPYear		= @EndYearMonth/100
		set @EndWPMonth		= @EndYearMonth%100

		-- adjust the lower and upper limit of the WP period in case the overlap 
		-- with the year of upload is outside the year of upload.
		--if (@StartWPYear = @YearImport  AND @EndWPYear > @YearImport)
		--BEGIN
		--	set @EndWPMonth = 12
		--END
	
		--if (@StartWPYear < @YearImport  AND @EndWPYear = @YearImport)
		--BEGIN
		--	set @StartWPMonth = 1
		--END
	
		--if (@StartWPYear < @YearImport  AND @EndWPYear > @YearImport)
		--BEGIN
		--	set @StartWPMonth = 1
		--	set @EndWPMonth = 12
		--END

		set @CurrentMonth = @StartWPMonth
		set @EndMonth = @EndWPMonth

		set @CurrentHoursQty = 0
		set @CumulativeQty = 0
		set @CurrentHoursVal = 0
		set @CurrentHoursValFromDB = 0
		set @CumulativeHoursVal = 0


		-- we loop through all the month we need to split the values
		while @CurrentMonth <= @EndMonth
		begin
			select @CurrentHoursQty = case @CurrentMonth
										when 1 then @HoursQty1
										when 2 then @HoursQty2
										when 3 then @HoursQty3
										when 4 then @HoursQty4
										when 5 then @HoursQty5
										when 6 then @HoursQty6
										when 7 then @HoursQty7
										when 8 then @HoursQty8
										when 9 then @HoursQty9
										when 10 then @HoursQty10
										when 11 then @HoursQty11
										when 12 then @HoursQty12
									   end,
					@CurrentHoursValfromDB = case @CurrentMonth
										when 1 then @HoursVal1
										when 2 then @HoursVal2
										when 3 then @HoursVal3
										when 4 then @HoursVal4
										when 5 then @HoursVal5
										when 6 then @HoursVal6
										when 7 then @HoursVal7
										when 8 then @HoursVal8
										when 9 then @HoursVal9
										when 10 then @HoursVal10
										when 11 then @HoursVal11
										when 12 then @HoursVal12
				end


			set @CurrentHoursVal = @CurrentHoursValfromDB

			insert into ANNUAL_BUDGET_DATA_DETAILS_HOURS
					(
					IdProject,
					IdPhase,
					IdWorkPackage,
					IdCostCenter,
					YearMonth,
					IdCountry,
					IdAccount,
					HoursQty,
					HoursVal,
					DateImport,
					IdImport
					)
			values
					(
					@IdProject, 
					@IdPhase,
					@IdWorkPackage,
					@IdCostCenter,
					@YearImport*100 + @CurrentMonth,
					@IdCountry,
					@IdAccount,
					@CurrentHoursQty,
					case when @ProjectIsBillable = 0 then 0 else @CurrentHoursVal end,
						--case  WHEN @CurrentHoursValfromDB = 0 THEN dbo.fnGetValuedHours(@IdCostCenter, 
						--					@CurrentHoursQty, 
						--					@YearImport*100 + @CurrentMonth)
		    --    			       ELSE  @CurrentHoursVal end
					@DateImport,
					@IdImport
					)
			if (@@error <> 0)
			begin
				return -5
			end

			set @CumulativeQty = @CumulativeQty + @CurrentHoursQty
			set @CumulativeHoursVal = @CumulativeHoursVal + @CurrentHoursVal
			set @CurrentMonth = @CurrentMonth + 1	
		end
	end


	SELECT @CurrentRow = Min(IdRow)
	from #ImportBudgetAnnualDetailsHours
	where IdRow > @CurrentRow
end
go