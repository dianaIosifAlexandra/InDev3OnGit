if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAIL_COSTS_ANNUAL_BUDGET_DATA_DETAILS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAIL_COSTS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAIL_COSTS_ANNUAL_BUDGET_DATA_DETAILS
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_BUDGET_DATA_DETAIL_COSTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_BUDGET_DATA_DETAIL_COSTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_BUDGET_DATA_DETAILS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_BUDGET_DATA_DETAILS]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_BUDGET_DATA_DETAILS_SALES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_BUDGET_DATA_DETAILS_SALES]
GO

CREATE TABLE ANNUAL_BUDGET_DATA_DETAILS_HOURS
	(
	IdProject int NOT NULL,
	IdPhase int NOT NULL,
	IdWorkPackage int NOT NULL,
	IdCostCenter int NOT NULL,
	YearMonth int NOT NULL,
	IdCountry int NOT NULL,
	IdAccount int NOT NULL,
	HoursQty int NOT NULL,
	HoursVal decimal(18, 2) NOT NULL,
	DateImport smalldatetime NOT NULL,
	IdImport int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE ANNUAL_BUDGET_DATA_DETAILS_HOURS ADD CONSTRAINT
	PK_ANNUAL_BUDGET_DATA_DETAILS PRIMARY KEY CLUSTERED	 
	(
	IdProject,
	IdPhase,
	IdWorkPackage,
	IdCostCenter,
	YearMonth,
	IdCountry,
	IdAccount
	) ON [PRIMARY]

GO

CREATE TABLE ANNUAL_BUDGET_DATA_DETAILS_SALES
	(
	IdProject int NOT NULL,
	IdPhase int NOT NULL,
	IdWorkPackage int NOT NULL,
	IdCostCenter int NOT NULL,
	YearMonth int NOT NULL,
	IdCountry int NOT NULL,
	IdAccount int NOT NULL,
	SalesVal decimal(18, 2) NOT NULL,
	DateImport smalldatetime NOT NULL,
	IdImport int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE ANNUAL_BUDGET_DATA_DETAILS_SALES ADD CONSTRAINT
	PK_ANNUAL_BUDGET_DATA_DETAILS_SALES PRIMARY KEY CLUSTERED 
	(
	IdProject,
	IdPhase,
	IdWorkPackage,
	IdCostCenter,
	YearMonth,
	IdCountry,
	IdAccount
	) ON [PRIMARY]

GO

CREATE TABLE ANNUAL_BUDGET_DATA_DETAILS_COSTS
	(
	IdProject int NOT NULL,
	IdPhase int NOT NULL,
	IdWorkPackage int NOT NULL,
	IdCostCenter int NOT NULL,
	YearMonth int NOT NULL,
	IdCountry int NOT NULL,
	IdAccount int NOT NULL,
	IdCostType int NOT NULL,
	CostVal decimal(18, 2) NOT NULL,
	DateImport smalldatetime NOT NULL,
	IdImport int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE ANNUAL_BUDGET_DATA_DETAILS_COSTS ADD CONSTRAINT
	PK_ANNUAL_BUDGET_DATA_DETAIL_COSTS PRIMARY KEY CLUSTERED 	
	(
	IdProject,
	IdPhase,
	IdWorkPackage,
	IdCostCenter,
	YearMonth,
	IdCountry,
	IdAccount
	) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS] ADD 
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_ANNUAL_BUDGET] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[ANNUAL_BUDGET] (
		[IdProject]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_COST_CENTERS] FOREIGN KEY 
	(
		[IdCostCenter]
	) REFERENCES [dbo].[COST_CENTERS] (
		[Id]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_GL_ACCOUNTS] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccount]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_ANNUAL_BUDGET_IMPORTS] FOREIGN KEY		     
	(
		[IdImport]
	) REFERENCES [dbo].[ANNUAL_BUDGET_IMPORTS] (
		[IdImport]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_WORK_PACKAGES] FOREIGN KEY 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage]
	) REFERENCES [dbo].[WORK_PACKAGES] (
		[IdProject],
		[IdPhase],
		[Id]
	)
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_SALES] ADD 
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_ANNUAL_BUDGET] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[ANNUAL_BUDGET] (
		[IdProject]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_COST_CENTERS] FOREIGN KEY 
	(
		[IdCostCenter]
	) REFERENCES [dbo].[COST_CENTERS] (
		[Id]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_GL_ACCOUNTS] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccount]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_ANNUAL_BUDGET_IMPORTS] FOREIGN KEY		     
	(
		[IdImport]
	) REFERENCES [dbo].[ANNUAL_BUDGET_IMPORTS] (
		[IdImport]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_WORK_PACKAGES] FOREIGN KEY 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage]
	) REFERENCES [dbo].[WORK_PACKAGES] (
		[IdProject],
		[IdPhase],
		[Id]
	)
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS] ADD 
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_ANNUAL_BUDGET] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[ANNUAL_BUDGET] (
		[IdProject]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_ANNUAL_BUDGET_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[ANNUAL_BUDGET_IMPORTS] (
		[IdImport]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_BUDGET_COST_TYPES] FOREIGN KEY 
	(
		[IdCostType]
	) REFERENCES [dbo].[BUDGET_COST_TYPES] (
		[Id]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_COST_CENTERS] FOREIGN KEY 
	(
		[IdCostCenter]
	) REFERENCES [dbo].[COST_CENTERS] (
		[Id]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_GL_ACCOUNTS] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccount]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_WORK_PACKAGES] FOREIGN KEY 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage]
	) REFERENCES [dbo].[WORK_PACKAGES] (
		[IdProject],
		[IdPhase],
		[Id]
	)
