DECLARE @IdProject INT
DECLARE @IdGeneration INT
DECLARE @IdPhase INT
DECLARE @IdWorkPackage INT
DECLARE @IdCostCenter INT
DECLARE @IdAssociate INT
DECLARE @YearMonth INT
DECLARE @CountDeleted INT

Set @CountDeleted = 0							-- number of rows modified

-- use a cursor to select the rows with data outside the WP period
DECLARE crsDelete CURSOR FAST_FORWARD
FOR
SELECT  BTD.IdProject,
		BTD.IdGeneration,
		BTD.IdPhase,
		BTD.IdWorkPackage,
		BTD.IdCostCenter,
		BTD.IdAssociate,
		BTD.YearMonth
FROM    BUDGET_TOCOMPLETION_DETAIL BTD
INNER JOIN WORK_PACKAGES WP
		ON WP.IdProject = BTD.IdProject AND
			WP.IdPhase = BTD.IdPhase AND
			WP.Id = BTD.IdWorkPackage
INNER JOIN BUDGET_TOCOMPLETION BT
		ON BT.IdProject = BTD.IdProject
WHERE   BTD.YearMonth NOT BETWEEN WP.StartYearMonth AND WP.EndYearMonth AND 
		BT.IsValidated = 0 AND					-- check if the budget is not validated
		BTD.IdGeneration = [dbo].[fnGetToCompletionBudgetGeneration](BTD.IdProject,'N')
ORDER BY BTD.IdProject

OPEN    crsDelete
FETCH  NEXT FROM    crsDelete
INTO   @IdProject, @IdGeneration, @IdPhase, @IdWorkPackage, @IdCostCenter, @IdAssociate, @YearMonth

WHILE @@FETCH_STATUS = 0
BEGIN    
		-- check if the key is complete and delete the rows that have data outside the WP period
		IF (@IdProject IS NOT NULL AND
			@IdGeneration IS NOT NULL AND
			@IdPhase IS NOT NULL AND
			@IdWorkPackage IS NOT NULL AND
			@IdCostCenter IS NOT NULL AND
			@IdAssociate IS NOT NULL AND
			@YearMonth IS NOT NULL)
		BEGIN
			delete FROM BUDGET_TOCOMPLETION_DETAIL
			WHERE BUDGET_TOCOMPLETION_DETAIL.IdProject = @IdProject AND
					BUDGET_TOCOMPLETION_DETAIL.IdGeneration = @IdGeneration AND
					BUDGET_TOCOMPLETION_DETAIL.IdPhase = @IdPhase AND
					BUDGET_TOCOMPLETION_DETAIL.IdWorkPackage = @IdWorkPackage AND
					BUDGET_TOCOMPLETION_DETAIL.IdCostCenter = @IdCostCenter AND
					BUDGET_TOCOMPLETION_DETAIL.IdAssociate = @IdAssociate AND
					BUDGET_TOCOMPLETION_DETAIL.YearMonth = @YearMonth
			Set @CountDeleted = @CountDeleted + @@ROWCOUNT
		END
		
		FETCH   NEXT
		FROM    crsDelete
		INTO    @IdProject, @IdGeneration, @IdPhase, @IdWorkPackage, @IdCostCenter, @IdAssociate, @YearMonth
END
CLOSE   crsDelete
DEALLOCATE crsDelete

-- verify the number of rows deleted
SELECT @CountDeleted as CountDeleted

-- select used to verify that the data was deleted
/*
SELECT BTD.*
FROM BUDGET_TOCOMPLETION_DETAIL  BTD
INNER JOIN WORK_PACKAGES WP 
	ON WP.idproject = BTD.idproject AND 
	   WP.idphase = BTD.idphase AND 
	   WP.id = BTD.IdWorkPackage
INNER JOIN BUDGET_TOCOMPLETION BT 
	ON BT.idproject = BTD.idproject
WHERE BTD.YearMonth NOT BETWEEN WP.StartYearMonth AND WP.EndYearMonth AND 
	  BT.IsValidated = 0 AND 
	  BTD.IdGeneration = [dbo].[fnGetToCompletionBudgetGeneration](BTD.IdProject,'N') 

SELECT BTD.*
FROM BUDGET_TOCOMPLETION_DETAIL  BTD
INNER JOIN WORK_PACKAGES WP 
	ON WP.idproject = BTD.idproject AND 
	   WP.idphase = BTD.idphase AND 
	   WP.id = BTD.IdWorkPackage
INNER JOIN BUDGET_TOCOMPLETION BT 
	ON BT.idproject = BTD.idproject
WHERE BTD.YearMonth BETWEEN WP.StartYearMonth AND WP.EndYearMonth AND 
	  BT.IsValidated = 0 AND 
	  BTD.IdGeneration = [dbo].[fnGetToCompletionBudgetGeneration](BTD.IdProject,'N') 
*/

DECLARE @Id_Project INT
DECLARE @Id_Generation INT
DECLARE @Id_Associate INT
DECLARE @AssociatesCount INT

-- use a variable to identify the number of associates for which the procedure is called
SET @AssociatesCount = 0

-- use a cursor to select the associates for which there is need for the
-- [dbo].[bgtToCompletionBudgetCreateNewFromCurrent] procedure to be called
DECLARE crsCallProc CURSOR FAST_FORWARD
FOR
SELECT  BTS.IdAssociate,
		BTS.IdProject,
		BTS.IdGeneration
FROM    BUDGET_TOCOMPLETION_STATES BTS 
INNER JOIN PROJECT_CORE_TEAMS PCT
		ON PCT.IdProject = BTS.IdProject AND
		   PCT.IdAssociate = BTS.IdAssociate
INNER JOIN PROJECTS P
		ON BTS.IdProject = P.Id
WHERE   P.IsActive = 1 AND						-- check if the project is active
		PCT.IsActive = 1 AND					-- check if the associate is active
		-- check if the associate has data for the specified generation
		BTS.IdGeneration = [dbo].[fnGetToCompletionBudgetGeneration](BTS.IdProject,'N') AND
		((SELECT COUNT(*) FROM BUDGET_TOCOMPLETION_DETAIL BTD
		  WHERE BTS.IdProject = BTD.IdProject AND
				BTS.IdGeneration = BTD.IdGeneration AND
				BTS.IdAssociate = BTD.IdAssociate) = 0)		
ORDER BY BTS.IdProject, BTS.IdAssociate

OPEN    crsCallProc

FETCH   NEXT
FROM    crsCallProc
INTO    @Id_Project, @Id_Generation, @Id_Associate

WHILE @@FETCH_STATUS = 0
BEGIN
		-- check if the parameters for calling the procedure are valid and call the procedure
		IF (@Id_Project IS NOT NULL AND
			@Id_Generation IS NOT NULL AND
			@Id_Associate IS NOT NULL)
		BEGIN
			exec [dbo].[bgtToCompletionBudgetCreateNewFromCurrent] @Id_Project, @Id_Generation, @Id_Associate
			SET @AssociatesCount = @AssociatesCount + 1
		END
		
		FETCH   NEXT
		FROM    crsCallProc
		INTO    @Id_Project, @Id_Generation, @Id_Associate
END
CLOSE   crsCallProc
DEALLOCATE crsCallProc

-- verify the number of associates for which the procedure was called
SELECT @AssociatesCount as AssociatesCount