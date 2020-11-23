
begin transaction
DECLARE @IdProject INT

-- change this to the desired ProjectId. To know the project id look first in the PROJECTS table.
SET @IdProject = -1 

--deletes all the information for TOCOMPLETION budget (all generations)
DELETE FROM BUDGET_TOCOMPLETION_DETAIL_COSTS WHERE IdProject = @IdProject
DELETE FROM BUDGET_TOCOMPLETION_DETAIL WHERE IdProject = @IdProject
DELETE FROM BUDGET_TOCOMPLETION_PROGRESS WHERE IdProject = @IdProject
DELETE FROM BUDGET_TOCOMPLETION_STATES WHERE IdProject = @IdProject
DELETE FROM BUDGET_TOCOMPLETION WHERE IdProject = @IdProject

--deletes all the information for REVISED budget (all generations)
DELETE FROM BUDGET_REVISED_DETAIL_COSTS WHERE IdProject = @IdProject
DELETE FROM BUDGET_REVISED_DETAIL WHERE IdProject = @IdProject
DELETE FROM BUDGET_REVISED_STATES WHERE IdProject = @IdProject
DELETE FROM BUDGET_REVISED WHERE IdProject = @IdProject

--sets the state to 'Waiting for approval' for all initial budget members 
UPDATE BUDGET_INITIAL_STATES SET State='W' WHERE IdProject = @IdProject


UPDATE BUDGET_INITIAL SET IsValidated = 0 WHERE IdProject = @IdProject

-- change this to commit if the whole script runs smoothly
ROLLBACK
--COMMIT