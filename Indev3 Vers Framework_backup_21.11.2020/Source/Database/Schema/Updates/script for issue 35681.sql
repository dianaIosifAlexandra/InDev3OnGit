
--Creation of [IMPORT_SOURCES_COUNTRIES]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_SOURCES_COUNTRIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_SOURCES_COUNTRIES]
GO
CREATE TABLE [dbo].[IMPORT_SOURCES_COUNTRIES](
	[IdImportSource] [int] NOT NULL,
	[IdCountry] [int] NOT NULL,
 CONSTRAINT [PK_IMPORT_SOURCES_COUNTRIES] PRIMARY KEY CLUSTERED 
(
	[IdImportSource] ASC,
	[IdCountry] ASC
)WITH FILLFACTOR = 90 ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IMPORT_SOURCES_COUNTRIES]  WITH CHECK ADD  CONSTRAINT [FK_IMPORT_SOURCES_COUNTRIES_SOURCE] FOREIGN KEY([IdImportSource])
REFERENCES [dbo].[IMPORT_SOURCES] ([Id])
GO
ALTER TABLE [dbo].[IMPORT_SOURCES_COUNTRIES] CHECK CONSTRAINT [FK_IMPORT_SOURCES_COUNTRIES_SOURCE]
GO
ALTER TABLE [dbo].[IMPORT_SOURCES_COUNTRIES]  WITH CHECK ADD  CONSTRAINT [FK_IMPORT_SOURCES_COUNTRIES_COUNTRY] FOREIGN KEY([IdCountry])
REFERENCES [dbo].[COUNTRIES] ([Id])
GO
ALTER TABLE [dbo].[IMPORT_SOURCES_COUNTRIES] CHECK CONSTRAINT [FK_IMPORT_SOURCES_COUNTRIES_COUNTRY]
GO

--Add data
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(13, 1 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(17, 2 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(12, 3 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(20, 4 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(1, 5 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(2, 6 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(4, 8 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(18, 10 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(10, 11 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(14, 13 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(15, 14 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(5, 15 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(16, 17 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES] ([IdImportSource], [IdCountry]) VALUES(19, 20 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES]	([IdImportSource], [IdCountry]) VALUES(21, 12 )
INSERT INTO [IMPORT_SOURCES_COUNTRIES]	([IdImportSource], [IdCountry]) VALUES(3, 16 )
GO

--Modify [impDeleteImportSourcesCountries] 
--Modify [impWriteToActualTable]


