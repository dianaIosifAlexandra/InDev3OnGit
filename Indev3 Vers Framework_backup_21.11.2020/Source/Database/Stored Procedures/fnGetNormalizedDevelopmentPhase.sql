--Drops the Function fnGetNormalizedDevelopmentPhase if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetNormalizedDevelopmentPhase]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetNormalizedDevelopmentPhase]
GO

CREATE   FUNCTION fnGetNormalizedDevelopmentPhase
	( 	
	@IdProject int,
	@IdPhase int,
	@YearImport int,
	@StartYearMonth int,
	@EndYearMonth int,
	@Type char --'S' for StartDevelopmentPhase, 'E' for EndDevelopmentPhase
	)
RETURNS INT
AS
BEGIN
	declare @StartDevelopmentPhaseYM int,
		@EndDevelopmentPhaseYM int,
		@Result int


	if (@IdPhase = 2)
	begin
		if (@StartYearMonth is null) and (@EndYearMonth is null)
			begin 
				set @StartDevelopmentPhaseYM  = @YearImport*100 + 1 /*start of phase 1 is january of the import year*/
				set @EndDevelopmentPhaseYM    = ISNULL(dbo.fnGetStartDevelopmentPhase(@IdProject), @YearImport*100 + 12) /*end of phase 1 is start of phase 2 or end of import year*/
				if (@EndDevelopmentPhaseYM > @YearImport*100 + 12) or (@EndDevelopmentPhaseYM < @YearImport*100 + 1)
				begin
					set @EndDevelopmentPhaseYM = @YearImport*100 + 12  /* if end of development phase is before or after the current year that means the phase 1 will be between january and december current year */
				end
				else
					/* end of development phase is in the current year */
					if (@EndDevelopmentPhaseYM % 100 <= 12) and (@EndDevelopmentPhaseYM % 100 <> 1) and (dbo.fnGetStartDevelopmentPhase(@IdProject) is not null) 
					begin
						set @EndDevelopmentPhaseYM = @EndDevelopmentPhaseYM - 1 
					end
			end
		else 
			begin 
				set @StartDevelopmentPhaseYM  = isnull(@StartYearMonth,@YearImport*100+1)
				set @EndDevelopmentPhaseYM    = isnull(@EndYearMonth,@YearImport*100+12)
			end
	end

else

	if (@IdPhase = 8)
	begin
		if (@StartYearMonth is null) and (@EndYearMonth is null)
		begin 
			set @StartDevelopmentPhaseYM  = ISNULL(dbo.fnGetEndDevelopmentPhase(@IdProject), @YearImport*100 + 1) /*start of phase 7 is the end of phase 6 or ianuary of the import year*/
			set @EndDevelopmentPhaseYM    = @YearImport*100+12 /*end of phase 7 is the end of import year*/
			if (@StartDevelopmentPhaseYM > @EndDevelopmentPhaseYM) 
				set @StartDevelopmentPhaseYM = @YearImport*100 + 1 /*if end of development phase is after the curent year that means the phase 7 will be between january and december current year */
			else
				if (@StartDevelopmentPhaseYM % 100 < 12 and dbo.fnGetEndDevelopmentPhase(@IdProject) is not null)
					set @StartDevelopmentPhaseYM = @StartDevelopmentPhaseYM + 1 	
		end
		else 
		begin 
			set @StartDevelopmentPhaseYM  = isnull(@StartYearMonth,@YearImport*100+1)
			set @EndDevelopmentPhaseYM    = isnull(@EndYearMonth,@YearImport*100+12)
		end
	end
	
else

	begin
		select @StartDevelopmentPhaseYM = ISNULL(dbo.fnGetStartDevelopmentPhase(@IdProject), @YearImport*100 + 1)
		select @EndDevelopmentPhaseYM = ISNULL(dbo.fnGetEndDevelopmentPhase(@IdProject), @YearImport*100 + 12)
	end


	set @Result = 
		CASE
			when @Type = N'S' then @StartDevelopmentPhaseYM
			when @Type = N'E' then @EndDevelopmentPhaseYM
			else null
		END	
	
	return @Result 
END
GO

