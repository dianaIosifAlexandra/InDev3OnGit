BEGIN TRANSACTION
CREATE NONCLUSTERED INDEX IX_ACTUAL_DATA_DETAILS_HOURS ON dbo.ACTUAL_DATA_DETAILS_HOURS
	(
	IdImport DESC
	) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_ACTUAL_DATA_DETAILS_COSTS ON dbo.ACTUAL_DATA_DETAILS_COSTS
	(
	IdImport DESC
	) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_ACTUAL_DATA_DETAILS_SALES ON dbo.ACTUAL_DATA_DETAILS_SALES
	(
	IdImport DESC
	) ON [PRIMARY]
GO
COMMIT

