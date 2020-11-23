if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_DETAILS_KEYROWS_MISSING]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_DETAILS_KEYROWS_MISSING]
GO

CREATE TABLE [dbo].[IMPORT_DETAILS_KEYROWS_MISSING] (
	[IdImport] [int] NOT NULL ,
	[IdRow] [int] NOT NULL ,
	[Country] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Year] [int] NULL ,
	[Month] [int] NULL ,
	[CostCenter] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProjectCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WPCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AccountNumber] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AssociateNumber] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Quantity] [decimal](18, 2) NULL ,
	[UnitQty] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Value] [decimal](18, 2) NULL ,
	[CurrencyCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Date] [smalldatetime] NULL,
	[IdImportPrevious] [int] NOT NULL,
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[IMPORT_DETAILS_KEYROWS_MISSING] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPORT_DETAILS_KEYROWS_MISSING] PRIMARY KEY  CLUSTERED 
	(
		[IdImport],
		[IdRow]
	)  ON [PRIMARY] 
GO

CREATE  INDEX [IX_IMPORT_DETAILS_KEYROWS_MISSING] ON [dbo].[IMPORT_DETAILS_KEYROWS_MISSING]([IdImport]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[IMPORT_DETAILS_KEYROWS_MISSING] ADD 
	CONSTRAINT [FK_IMPORT_DETAILS_KEYROWS_MISSING_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[IMPORTS] (
		[IdImport]
	)
GO