GO


ALTER TABLE dbo.ANNUAL_BUDGET_IMPORT_DETAILS
	DROP CONSTRAINT FK_ANNUAL_BUDGET_IMPORT_DETAILS_ANNUAL_BUDGET_IMPORTS
GO

CREATE TABLE dbo.Tmp_ANNUAL_BUDGET_IMPORT_DETAILS
	(
	IdImport int NOT NULL,
	IdRow int NOT NULL,
	Country varchar(3) NULL,
	[Year] int NULL,
	[Month] int NULL,
	CostCenter varchar(15) NULL,
	ProjectCode varchar(10) NULL,
	WPCode varchar(3) NULL,
	AccountNumber varchar(20) NULL,
	Quantity decimal(18, 2) NULL,
	[Value] decimal(18, 2) NULL,
	CurrencyCode varchar(3) NULL,
	[Date] smalldatetime NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.ANNUAL_BUDGET_IMPORT_DETAILS)
	 EXEC('INSERT INTO dbo.Tmp_ANNUAL_BUDGET_IMPORT_DETAILS (IdImport, IdRow, Country, [Year], [Month], CostCenter, ProjectCode, WPCode, AccountNumber, Quantity, [Value], CurrencyCode, [Date])
		SELECT IdImport, IdRow, Country, [Year], [Month], CostCenter, ProjectCode, WPCode, AccountNumber, Quantity, [Value], CurrencyCode, [Date] FROM dbo.ANNUAL_BUDGET_IMPORT_DETAILS (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ANNUAL_BUDGET_IMPORT_DETAILS
GO
EXECUTE sp_rename N'dbo.Tmp_ANNUAL_BUDGET_IMPORT_DETAILS', N'ANNUAL_BUDGET_IMPORT_DETAILS', 'OBJECT'
GO
ALTER TABLE dbo.ANNUAL_BUDGET_IMPORT_DETAILS ADD CONSTRAINT
	PK_ANNUAL_BUDGET_IMPORT_DETAILS PRIMARY KEY CLUSTERED 
	(
	IdImport,
	IdRow
	) WITH FILLFACTOR = 90 ON [PRIMARY]

GO
ALTER TABLE dbo.ANNUAL_BUDGET_IMPORT_DETAILS WITH NOCHECK ADD CONSTRAINT
	FK_ANNUAL_BUDGET_IMPORT_DETAILS_ANNUAL_BUDGET_IMPORTS FOREIGN KEY
	(
	IdImport
	) REFERENCES dbo.ANNUAL_BUDGET_IMPORTS
	(
	IdImport
	)
GO
