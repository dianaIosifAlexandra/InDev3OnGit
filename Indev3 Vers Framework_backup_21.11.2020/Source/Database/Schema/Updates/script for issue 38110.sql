INSERT INTO MODULES(Code, Name ) VALUES( 'IBU', 'Initial Budget Upload' )
GO

INSERT INTO ROLE_RIGHTS(IdRole, CodeModule, IdOperation, IdPermission ) VALUES( 1, 'IBU', 1, 1 )
INSERT INTO ROLE_RIGHTS(IdRole, CodeModule, IdOperation, IdPermission ) VALUES( 2, 'IBU', 1, 1 )
INSERT INTO ROLE_RIGHTS(IdRole, CodeModule, IdOperation, IdPermission ) VALUES( 3, 'IBU', 1, 3 )
INSERT INTO ROLE_RIGHTS(IdRole, CodeModule, IdOperation, IdPermission ) VALUES( 4, 'IBU', 1, 3 )
INSERT INTO ROLE_RIGHTS(IdRole, CodeModule, IdOperation, IdPermission ) VALUES( 5, 'IBU', 1, 3 )
INSERT INTO ROLE_RIGHTS(IdRole, CodeModule, IdOperation, IdPermission ) VALUES( 6, 'IBU', 1, 3 )
INSERT INTO ROLE_RIGHTS(IdRole, CodeModule, IdOperation, IdPermission ) VALUES( 7, 'IBU', 1, 3 )
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_BUDGET_INITIAL_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_BUDGET_INITIAL] DROP CONSTRAINT FK_IMPORT_BUDGET_INITIAL_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_BUDGET_INITIAL_DETAILS_IMPORT_BUDGET_INITIAL]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_BUDGET_INITIAL_DETAILS] DROP CONSTRAINT FK_IMPORT_BUDGET_INITIAL_DETAILS_IMPORT_BUDGET_INITIAL
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_BUDGET_INITIAL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_BUDGET_INITIAL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_BUDGET_INITIAL_DETAILS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_BUDGET_INITIAL_DETAILS]
GO

CREATE TABLE [dbo].[IMPORT_BUDGET_INITIAL] (
	[IdImport] [int] NOT NULL ,
	[ImportDate] [datetime] NOT NULL ,
	[FileName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdAssociate] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IMPORT_BUDGET_INITIAL_DETAILS] (
	[IdImport] [int] NOT NULL ,
	[IdRow] [int] NOT NULL ,
	[ProjectCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[WPCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AssociateNumber] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CountryCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CostCenterCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HoursQty] [int] NULL ,
	[HoursVal] [decimal](18, 4) NULL ,
	[SalesVal] [decimal](18, 4) NULL ,
	[TE] [decimal](18, 4) NULL ,
	[ProtoParts] [decimal](18, 4) NULL ,
	[ProtoTooling] [decimal](18, 4) NULL ,
	[Trials] [decimal](18, 4) NULL ,
	[OtherExpenses] [decimal](18, 4) NULL ,
	[CurrencyCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[IMPORT_BUDGET_INITIAL] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPORT_BUDGET_INITIAL] PRIMARY KEY  CLUSTERED 
	(
		[IdImport]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IMPORT_BUDGET_INITIAL_DETAILS] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPORT_BUDGET_INITIAL_DETAILS] PRIMARY KEY  CLUSTERED 
	(
		[IdImport],
		[IdRow]
	)  ON [PRIMARY] 
GO

CREATE  INDEX [IX_IMPORT_BUDGET_INITIAL_DETAILS] ON [dbo].[IMPORT_BUDGET_INITIAL_DETAILS]([IdImport]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

ALTER TABLE [dbo].[IMPORT_BUDGET_INITIAL] ADD 
	CONSTRAINT [FK_IMPORT_BUDGET_INITIAL_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[IMPORT_BUDGET_INITIAL_DETAILS] ADD 
	CONSTRAINT [FK_IMPORT_BUDGET_INITIAL_DETAILS_IMPORT_BUDGET_INITIAL] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[IMPORT_BUDGET_INITIAL] (
		[IdImport]
	)
GO