--Drops the Function fnGetStartDevelopmentPhase if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetStartDevelopmentPhase]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetStartDevelopmentPhase]
GO

CREATE   FUNCTION fnGetStartDevelopmentPhase
	( 	
	@IdProject int 
	)
RETURNS INT
AS
BEGIN
	declare @MinYearMonthExistingPhase int
	declare @MinIdPhase int

	--select @MinIdPhase = min(IdPhase) 
	--from WORK_PACKAGES 
	--where IdProject = @IdProject and 
	--      IdPhase between 3 and 7

	select @MinYearMonthExistingPhase = min(StartYearMonth)
	from WORK_PACKAGES  
	where IdProject = @IdProject and
	      IdPhase between 3 and 7

	RETURN @MinYearMonthExistingPhase 
END

GO

