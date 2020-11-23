
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_WORK_PACKAGES_TEMPLATE_PROJECT_PHASES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[WORK_PACKAGES_TEMPLATE] DROP CONSTRAINT FK_WORK_PACKAGES_TEMPLATE_PROJECT_PHASES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_WORK_PACKAGES_TEMPLATE_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[WORK_PACKAGES_TEMPLATE] DROP CONSTRAINT FK_WORK_PACKAGES_TEMPLATE_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WORK_PACKAGES_TEMPLATE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[WORK_PACKAGES_TEMPLATE]
GO



CREATE TABLE [dbo].[WORK_PACKAGES_TEMPLATE] (
	[IdPhase] [int] NOT NULL ,
	[Id] [int] NOT NULL ,
	[Code] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Rank] [int] NOT NULL ,
	[IsActive] [bit] NOT NULL ,
	[LastUpdate] [datetime] NOT NULL ,
	[LastUserUpdate] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[WORK_PACKAGES_TEMPLATE] WITH NOCHECK ADD 
	CONSTRAINT [PK_WORK_PACKAGES_TEMPLATE] PRIMARY KEY  CLUSTERED 
	(
		[IdPhase],
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[WORK_PACKAGES_TEMPLATE] ADD 
	CONSTRAINT [UQ_WORK_PACKAGES_TEMPLATE] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] ,
	CONSTRAINT [UQ_WORK_PACKAGES_TEMPLATE_Code] UNIQUE  NONCLUSTERED 
	(
		[Code]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[WORK_PACKAGES_TEMPLATE] ADD 
	CONSTRAINT [FK_WORK_PACKAGES_TEMPLATE_ASSOCIATES] FOREIGN KEY 
	(
		[LastUserUpdate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_WORK_PACKAGES_TEMPLATE_PROJECT_PHASES] FOREIGN KEY 
	(
		[IdPhase]
	) REFERENCES [dbo].[PROJECT_PHASES] (
		[Id]
	)
GO

----------------------------------------------------------------

DELETE FROM MODULES WHERE Code = 'WPT'

INSERT INTO MODULES 	([Code],[Name])
VALUES			('WPT','Work Package Template')

DELETE FROM ROLE_RIGHTS WHERE CodeModule = 'WPT'
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (1, 'WPT', 1, 1)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (1, 'WPT', 2, 1)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (1, 'WPT', 3, 1)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (1, 'WPT', 4, 1)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (2, 'WPT', 1, 1)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (2, 'WPT', 2, 1)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (2, 'WPT', 3, 1)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (2, 'WPT', 4, 1)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (3, 'WPT', 1, 1)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (3, 'WPT', 2, 3)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (3, 'WPT', 3, 3)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (3, 'WPT', 4, 3)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (4, 'WPT', 1, 2)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (4, 'WPT', 2, 3)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (4, 'WPT', 3, 2)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (4, 'WPT', 4, 3)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (5, 'WPT', 1, 2)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (5, 'WPT', 2, 3)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (5, 'WPT', 3, 3)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (5, 'WPT', 4, 3)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (6, 'WPT', 1, 1)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (6, 'WPT', 2, 3)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (6, 'WPT', 3, 3)
INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (6, 'WPT', 4, 3)

