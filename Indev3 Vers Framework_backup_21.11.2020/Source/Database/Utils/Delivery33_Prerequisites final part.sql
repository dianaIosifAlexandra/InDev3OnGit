if not exists(select * from Modules where Code='RBU')
	insert into Modules
	select 'RBU', 'Revised Budget Upload'

go

if not exists(select * from ROLE_RIGHTS where CodeModule='RBU' and IdRole=1)
	insert into ROLE_RIGHTS
	select 1,'RBU', 1, 1

go

if not exists(select * from ROLE_RIGHTS where CodeModule='RBU' and IdRole=8)
	insert into ROLE_RIGHTS
	select 8,'RBU', 1, 1

go


if not exists(select * from Information_Schema.Columns where table_name='[TRACKING_ACTIVITY_LOG]' and column_name='IdProject')
begin
	alter table TRACKING_ACTIVITY_LOG
	add IdProject int
	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG]  WITH CHECK ADD  CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_PROJECTS2] FOREIGN KEY([IdProject])
	REFERENCES [dbo].[PROJECTS] ([Id])

	ALTER TABLE [dbo].[TRACKING_ACTIVITY_LOG] CHECK CONSTRAINT [FK_TRACKING_ACTIVITY_LOG_PROJECTS]
end
go

if exists(select * from Information_Schema.Columns where table_name='[TRACKING_ACTIVITY_LOG]' and column_name='ProjectCode')
begin
	update a
	set IdProject = p.Id
	from TRACKING_ACTIVITY_LOG a
	join Projects p on a.ProjectCode = p.Code

	alter table TRACKING_ACTIVITY_LOG
	drop constraint FK_TRACKING_ACTIVITY_LOG_PROJECTS

	alter table TRACKING_ACTIVITY_LOG
	drop column ProjectCode
end
go


if not exists(select * from Information_Schema.tables where table_name='IMPORT_BUDGET_REVISED')
begin
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	SET ANSI_PADDING ON

	CREATE TABLE [dbo].[IMPORT_BUDGET_REVISED](
		[IdImport] [int] NOT NULL,
		[ImportDate] [datetime] NOT NULL,
		[FileName] [varchar](50) NOT NULL,
		[IdAssociate] [int] NOT NULL,
	 CONSTRAINT [PK_IMPORT_BUDGET_REVISED] PRIMARY KEY CLUSTERED 
	(
		[IdImport] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
	) ON [PRIMARY]


	SET ANSI_PADDING OFF

	ALTER TABLE [dbo].[IMPORT_BUDGET_REVISED]  WITH CHECK ADD  CONSTRAINT [FK_IMPORT_BUDGET_REVISED_ASSOCIATES] FOREIGN KEY([IdAssociate])
	REFERENCES [dbo].[ASSOCIATES] ([Id])

	ALTER TABLE [dbo].[IMPORT_BUDGET_REVISED] CHECK CONSTRAINT [FK_IMPORT_BUDGET_REVISED_ASSOCIATES]

end

go


if not exists(select * from Information_Schema.tables where table_name='IMPORT_BUDGET_REVISED_DETAILS')
begin
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	SET ANSI_PADDING ON

	CREATE TABLE [dbo].[IMPORT_BUDGET_REVISED_DETAILS](
		[IdImport] [int] NOT NULL,
		[IdRow] [int] NOT NULL,
		[ProjectCode] [varchar](10) NOT NULL,
		[WPCode] [varchar](4) NOT NULL,
		[AssociateNumber] [varchar](15) NOT NULL,
		[CountryCode] [varchar](3) NOT NULL,
		[CostCenterCode] [varchar](10) NOT NULL,
		[HoursQty] [int] NULL,
		[HoursVal] [decimal](18, 4) NULL,
		[SalesVal] [decimal](18, 4) NULL,
		[TE] [decimal](18, 4) NULL,
		[ProtoParts] [decimal](18, 4) NULL,
		[ProtoTooling] [decimal](18, 4) NULL,
		[Trials] [decimal](18, 4) NULL,
		[OtherExpenses] [decimal](18, 4) NULL,
		[CurrencyCode] [varchar](3) NOT NULL,
	 CONSTRAINT [PK_IMPORT_BUDGET_REVISED_DETAILS] PRIMARY KEY CLUSTERED 
	(
		[IdImport] ASC,
		[IdRow] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
	) ON [PRIMARY]


	SET ANSI_PADDING OFF

	ALTER TABLE [dbo].[IMPORT_BUDGET_REVISED_DETAILS]  WITH CHECK ADD  CONSTRAINT [FK_IMPORT_BUDGET_REVISED_DETAILS_IMPORT_BUDGET_REVISED] FOREIGN KEY([IdImport])
	REFERENCES [dbo].[IMPORT_BUDGET_REVISED] ([IdImport])

	ALTER TABLE [dbo].[IMPORT_BUDGET_REVISED_DETAILS] CHECK CONSTRAINT [FK_IMPORT_BUDGET_REVISED_DETAILS_IMPORT_BUDGET_REVISED]

end

go

