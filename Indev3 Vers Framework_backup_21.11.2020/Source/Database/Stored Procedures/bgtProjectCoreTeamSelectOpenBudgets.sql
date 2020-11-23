--Drops the Procedure bgtProjectCoreTeamSelectOpenBudgets if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtProjectCoreTeamSelectOpenBudgets]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtProjectCoreTeamSelectOpenBudgets
GO
CREATE PROCEDURE bgtProjectCoreTeamSelectOpenBudgets
	@IdProject 	AS INT,
	@IdAssociate 	AS INT
AS
	SELECT 	BIS.IdProject AS 'IdProject',
		BIS.IdAssociate AS 'IdAssociate',
		State AS 'BudgetState'
	FROM 	BUDGET_INITIAL_STATES BIS
	WHERE	BIS.IdProject = @IdProject AND
		BIS.IdAssociate = @IdAssociate AND
		BIS.State <> 'V' AND BIS.State <> 'N' AND BIS.State <> 'U'

	UNION

	SELECT 	BRS.IdProject AS 'IdProject',
		BRS.IdAssociate AS 'IdAssociate',
		State AS 'BudgetState'
	FROM 	BUDGET_REVISED_STATES BRS
	WHERE	BRS.IdProject = @IdProject AND
		BRS.IdAssociate = @IdAssociate AND
		BRS.State <> 'V' AND BRS.State <> 'N'

	UNION

	SELECT 	BTS.IdProject AS 'IdProject',
		BTS.IdAssociate AS 'IdAssociate',
		State AS 'BudgetState'
	FROM 	BUDGET_TOCOMPLETION_STATES BTS
	WHERE	BTS.IdProject = @IdProject AND
		BTS.IdAssociate = @IdAssociate AND
		BTS.State <> 'V' AND BTS.State <> 'N'
GO

