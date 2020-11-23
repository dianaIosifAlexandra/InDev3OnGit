--because of previuos versions some data is left in wrong state
UPDATE BUDGET_TOCOMPLETION
SET  YearMonthActualData = null
WHERE IdGeneration = 1

