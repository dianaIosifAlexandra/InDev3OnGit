--Drops the Procedure impWriteAnnualTableDetailsCosts if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteAnnualTableDetailsCosts]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteAnnualTableDetailsCosts
GO

CREATE PROCEDURE impWriteAnnualTableDetailsCosts
	@IdImport INT,			
	@SkipStartEndPhaseErrors bit = 0			
AS

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
	@IdCostType	int,
	@IdCountry	int,
	@CostVal1	decimal(18,2),
	@CostVal2	decimal(18,2),
	@CostVal3	decimal(18,2),
	@CostVal4	decimal(18,2),
	@CostVal5	decimal(18,2),
	@CostVal6	decimal(18,2),
	@CostVal7	decimal(18,2),
	@CostVal8	decimal(18,2),
	@CostVal9	decimal(18,2),
	@CostVal10	decimal(18,2),
	@CostVal11	decimal(18,2),
	@CostVal12	decimal(18,2),
	@IdAccount	int,
	@DateImport	smalldatetime,
	@StartWPYear	int,
	@StartWPMonth	int,
	@EndWPYear	int,
	@EndWPMonth	int,
	@MonthCount	int,
	@EndMonth	int,
	@ErrStr 	varchar(200),
	@EndDevelopmentPhaseYM int,
	@StartDevelopmentPhaseYM int

declare @ProjectCode varchar(10)

DECLARE @Module varchar(10)
DECLARE @IdRow int,
		@Message varchar(510)
DECLARE @YEAR int
SELECT @YEAR = SUBSTRING([FileName], 4, 4) FROM ANNUAL_BUDGET_IMPORTS WHERE IdImport = @IdImport


CREATE TABLE #ImportBudgetAnnualDetailsCosts 
	(
	IdProject	int NOT NULL,
	IdPhase		int NOT NULL,
	IdWorkPackage	int NOT NULL,
	StartYearMonth	int,
	EndYearMonth	int,
	YearImport	int,
	IdCostCenter	int NOT NULL,
	IdCountry	int NOT NULL,
	IdAccount	int NOT NULL,
	IdCostType	int NOT NULL,
	CostVal1	decimal(18,2),
	CostVal2	decimal(18,2),
	CostVal3	decimal(18,2),
	CostVal4	decimal(18,2),
	CostVal5	decimal(18,2),
	CostVal6	decimal(18,2),
	CostVal7	decimal(18,2),
	CostVal8	decimal(18,2),
	CostVal9	decimal(18,2),
	CostVal10	decimal(18,2),
	CostVal11	decimal(18,2),
	CostVal12	decimal(18,2),
	DateImport	smalldatetime,
	IdRow		int NOT NULL,
	StartDevelopmentPhaseYM int,
	EndDevelopmentPhaseYM int
	)
declare @Command nvarchar(200)
set @Command = 'create index ImportBudgetAnnualDetails_IdRow_' + cast(@@SPID as varchar(10)) + ' on #ImportBudgetAnnualDetailsCosts (IdRow)'
exec(@Command)

INSERT INTO #ImportBudgetAnnualDetailsCosts
	(IdProject,
	IdPhase, 
	IdWorkPackage,
	StartYearMonth,	
	EndYearMonth,
	YearImport,
	IdCostCenter,
	IdCountry,
	IdAccount,
	IdCostType,
	CostVal1,
	CostVal2,
	CostVal3,
	CostVal4,
	CostVal5,
	CostVal6,
	CostVal7,
	CostVal8,
	CostVal9,
	CostVal10,
	CostVal11,
	CostVal12,
	DateImport,
	IdRow
	)
SELECT
	WP.IdProject,
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
	dbo.fnGetActualDetailIdAccount(C.Id, IMD.AccountNumber),
	GL.IdCostType,
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
WHERE   GL.IdCostType BETWEEN 1 AND 5 AND
	IMD.IdImport = @IdImport
ORDER BY IdRow

update #ImportBudgetAnnualDetailsCosts
set StartDevelopmentPhaseYM = ISNULL(dbo.fnGetNormalizedDevelopmentPhase(IdProject, IdPhase, YearImport, StartYearMonth, EndYearMonth, N'S'), YearImport*100 + 1),
      EndDevelopmentPhaseYM = ISNULL(dbo.fnGetNormalizedDevelopmentPhase(IdProject, IdPhase, YearImport, StartYearMonth, EndYearMonth, N'E'), YearImport*100 + 12)


