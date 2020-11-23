--Drops the Procedure bgtGetRevisedBudgetStates if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtGetRevisedBudgetStates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtGetRevisedBudgetStates
GO


-- sp_helptext bgtGetRevisedBudgetStates
-- bgtGetRevisedBudgetStates 14,'N'

CREATE        PROCEDURE bgtGetRevisedBudgetStates
	@IdProject 		AS INT,
	@BudVersion		AS CHAR(1)	
AS
	
	IF (@IdProject < 0 )
	BEGIN 
		RAISERROR('No project has been selected',16,1)		
		RETURN -1
	END 
	IF (@BudVersion IS NULL )
	BEGIN 
		RAISERROR('No budget version has been selected',16,1)		
		RETURN -2
	END 

	DECLARE @IdGeneration INT
	SELECT  @IdGeneration = dbo.fnGetRevisedBudgetGeneration(@IdProject,@BudVersion)

	DECLARE @temptable table
	(
		IDPROJECT INT,
		IDASSOCIATE INT,
		IDGENERATION INT,
		AssociateName VARCHAR(50),
		AssociatePF VARCHAR(50),
		IsActive BIT,
		Rank INT
	)	


--Get's the table for Revised FollowUp Budget (from GUI). 

	INSERT INTO @temptable (IDPROJECT, IDASSOCIATE, IDGENERATION, AssociateName, AssociatePF, IsActive, Rank)
	SELECT PCT.IDPROJECT, PCT.IDASSOCIATE,  BR.IDGENERATION , A.Name, PF.Name, PCT.IsActive, PF.Rank
	FROM PROJECT_CORE_TEAMS PCT 
	LEFT JOIN BUDGET_REVISED BR 
		ON  PCT.IDPROJECT = BR.IDPROJECT
	LEFT JOIN ASSOCIATES A 
		ON PCT.IDAssociate = A.ID
	LEFT JOIN PROJECT_FUNCTIONS PF
		ON PCT.IDFunction = PF.ID
	WHERE 	PCT.IDPROJECT = @IdProject AND 
		BR.IDGENERATION = @IdGeneration AND
		ISNULL(A.IsActive,0) = 1
	
	SELECT  t.IdProject  			AS 'IDProject',
		t.IdAssociate			AS 'IDAssociate',
		t.IdGeneration			AS 'IDGeneration',
		t.AssociateName			AS 'Associate',
		t.AssociatePF			AS 'Project Function',
		BRS.StateDate			AS 'StateDate',
		ISNULL(BRS.State,'N')		AS 'StateCode',
		BS.Description			AS 'State',
		case when BRS.State is null then 0 else 1 end	AS 'HasData'
	FROM @temptable t 
	LEFT JOIN BUDGET_REVISED_STATES BRS
		ON t.IdProject = BRS.IdProject
		AND t.IDAssociate = BRS.IdAssociate
		AND t.IdGeneration = BRS.IdGeneration
	LEFT JOIN BUDGET_STATES BS
		ON ISNULL(BRS.State,'N')  = BS.StateCode
	WHERE t.IDProject = @IdProject AND
	      t.IdGeneration = @IdGeneration AND
	      ISNULL(t.IsActive,0) = 1
	ORDER BY t.Rank, t.AssociateName


GO





