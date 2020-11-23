update Roles
set Name='Key User'
where Name='Trainer'

  if not exists(select * from [BUDGET_STATES] where StateCode='U')
	  insert into [BUDGET_STATES]
	  select 'U', 'Uploaded'
go


if not exists(select * from ROLE_RIGHTS where CodeModule='IBU' and IdRole=8)
	insert into ROLE_RIGHTS
	select 8,'IBU',1,1
else
	update ROLE_RIGHTS
	set IdPermission=1
	where CodeModule='IBU' and IdRole=8
go

if not exists(select * from MODULES where Code='TKD')
	insert into MODULES
	select 'TKD','Tracking Data'

go

if not exists(select * from ROLE_RIGHTS where codeModule='TKD' and IdRole=1)
   insert into ROLE_RIGHTS
   select 1,'TKD',1,1
go

if not exists(select * from ROLE_RIGHTS where codeModule='TKD' and IdRole=8)
   insert into ROLE_RIGHTS
   select 8,'TKD',1,1
go

if not exists(select * from Information_Schema.TABLES where Table_name='TRACKING_ACTIONS')
create table TRACKING_ACTIONS
(IdAction int identity(1,1) Primary Key,
ActionName varchar(100))

go


if (select count(*) from TRACKING_ACTIONS) = 0
	insert into TRACKING_ACTIONS
	(ActionName)
	values
	('Updated data'),
	('Submitted data'),
	('Updated Interco'), 
	('Approved Initial/Revised/Reforecast Budget'),
	('Disapproved Initial/Revised/Reforecast Budget'),
	('Validated Initial/Revised/Reforecast Budget'),
	('Uploaded Initial Budget'),
	('Uploaded Revised Budget')

go


if not exists(select * from Information_Schema.TABLES where Table_name='TRACKING_ACTIVITY_LOG')
begin

	CREATE TABLE [dbo].[TRACKING_ACTIVITY_LOG](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[IdAssociate] [int] NOT NULL,
		[IdRole] [int] NOT NULL,
		[IdMemberImpersonated] [int] NULL,
		[IdFunctionImpersonated] [int] NULL,
		[ProjectCode] [varchar](10) NULL,
		[IdAction] [int] NULL,
		[IdGeneration] [int] NULL,
		[LogDate] [datetime] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]


	SET ANSI_PADDING OFF

	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG]  WITH CHECK ADD  CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_ASSOCIATES] FOREIGN KEY([IdAssociate])
	REFERENCES [dbo].[ASSOCIATES] ([Id])

	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG] CHECK CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_ASSOCIATES]

	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG]  WITH CHECK ADD  CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_FUNCTIONS] FOREIGN KEY([IdFunctionImpersonated])
	REFERENCES [dbo].[FUNCTIONS] ([Id])

	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG] CHECK CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_FUNCTIONS]

	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG]  WITH CHECK ADD  CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_ROLE] FOREIGN KEY([IdRole])
	REFERENCES [dbo].[ROLES] ([Id])

	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG] CHECK CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_ROLE]

	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG]  WITH CHECK ADD  CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_PROJECTS] FOREIGN KEY([ProjectCode])
	REFERENCES [dbo].[PROJECTS] ([Code])

	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG] CHECK CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_PROJECTS]

	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG]  WITH CHECK ADD  CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_TRACKING_ACTIONS] FOREIGN KEY([IdAction])
	REFERENCES [dbo].[TRACKING_ACTIONS] ([IdAction])

	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG] CHECK CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_TRACKING_ACTIONS]

end