if @SkipStartEndPhaseErrors  = 0
   begin
	if exists (
		select IdRow
		from #ImportBudgetAnnualDetailsCosts
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
		from #ImportBudgetAnnualDetailsCosts t
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

		return -2000
	end
   end

-- Check if a Value or Quantity is in a month outside WP interval
declare @ErrorQVOutsideInterval int = 0
declare @ErrorOnRow int = 0
------------------------------------------
if @SkipStartEndPhaseErrors  = 0
   begin
		select @CurrentRow = Min(IdRow)
		from #ImportBudgetAnnualDetailsCosts
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
				@IdCostType = IdCostType,
				@IdCountry = IdCountry,
				@CostVal1 = CostVal1,
				@CostVal2 = CostVal2,
				@CostVal3 = CostVal3,
				@CostVal4 = CostVal4,
				@CostVal5 = CostVal5,
				@CostVal6 = CostVal6,
				@CostVal7 = CostVal7,
				@CostVal8 = CostVal8,
				@CostVal9 = CostVal9,
				@CostVal10 = CostVal10,
				@CostVal11 = CostVal11,
				@CostVal12 = CostVal12,
				@IdAccount = IdAccount,
				@DateImport = DateImport,
				@StartDevelopmentPhaseYM = StartDevelopmentPhaseYM,
				@EndDevelopmentPhaseYM = EndDevelopmentPhaseYM
			from #ImportBudgetAnnualDetailsCosts
			where IdRow = @CurrentRow

			set @ErrorOnRow = 0

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

				--adjust the lower and upper limit of the WP period in case the overlap 
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

					if case @CurrentMonth2
							when 1 then @CostVal1 when 2 then @CostVal2 when 3 then @CostVal3 when 4 then @CostVal4
							when 5 then @CostVal5 when 6 then @CostVal6 when 7 then @CostVal7 when 8 then @CostVal8
							when 9 then @CostVal9 when 10 then @CostVal10 when 11 then @CostVal11 when 12 then @CostVal12
						end <> 0 and @ErrorOnRow = 0
						   begin
								set @ErrorOnRow = 1

								select @ProjectCode = Code
								FROM PROJECTS
								where Id = @IdProject

								set @Message = 'Cost Value cannot be different from zero before Start Development Phase (' + dbo.fnGetYMStringRepresentation(@StartDevelopmentPhaseYM) + 
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
					if  case @CurrentMonth2
							when 1 then @CostVal1 when 2 then @CostVal2 when 3 then @CostVal3 when 4 then @CostVal4
							when 5 then @CostVal5 when 6 then @CostVal6 when 7 then @CostVal7 when 8 then @CostVal8
							when 9 then @CostVal9 when 10 then @CostVal10 when 11 then @CostVal11 when 12 then @CostVal12
						end <> 0 and @ErrorOnRow = 0
						   begin
								set @ErrorOnRow = 1

								select @ProjectCode = Code
								FROM PROJECTS
								where Id = @IdProject

								set @Message = 'Cost Value cannot be different from zero after End Development Phase (' + dbo.fnGetYMStringRepresentation(@EndDevelopmentPhaseYM) + 
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

			select @CurrentRow = Min(IdRow)
			from #ImportBudgetAnnualDetailsCosts
			where IdRow > @CurrentRow

		end

		if @ErrorQVOutsideInterval = 1
		   begin
			  return -2000
		   end
   end

------------------------------------------



select @CurrentRow = Min(IdRow)
from #ImportBudgetAnnualDetailsCosts
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
		@IdCostType = IdCostType,
		@IdCountry = IdCountry,
		@CostVal1 = CostVal1,
		@CostVal2 = CostVal2,
		@CostVal3 = CostVal3,
		@CostVal4 = CostVal4,
		@CostVal5 = CostVal5,
		@CostVal6 = CostVal6,
		@CostVal7 = CostVal7,
		@CostVal8 = CostVal8,
		@CostVal9 = CostVal9,
		@CostVal10 = CostVal10,
		@CostVal11 = CostVal11,
		@CostVal12 = CostVal12,
		@IdAccount = IdAccount,
		@DateImport = DateImport,
		@StartDevelopmentPhaseYM = StartDevelopmentPhaseYM,
		@EndDevelopmentPhaseYM = EndDevelopmentPhaseYM
	from #ImportBudgetAnnualDetailsCosts
	where IdRow = @CurrentRow


	--Phases 0, NA: upload blocked; error thrown with row number
	if @IdPhase in (9)
	begin 

		declare @errWP varchar(150)
		declare @PhaseName varchar(50)
		set @PhaseName = case 
					when @IdPhase = 1 then 'No Phase'
					when @IdPhase = 9 then 'Not Allocated Phase'
				 end
		set @errWP = 'Work Packages belonging to ' + @PhaseName + ' are not allowed (line number ' + cast(@CurrentRow as varchar(10)) + ').'

		raiserror(@errWP,16,1)		
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

		--adjust the lower and upper limit of the WP period in case the overlap 
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
	
		while @CurrentMonth <= @EndMonth
		begin
			insert into ANNUAL_BUDGET_DATA_DETAILS_COSTS
					(
					IdProject,
					IdPhase,
					IdWorkPackage,
					IdCostCenter,
					YearMonth,
					IdCostType,
					IdCountry,
					CostVal,
					IdAccount,
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
					@IdCostType,
					@IdCountry,
					case @CurrentMonth
						when 1 then @CostVal1
						when 2 then @CostVal2
						when 3 then @CostVal3
						when 4 then @CostVal4
						when 5 then @CostVal5
						when 6 then @CostVal6
						when 7 then @CostVal7
						when 8 then @CostVal8
						when 9 then @CostVal9
						when 10 then @CostVal10
						when 11 then @CostVal11
						when 12 then @CostVal12
					end,
					@IdAccount,
					@DateImport,
					@IdImport
					)
			if (@@error <> 0)
				return -5
			set @CurrentMonth = @CurrentMonth + 1
		end
	end

	select @CurrentRow = Min(IdRow)
	from #ImportBudgetAnnualDetailsCosts
	where IdRow > @CurrentRow

end
GO
