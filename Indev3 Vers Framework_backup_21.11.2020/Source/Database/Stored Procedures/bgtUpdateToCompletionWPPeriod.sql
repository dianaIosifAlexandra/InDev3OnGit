--Drops the Procedure bgtUpdateToCompletionWPPeriod if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtUpdateToCompletionWPPeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtUpdateToCompletionWPPeriod
GO
CREATE PROCEDURE bgtUpdateToCompletionWPPeriod
	@IdProjectParam	INT,		--The Id of the project
	@IdPhaseParam 	INT,		--The Id of the phase
	@IdWP		INT,		--The Id of the selected WorkPackage
	@StartYearMonth INT,		--The new startyearmonth of the workpackage
	@EndYearMonth	INT		--The new endyearmonth of the workpackage
AS
BEGIN
	-- two rules apply for this procedure
	--1. Validated versions do not update
	--2. Non-validated version, if they exists, will give error

	DECLARE @CountAssociates  int,
			@errMsg		varchar(255)

	SELECT @CountAssociates = Count (DISTINCT BCD.IdAssociate)
	FROM BUDGET_TOCOMPLETION_DETAIL BCD
	INNER JOIN BUDGET_TOCOMPLETION BT
		on BCD.IdProject = BT.IDProject and
		   BCD.IdGeneration = BT.IdGeneration
	WHERE 	BCD.IdProject = @IdProjectParam AND
			BCD.IdPhase = @IdPhaseParam AND
			BCD.IdWorkPackage = @IdWP AND
			BT.IsValidated = 0 --only for non validated versions	

	if (@CountAssociates > 0)
	BEGIN
		Declare @FullWpName varchar(40)
		SELECT @FullWpName = WP.Code + ' - ' + WP.Name
		FROM WORK_PACKAGES WP
		WHERE WP.IdProject = @IdProjectParam AND
			  WP.IdPhase = @IdPhaseParam AND
			  WP.Id = @IdWP

		set @errMsg = 'WP ''' + @FullWpName + ''' is used in InProgress reforecast by ' + cast(@CountAssociates as varchar(4)) + ' core team members. WP Period update aborted.'
		RAISERROR(@errMsg, 16, 1)
		RETURN -1
	END

END
GO

