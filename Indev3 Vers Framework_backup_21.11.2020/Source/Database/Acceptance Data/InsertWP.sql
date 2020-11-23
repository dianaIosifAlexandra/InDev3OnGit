--INSERT 180 WorkPackages for each Project in the database
--!!!WARNING - Running this script takes about 8 minutes !!!-

DECLARE @IdPrj INT
DECLARE @MaxIdPrj INT
SELECT @MaxIdPrj = MAX(Id) FROM Projects
SET @IdPrj = 0

--sp_help WORK_PACKAGES

Declare @IdWP int,
	@PhaseWP varchar(1),
	@CodeWP varchar(3),
	@NameWP varchar(30),
	@Rank int,
	@IsActiveWP int,
	@Year int,
	@Month int,
	@StartYearMonthWP int,
	@EndYearMonthWP int,
	@IdPhaseWP int,
	@MonthsToAdd int


declare	@wpnum int,
	@wppos int,
	@wpnummin int,
	@wpnummax int
	
SELECT  @Rank = 1,
	@IdWP = 1,
	@PhaseWP = -1,
	@IdPrj = 0,
	@wpnummin = 100,
	@wpnummax = 500


WHILE @IdPrj < @MaxIdPrj
BEGIN
	SELECT  @Year = 1999 + cast(@MaxIdPrj/100 as int),
		@Month = 12

	SET @IdPrj = ISNULL((SELECT TOP 1 Id
			     FROM PROJECTS 
			     WHERE Id > @IdPrj
			     ORDER BY Id),1)
	SET @wppos = 1
	SET @wpnum = @wpnummin + (@wpnummax-@wpnummin) * RAND()

	WHILE @wppos < @wpnum
	BEGIN
		SELECT @PhaseWP = Code
		FROM PROJECT_PHASES 
		WHERE id = cast((@wppos/100)+1 as int)
	
		SET @IdWP = @wppos

		Set @CodeWP = @PhaseWP + (case when (@IdWP % 100)<10 then '0' else '' end) + Cast((@IdWP % 100) as varchar(2))
		Set @NameWP = 'WPNameMMMMMMMMMMMMMMMMMMMMM'+ @CodeWP

		Set @IsActiveWP = case when (Cast(@CodeWP as int) % 20) = 0 then 0 else 1 end
	
		select @IdPhaseWP = id 
		from PROJECT_PHASES 
		where Code = @PhaseWP
	
		if @PhaseWP = 1
		begin
			set @year = case when @month = 12 then @year+1 else @year end
			set @month = case when @month = 12 then 1 else @month+1 end
		end
	
		Set @StartYearMonthWP = @Year*100+@Month
		Set @MonthsToAdd = Cast(@CodeWP as int) % 30
	
		Set @EndYearMonthWP = dbo.fnAddYearMonth(@StartYearMonthWP, @MonthsToAdd)
	
		--select @CodeWP, @IdPhaseWP, @IdPrj

		exec @IdWP = catInsertWorkPackage @Code = @CodeWP,
					  	  @Name = @NameWP, 
					  	  @IsActive = @IsActiveWP, 
					  	  @IdPhase = @IdPhaseWP, 
					  	  @StartYearMonth = @StartYearMonthWP, 
					  	  @EndYearMonth = @EndYearMonthWP,
					  	  @LastUserUpdate = 2, 
					  	  @IdProject= @IdPrj, 
					  	  @Rank = @Rank
		if @@error<>0
			break

		Set @Rank = @Rank + 1
		SET @wppos = @wppos + 1
	END

	if @@error<>0
		break
END

--delete Work_Packages
--select * from Work_Packages

--select count(*) from projects

