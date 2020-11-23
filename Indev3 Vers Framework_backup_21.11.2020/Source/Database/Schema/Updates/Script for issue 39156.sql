EXEC sp_rename     
	@objname = 'ANNUAL_BUDGET_IMPORT_LOGS.YearMonth',
	@newname = 'Year',
	@objtype = 'COLUMN'
GO
