-- ############### ACTUAL IMPORTS TABLE ######################
ALTER TABLE IMPORTS ADD
	ExclusionCostCenterRowsNo int NULL,
	ExclusionGlAccountsRowsNo int NULL
GO

UPDATE IMPORTS
SET ExclusionCostCenterRowsNo = 0,
ExclusionGlAccountsRowsNo = 0

GO

ALTER TABLE IMPORTS 
	ALTER COLUMN ExclusionCostCenterRowsNo INT NOT NULL
ALTER TABLE IMPORTS 
	ALTER COLUMN ExclusionGlAccountsRowsNo INT NOT NULL
GO
-- ################# ANNUAL IMPORTS TABLE ###############################
ALTER TABLE  ANNUAL_BUDGET_IMPORTS ADD
	ExclusionCostCenterRowsNo int NULL,
	ExclusionGlAccountsRowsNo int NULL
GO

UPDATE ANNUAL_BUDGET_IMPORTS
SET ExclusionCostCenterRowsNo = 0,
ExclusionGlAccountsRowsNo = 0

GO

ALTER TABLE ANNUAL_BUDGET_IMPORTS 
	ALTER COLUMN ExclusionCostCenterRowsNo INT NOT NULL
ALTER TABLE ANNUAL_BUDGET_IMPORTS 
	ALTER COLUMN ExclusionGlAccountsRowsNo INT NOT NULL

GO

