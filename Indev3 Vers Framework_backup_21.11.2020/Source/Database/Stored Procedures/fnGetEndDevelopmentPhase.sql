--Drops the Function fnGetEndDevelopmentPhase if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetEndDevelopmentPhase]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetEndDevelopmentPhase]
GO

CREATE   FUNCTION fnGetEndDevelopmentPhase
	( 	
	@IdProject int 
	)
RETURNS INT
AS
BEGIN
	declare @MaxYearMonthExistingPhase int
	declare @MaxIdPhase int

	--select @MaxIdPhase = max(IdPhase) 
	--from WORK_PACKAGES 
	--where IdProject = @IdProject and 
	--      IdPhase between 3 and 7

	select @MaxYearMonthExistingPhase = MAX(EndYearMonth)
	from WORK_PACKAGES  
	where IdProject = @IdProject and 
              IdPhase between 3 and 7 

	RETURN @MaxYearMonthExistingPhase 
END
GO
