DECLARE CountryCursor CURSOR FAST_FORWARD FOR
SELECT 	[Id]
FROM	COUNTRIES
WHERE IdRegion is not null

open CountryCursor
declare @id int

FETCH NEXT FROM CountryCursor INTO @Id
WHILE @@FETCH_STATUS = 0
BEGIN

	DECLARE CostIncomeCursor CURSOR FAST_FORWARD FOR
	SELECT 	[Id],
		[Name],
		DefaultAccount
	FROM	COST_INCOME_TYPES

	OPEN CostIncomeCursor
	DECLARE @IdCostIncome INT
	DECLARE @NameCostIncome VARCHAR(50)
	DECLARE @DefaultAccountCostIncome VARCHAR(20)

	FETCH NEXT FROM CostIncomeCursor INTO @IdCostIncome, @NameCostIncome, @DefaultAccountCostIncome		
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC catInsertGlAccount @Id, @DefaultAccountCostIncome, @NameCostIncome, @IdCostIncome
		IF @@ERROR <> 0 
		BEGIN
			raiserror ('Stop',16,1)
		END
		FETCH NEXT FROM CostIncomeCursor INTO @IdCostIncome, @NameCostIncome, @DefaultAccountCostIncome		
	END
	CLOSE CostIncomeCursor
	DEALLOCATE CostIncomeCursor

	FETCH NEXT FROM CountryCursor INTO @Id
END

CLOSE CountryCursor
DEALLOCATE CountryCursor
