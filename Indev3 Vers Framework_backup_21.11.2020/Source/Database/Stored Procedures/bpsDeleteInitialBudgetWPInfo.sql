--Drops the Procedure bpsDeleteInitialBudgetWPInfo if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bpsDeleteInitialBudgetWPInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bpsDeleteInitialBudgetWPInfo
GO
CREATE PROCEDURE bpsDeleteInitialBudgetWPInfo
	@IdProject 		AS INT, 		--The Id of the Project
	@IdPhase		AS INT,			--The Id of the Phase
	@IdWP			AS INT,			--The Id of the WP
	@IdAssociate	AS INT,			--The Id of the associate
	@WPCode			AS VARCHAR(3)
AS
BEGIN

	DECLARE @ErrorMessage varchar(255)
	DECLARE @retVal	INT
	
	IF NOT EXISTS (SELECT Id
				   FROM WORK_PACKAGES
					WHERE IdProject = @IdProject AND
						  IdPhase	= @IdPhase AND
						  Id = @IdWP
			)
	BEGIN
		SET @ErrorMessage = 'Key information about WP with code '+ @WPCode + ' has been changed by another user. Please refresh your information.'
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN -1
	END

	--delete initial budget detail other costs
	DELETE FROM BUDGET_INITIAL_DETAIL_COSTS 
	WHERE IdProject = @IdProject
		AND IdPhase = @IdPhase
		AND IdWorkPackage = @IdWP
		AND IdAssociate = @IdAssociate

	--delete initial budget detail
	DELETE FROM BUDGET_INITIAL_DETAIL
	WHERE IdProject = @IdProject
		AND IdPhase = @IdPhase
		AND IdWorkPackage = @IdWP
		AND IdAssociate = @IdAssociate

END
GO

