IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'INERGY_INDEV3_20100629')
	DROP DATABASE [INERGY_INDEV3_20100629]
GO

CREATE DATABASE [INERGY_INDEV3_20100629]  ON (NAME = N'INDEV3_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\Data\INERGY_INDEV3_20100629.mdf' , SIZE = 268, FILEGROWTH = 10%) LOG ON (NAME = N'INDEV3_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\Data\INERGY_INDEV3_20100629_log.ldf' , SIZE = 291, MAXSIZE = 300, FILEGROWTH = 10%), (NAME = N'INDEV3_1_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\Data\INERGY_INDEV3_20100629_log_1.ldf' , SIZE = 1104, FILEGROWTH = 10%)
 COLLATE SQL_Latin1_General_CP1_CI_AS
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'autoclose', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'bulkcopy', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'trunc. log', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'torn page detection', N'true'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'read only', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'dbo use', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'single', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'autoshrink', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'ANSI null default', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'recursive triggers', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'ANSI nulls', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'concat null yields null', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'cursor close on commit', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'default to local cursor', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'quoted identifier', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'ANSI warnings', N'false'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'auto create statistics', N'true'
GO

exec sp_dboption N'INERGY_INDEV3_20100629', N'auto update statistics', N'true'
GO

use [INERGY_INDEV3_20100629]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_COSTS_ACTUAL_DATA]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_COSTS_ACTUAL_DATA
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAILS_ACTUAL_DATA]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_HOURS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAILS_ACTUAL_DATA
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_SALES_ACTUAL_DATA]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_SALES] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_SALES_ACTUAL_DATA
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_ANNUAL_BUDGET]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_ANNUAL_BUDGET
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_ANNUAL_BUDGET]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_ANNUAL_BUDGET
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_ANNUAL_BUDGET]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_SALES] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_ANNUAL_BUDGET
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_ANNUAL_BUDGET_IMPORTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_ANNUAL_BUDGET_IMPORTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_ANNUAL_BUDGET_IMPORTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_ANNUAL_BUDGET_IMPORTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_ANNUAL_BUDGET_IMPORTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_SALES] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_ANNUAL_BUDGET_IMPORTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_IMPORT_DETAILS_ANNUAL_BUDGET_IMPORTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORT_DETAILS] DROP CONSTRAINT FK_ANNUAL_BUDGET_IMPORT_DETAILS_ANNUAL_BUDGET_IMPORTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_IMPORT_LOGS_ANNUAL_BUDGET_IMPORTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORT_LOGS] DROP CONSTRAINT FK_ANNUAL_BUDGET_IMPORT_LOGS_ANNUAL_BUDGET_IMPORTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_IMPORT_LOGS_DETAILS_ANNUAL_BUDGET_IMPORT_LOGS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORT_LOGS_DETAILS] DROP CONSTRAINT FK_ANNUAL_BUDGET_IMPORT_LOGS_DETAILS_ANNUAL_BUDGET_IMPORT_LOGS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_COSTS_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_COSTS_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAILS_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_HOURS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAILS_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_SALES_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_SALES] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_SALES_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_IMPORTS_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORTS] DROP CONSTRAINT FK_ANNUAL_BUDGET_IMPORTS_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ASSOCIATE_ROLES_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ASSOCIATE_ROLES] DROP CONSTRAINT FK_ASSOCIATE_ROLES_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_DETAIL_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL] DROP CONSTRAINT FK_BUDGET_INITIAL_DETAIL_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_STATES_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_STATES] DROP CONSTRAINT FK_BUDGET_INITIAL_STATES_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_DETAIL_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL] DROP CONSTRAINT FK_BUDGET_REVISED_DETAIL_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_STATES_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_STATES] DROP CONSTRAINT FK_BUDGET_REVISED_STATES_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REFORECAST_DETAIL_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL] DROP CONSTRAINT FK_BUDGET_REFORECAST_DETAIL_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_STATES_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_STATES] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_STATES_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_BUDGET_INITIAL_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_BUDGET_INITIAL] DROP CONSTRAINT FK_IMPORT_BUDGET_INITIAL_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORTS_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORTS] DROP CONSTRAINT FK_IMPORTS_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROJECT_CORE_TEAMS_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PROJECT_CORE_TEAMS] DROP CONSTRAINT FK_PROJECT_CORE_TEAMS_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_USER_SETTINGS_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[USER_SETTINGS] DROP CONSTRAINT FK_USER_SETTINGS_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_WORK_PACKAGES_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[WORK_PACKAGES] DROP CONSTRAINT FK_WORK_PACKAGES_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_WORK_PACKAGES_TEMPLATE_ASSOCIATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[WORK_PACKAGES_TEMPLATE] DROP CONSTRAINT FK_WORK_PACKAGES_TEMPLATE_ASSOCIATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_COSTS_BUDGET_COST_TYPES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_COSTS_BUDGET_COST_TYPES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_BUDGET_COST_TYPES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_BUDGET_COST_TYPES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_DETAIL_COSTS_BUDGET_COST_TYPES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_INITIAL_DETAIL_COSTS_BUDGET_COST_TYPES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_DETAIL_COSTS_BUDGET_COST_TYPES1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_REVISED_DETAIL_COSTS_BUDGET_COST_TYPES1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_BUDGET_COST_TYPES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_BUDGET_COST_TYPES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_DETAIL_BUDGET_INITIAL]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL] DROP CONSTRAINT FK_BUDGET_INITIAL_DETAIL_BUDGET_INITIAL
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_STATES_BUDGET_INITIAL]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_STATES] DROP CONSTRAINT FK_BUDGET_INITIAL_STATES_BUDGET_INITIAL
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_DETAIL_COSTS_BUDGET_INITIAL_DETAIL]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_INITIAL_DETAIL_COSTS_BUDGET_INITIAL_DETAIL
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_DETAIL_BUDGET_REVISED]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL] DROP CONSTRAINT FK_BUDGET_REVISED_DETAIL_BUDGET_REVISED
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_STATES_BUDGET_REVISED]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_STATES] DROP CONSTRAINT FK_BUDGET_REVISED_STATES_BUDGET_REVISED
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_DETAIL_COSTS_BUDGET_REVISED_DETAIL]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_REVISED_DETAIL_COSTS_BUDGET_REVISED_DETAIL
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_STATES_BUDGET_STATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_STATES] DROP CONSTRAINT FK_BUDGET_INITIAL_STATES_BUDGET_STATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_STATES_BUDGET_STATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_STATES] DROP CONSTRAINT FK_BUDGET_REVISED_STATES_BUDGET_STATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_STATES_BUDGET_STATES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_STATES] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_STATES_BUDGET_STATES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REFORECAST_DETAIL_BUDGET_REFORECAST]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL] DROP CONSTRAINT FK_BUDGET_REFORECAST_DETAIL_BUDGET_REFORECAST
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_STATES_BUDGET_TOCOMPLETION]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_STATES] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_STATES_BUDGET_TOCOMPLETION
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_BUDGET_TOCOMPLETION_DETAIL]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_BUDGET_TOCOMPLETION_DETAIL
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_DETAIL_BUDGET_TOCOMPLETION_PROGRESS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_DETAIL_BUDGET_TOCOMPLETION_PROGRESS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_COSTS_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_COSTS_COST_CENTERS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAILS_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_HOURS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAILS_COST_CENTERS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_SALES_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_SALES] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_SALES_COST_CENTERS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_COST_CENTERS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_COST_CENTERS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_SALES] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_COST_CENTERS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_DETAIL_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL] DROP CONSTRAINT FK_BUDGET_INITIAL_DETAIL_COST_CENTERS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_DETAIL_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL] DROP CONSTRAINT FK_BUDGET_REVISED_DETAIL_COST_CENTERS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REFORECAST_DETAIL_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL] DROP CONSTRAINT FK_BUDGET_REFORECAST_DETAIL_COST_CENTERS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_HOURLY_RATES_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[HOURLY_RATES] DROP CONSTRAINT FK_HOURLY_RATES_COST_CENTERS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_GL_ACCOUNTS_COST_TYPES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[GL_ACCOUNTS] DROP CONSTRAINT FK_GL_ACCOUNTS_COST_TYPES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ASSOCIATES_COUNTRIES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ASSOCIATES] DROP CONSTRAINT FK_ASSOCIATES_COUNTRIES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROJECT_NATURE_COUNTRIES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[GL_ACCOUNTS] DROP CONSTRAINT FK_PROJECT_NATURE_COUNTRIES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_SOURCES_COUNTRIES_COUNTRY]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_SOURCES_COUNTRIES] DROP CONSTRAINT FK_IMPORT_SOURCES_COUNTRIES_COUNTRY
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_INERGY_SITES_COUNTRIES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[INERGY_LOCATIONS] DROP CONSTRAINT FK_INERGY_SITES_COUNTRIES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_OLAP_GARates_COUNTRIES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[OLAP_GA_RATES] DROP CONSTRAINT FK_OLAP_GARates_COUNTRIES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROJECTS_INTERCO_COUNTRIES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PROJECTS_INTERCO] DROP CONSTRAINT FK_PROJECTS_INTERCO_COUNTRIES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROJECTS_INTERCO_LAYOUT_COUNTRIES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PROJECTS_INTERCO_LAYOUT] DROP CONSTRAINT FK_PROJECTS_INTERCO_LAYOUT_COUNTRIES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_COUNTRIES_CURRENCIES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[COUNTRIES] DROP CONSTRAINT FK_COUNTRIES_CURRENCIES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_EXCHANGE_RATES_CURRENCIES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[EXCHANGE_RATES] DROP CONSTRAINT FK_EXCHANGE_RATES_CURRENCIES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_GROUPS_DEPARTMENTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[COST_CENTERS] DROP CONSTRAINT FK_GROUPS_DEPARTMENTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_EXCHANGE_RATES_CATEGORIES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[EXCHANGE_RATES] DROP CONSTRAINT FK_EXCHANGE_RATES_CATEGORIES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_DEPARTMENTS_FUNCTIONS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[DEPARTMENTS] DROP CONSTRAINT FK_DEPARTMENTS_FUNCTIONS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_COSTS_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_COSTS_GL_ACCOUNTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAILS_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_HOURS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAILS_GL_ACCOUNTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_SALES_GL_ACCOUNTS1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_SALES] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_SALES_GL_ACCOUNTS1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_GL_ACCOUNTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_GL_ACCOUNTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_SALES] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_GL_ACCOUNTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_DETAIL_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL] DROP CONSTRAINT FK_BUDGET_INITIAL_DETAIL_GL_ACCOUNTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_DETAIL_GL_ACCOUNTS1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL] DROP CONSTRAINT FK_BUDGET_INITIAL_DETAIL_GL_ACCOUNTS1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_DETAIL_COSTS_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_INITIAL_DETAIL_COSTS_GL_ACCOUNTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_DETAIL_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL] DROP CONSTRAINT FK_BUDGET_REVISED_DETAIL_GL_ACCOUNTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_DETAIL_GL_ACCOUNTS1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL] DROP CONSTRAINT FK_BUDGET_REVISED_DETAIL_GL_ACCOUNTS1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_DETAIL_COSTS_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_REVISED_DETAIL_COSTS_GL_ACCOUNTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_DETAIL_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_DETAIL_GL_ACCOUNTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_DETAIL_GL_ACCOUNTS1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_DETAIL_GL_ACCOUNTS1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_GL_ACCOUNTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_COSTS_IMPORTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_COSTS_IMPORTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_HOURS_IMPORTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_HOURS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_HOURS_IMPORTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_SALES_IMPORTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_SALES] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_SALES_IMPORTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_DETAILS_IMPORTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_DETAILS] DROP CONSTRAINT FK_IMPORT_DETAILS_IMPORTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_DETAILS_KEYROWS_MISSING_IMPORTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_DETAILS_KEYROWS_MISSING] DROP CONSTRAINT FK_IMPORT_DETAILS_KEYROWS_MISSING_IMPORTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_LOGS_IMPORTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_LOGS] DROP CONSTRAINT FK_IMPORT_LOGS_IMPORTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_SOURCES_IMPORT_APPLICATION_TYPES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_SOURCES] DROP CONSTRAINT FK_IMPORT_SOURCES_IMPORT_APPLICATION_TYPES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_BUDGET_INITIAL_DETAILS_IMPORT_BUDGET_INITIAL]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_BUDGET_INITIAL_DETAILS] DROP CONSTRAINT FK_IMPORT_BUDGET_INITIAL_DETAILS_IMPORT_BUDGET_INITIAL
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_LOGS_DETAILS_IMPORT_DETAILS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_LOGS_DETAILS] DROP CONSTRAINT FK_IMPORT_LOGS_DETAILS_IMPORT_DETAILS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_LOGS_DETAILS_KEYROWS_MISSING_IMPORT_DETAILS_KEYROWS_MISSING]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_LOGS_DETAILS_KEYROWS_MISSING] DROP CONSTRAINT FK_IMPORT_LOGS_DETAILS_KEYROWS_MISSING_IMPORT_DETAILS_KEYROWS_MISSING
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_LOGS_DETAILS_IMPORT_LOGS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_LOGS_DETAILS] DROP CONSTRAINT FK_IMPORT_LOGS_DETAILS_IMPORT_LOGS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_LOGS_DETAILS_KEYROWS_MISSING_IMPORT_LOGS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_LOGS_DETAILS_KEYROWS_MISSING] DROP CONSTRAINT FK_IMPORT_LOGS_DETAILS_KEYROWS_MISSING_IMPORT_LOGS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_LOGS_IMPORT_SOURCES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_LOGS] DROP CONSTRAINT FK_IMPORT_LOGS_IMPORT_SOURCES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_SOURCES_COUNTRIES_SOURCE]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_SOURCES_COUNTRIES] DROP CONSTRAINT FK_IMPORT_SOURCES_COUNTRIES_SOURCE
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_GROUPS_INERGY_SITES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[COST_CENTERS] DROP CONSTRAINT FK_GROUPS_INERGY_SITES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ERROR_MESSAGES_LANGUAGES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ERROR_MESSAGES] DROP CONSTRAINT FK_ERROR_MESSAGES_LANGUAGES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IMPORT_LOGS_DETAILS_MODULES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IMPORT_LOGS_DETAILS] DROP CONSTRAINT FK_IMPORT_LOGS_DETAILS_MODULES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ROLE_RIGHTS_MODULES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ROLE_RIGHTS] DROP CONSTRAINT FK_ROLE_RIGHTS_MODULES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ROLE_RIGHTS_OPERATIONS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ROLE_RIGHTS] DROP CONSTRAINT FK_ROLE_RIGHTS_OPERATIONS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROGRAMS_PROGRAM_OWNERS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PROGRAMS] DROP CONSTRAINT FK_PROGRAMS_PROGRAM_OWNERS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROGRAM_OWNERS_PROGRAM_ORGANIZATIONS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[OWNERS] DROP CONSTRAINT FK_PROGRAM_OWNERS_PROGRAM_ORGANIZATIONS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ROLE_RIGHTS_PERMISSIONS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ROLE_RIGHTS] DROP CONSTRAINT FK_ROLE_RIGHTS_PERMISSIONS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROJECTS_PROGRAMS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PROJECTS] DROP CONSTRAINT FK_PROJECTS_PROGRAMS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_PROJECTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA] DROP CONSTRAINT FK_ACTUAL_DATA_PROJECTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROJECT_CORE_TEAMS_PROJECTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PROJECT_CORE_TEAMS] DROP CONSTRAINT FK_PROJECT_CORE_TEAMS_PROJECTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROJECTS_INTERCO_LAYOUT_PROJECTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PROJECTS_INTERCO_LAYOUT] DROP CONSTRAINT FK_PROJECTS_INTERCO_LAYOUT_PROJECTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_WORK_PACKAGES_PROJECTS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[WORK_PACKAGES] DROP CONSTRAINT FK_WORK_PACKAGES_PROJECTS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_DETAIL_PROJECT_CORE_TEAMS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL] DROP CONSTRAINT FK_BUDGET_INITIAL_DETAIL_PROJECT_CORE_TEAMS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_DETAIL_COSTS_PROJECT_CORE_TEAMS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_INITIAL_DETAIL_COSTS_PROJECT_CORE_TEAMS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_STATES_PROJECT_CORE_TEAMS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_STATES] DROP CONSTRAINT FK_BUDGET_INITIAL_STATES_PROJECT_CORE_TEAMS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_DETAIL_PROJECT_CORE_TEAMS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL] DROP CONSTRAINT FK_BUDGET_REVISED_DETAIL_PROJECT_CORE_TEAMS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_DETAIL_COSTS_PROJECT_CORE_TEAMS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_REVISED_DETAIL_COSTS_PROJECT_CORE_TEAMS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_STATES_PROJECT_CORE_TEAMS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_STATES] DROP CONSTRAINT FK_BUDGET_REVISED_STATES_PROJECT_CORE_TEAMS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_DETAIL_PROJECT_CORE_TEAMS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_DETAIL_PROJECT_CORE_TEAMS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_PROJECT_CORE_TEAMS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL_COSTS] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_PROJECT_CORE_TEAMS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_PROGRESS_PROJECT_CORE_TEAMS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_PROGRESS] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_PROGRESS_PROJECT_CORE_TEAMS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_TOCOMPLETION_STATES_PROJECT_CORE_TEAMS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_STATES] DROP CONSTRAINT FK_BUDGET_TOCOMPLETION_STATES_PROJECT_CORE_TEAMS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROJECT_CORE_TEAMS_PROJECT_FUNCTIONS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PROJECT_CORE_TEAMS] DROP CONSTRAINT FK_PROJECT_CORE_TEAMS_PROJECT_FUNCTIONS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_WORK_PACKAGES_PROJECT_PHASES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[WORK_PACKAGES] DROP CONSTRAINT FK_WORK_PACKAGES_PROJECT_PHASES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_WORK_PACKAGES_TEMPLATE_PROJECT_PHASES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[WORK_PACKAGES_TEMPLATE] DROP CONSTRAINT FK_WORK_PACKAGES_TEMPLATE_PROJECT_PHASES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROJECTS_PROJECT_TYPES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PROJECTS] DROP CONSTRAINT FK_PROJECTS_PROJECT_TYPES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_COUNTRIES_REGIONS]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[COUNTRIES] DROP CONSTRAINT FK_COUNTRIES_REGIONS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ASSOCIATE_ROLES_ROLES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ASSOCIATE_ROLES] DROP CONSTRAINT FK_ASSOCIATE_ROLES_ROLES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ROLE_RIGHTS_ROLES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ROLE_RIGHTS] DROP CONSTRAINT FK_ROLE_RIGHTS_ROLES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_COSTS_WORK_PACKAGES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_COSTS_WORK_PACKAGES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAILS_WORK_PACKAGES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_HOURS] DROP CONSTRAINT FK_ACTUAL_DATA_DETAILS_WORK_PACKAGES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ACTUAL_DATA_DETAIL_SALES_WORK_PACKAGES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_SALES] DROP CONSTRAINT FK_ACTUAL_DATA_DETAIL_SALES_WORK_PACKAGES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_WORK_PACKAGES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_COSTS_WORK_PACKAGES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_WORK_PACKAGES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_WORK_PACKAGES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_WORK_PACKAGES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_SALES] DROP CONSTRAINT FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_WORK_PACKAGES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_INITIAL_DETAIL_WORK_PACKAGES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL] DROP CONSTRAINT FK_BUDGET_INITIAL_DETAIL_WORK_PACKAGES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REVISED_DETAIL_WORK_PACKAGES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL] DROP CONSTRAINT FK_BUDGET_REVISED_DETAIL_WORK_PACKAGES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_BUDGET_REFORECAST_DETAIL_WORK_PACKAGES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL] DROP CONSTRAINT FK_BUDGET_REFORECAST_DETAIL_WORK_PACKAGES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PROJECTS_INTERCO_WORK_PACKAGES]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PROJECTS_INTERCO] DROP CONSTRAINT FK_PROJECTS_INTERCO_WORK_PACKAGES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACTUAL_DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACTUAL_DATA]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACTUAL_DATA_DETAILS_COSTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACTUAL_DATA_DETAILS_COSTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACTUAL_DATA_DETAILS_HOURS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACTUAL_DATA_DETAILS_HOURS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACTUAL_DATA_DETAILS_SALES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACTUAL_DATA_DETAILS_SALES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACTUAL_DATA_EXCLUSION_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACTUAL_DATA_EXCLUSION_COST_CENTERS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACTUAL_DATA_EXCLUSION_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACTUAL_DATA_EXCLUSION_GL_ACCOUNTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_BUDGET]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_BUDGET]
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

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_BUDGET_IMPORTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_BUDGET_IMPORTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_BUDGET_IMPORT_DETAILS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_BUDGET_IMPORT_DETAILS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_BUDGET_IMPORT_LOGS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_BUDGET_IMPORT_LOGS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_EXCLUSION_COST_CENTERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_EXCLUSION_COST_CENTERS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANNUAL_EXCLUSION_GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANNUAL_EXCLUSION_GL_ACCOUNTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ASSOCIATES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ASSOCIATES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ASSOCIATE_ROLES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ASSOCIATE_ROLES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_COST_TYPES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_COST_TYPES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_INITIAL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_INITIAL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_INITIAL_DETAIL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_INITIAL_DETAIL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_INITIAL_DETAIL_COSTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_INITIAL_DETAIL_COSTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_INITIAL_STATES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_INITIAL_STATES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_REVISED]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_REVISED]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_REVISED_DETAIL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_REVISED_DETAIL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_REVISED_DETAIL_COSTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_REVISED_DETAIL_COSTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_REVISED_STATES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_REVISED_STATES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_STATES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_STATES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_TOCOMPLETION]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_TOCOMPLETION]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_TOCOMPLETION_DETAIL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_TOCOMPLETION_DETAIL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_TOCOMPLETION_DETAIL_COSTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_TOCOMPLETION_DETAIL_COSTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_TOCOMPLETION_PROGRESS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_TOCOMPLETION_PROGRESS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_TOCOMPLETION_STATES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BUDGET_TOCOMPLETION_STATES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COST_CENTERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[COST_CENTERS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COST_INCOME_TYPES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[COST_INCOME_TYPES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COUNTRIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[COUNTRIES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CURRENCIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CURRENCIES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DEPARTMENTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DEPARTMENTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ERROR_MESSAGES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ERROR_MESSAGES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EXCHANGE_RATES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EXCHANGE_RATES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EXCHANGE_RATE_CATEGORIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EXCHANGE_RATE_CATEGORIES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FUNCTIONS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FUNCTIONS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GL_ACCOUNTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[GL_ACCOUNTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[HOURLY_RATES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[HOURLY_RATES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_APPLICATION_TYPES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_APPLICATION_TYPES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_BUDGET_INITIAL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_BUDGET_INITIAL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_BUDGET_INITIAL_DETAILS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_BUDGET_INITIAL_DETAILS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_DETAILS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_DETAILS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_DETAILS_KEYROWS_MISSING]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_DETAILS_KEYROWS_MISSING]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_LOGS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_LOGS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_LOGS_DETAILS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_LOGS_DETAILS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_LOGS_DETAILS_KEYROWS_MISSING]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_LOGS_DETAILS_KEYROWS_MISSING]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_SOURCES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_SOURCES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPORT_SOURCES_COUNTRIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IMPORT_SOURCES_COUNTRIES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[INERGY_LOCATIONS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[INERGY_LOCATIONS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LANGUAGES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[LANGUAGES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MODULES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MODULES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLAP_CATEGORIES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OLAP_CATEGORIES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLAP_GA_RATES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OLAP_GA_RATES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLAP_MARKUP_RATES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OLAP_MARKUP_RATES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLAP_MONTHS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OLAP_MONTHS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLAP_PERIODS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OLAP_PERIODS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLAP_SCALINGS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OLAP_SCALINGS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLAP_UNITS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OLAP_UNITS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLAP_YEARS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OLAP_YEARS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OPERATIONS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OPERATIONS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OWNERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OWNERS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OWNER_TYPES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OWNER_TYPES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PERMISSIONS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PERMISSIONS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROGRAMS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PROGRAMS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROJECTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PROJECTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROJECTS_INTERCO]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PROJECTS_INTERCO]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROJECTS_INTERCO_LAYOUT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PROJECTS_INTERCO_LAYOUT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROJECT_CORE_TEAMS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PROJECT_CORE_TEAMS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROJECT_FUNCTIONS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PROJECT_FUNCTIONS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROJECT_PHASES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PROJECT_PHASES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROJECT_TYPES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PROJECT_TYPES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[REGIONS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[REGIONS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ROLES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ROLES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ROLE_RIGHTS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ROLE_RIGHTS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USER_SETTINGS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USER_SETTINGS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WORK_PACKAGES]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[WORK_PACKAGES]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WORK_PACKAGES_TEMPLATE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[WORK_PACKAGES_TEMPLATE]
GO

CREATE TABLE [dbo].[ACTUAL_DATA] (
	[IdProject] [int] NOT NULL ,
	[Date] [smalldatetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACTUAL_DATA_DETAILS_COSTS] (
	[IdProject] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccount] [int] NOT NULL ,
	[IdCostType] [int] NOT NULL ,
	[CostVal] [decimal](18, 2) NOT NULL ,
	[DateImport] [smalldatetime] NOT NULL ,
	[IdImport] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACTUAL_DATA_DETAILS_HOURS] (
	[IdProject] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccount] [int] NOT NULL ,
	[HoursQty] [decimal](12, 2) NOT NULL ,
	[HoursVal] [decimal](18, 2) NOT NULL ,
	[DateImport] [smalldatetime] NOT NULL ,
	[IdImport] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACTUAL_DATA_DETAILS_SALES] (
	[IdProject] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccount] [int] NOT NULL ,
	[SalesVal] [decimal](18, 2) NOT NULL ,
	[DateImport] [smalldatetime] NOT NULL ,
	[IdImport] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACTUAL_DATA_EXCLUSION_COST_CENTERS] (
	[CountryCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CostCenterCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ACTUAL_DATA_EXCLUSION_GL_ACCOUNTS] (
	[CountryCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[GLAccountCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ANNUAL_BUDGET] (
	[IdProject] [int] NOT NULL ,
	[Date] [smalldatetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS] (
	[IdProject] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccount] [int] NOT NULL ,
	[IdCostType] [int] NOT NULL ,
	[CostVal] [decimal](18, 2) NOT NULL ,
	[DateImport] [smalldatetime] NOT NULL ,
	[IdImport] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS] (
	[IdProject] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccount] [int] NOT NULL ,
	[HoursQty] [int] NOT NULL ,
	[HoursVal] [decimal](18, 2) NOT NULL ,
	[DateImport] [smalldatetime] NOT NULL ,
	[IdImport] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_SALES] (
	[IdProject] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccount] [int] NOT NULL ,
	[SalesVal] [decimal](18, 2) NOT NULL ,
	[DateImport] [smalldatetime] NOT NULL ,
	[IdImport] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ANNUAL_BUDGET_IMPORTS] (
	[IdImport] [int] NOT NULL ,
	[ImportDate] [smalldatetime] NOT NULL ,
	[FileName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[ExclusionCostCenterRowsNo] [int] NOT NULL ,
	[ExclusionGlAccountsRowsNo] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ANNUAL_BUDGET_IMPORT_DETAILS] (
	[IdImport] [int] NOT NULL ,
	[IdRow] [int] NOT NULL ,
	[Country] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Year] [int] NULL ,
	[CostCenter] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProjectCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WPCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AccountNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Quantity] [decimal](18, 2) NULL ,
	[Value] [decimal](18, 2) NULL ,
	[CurrencyCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Date] [smalldatetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ANNUAL_BUDGET_IMPORT_LOGS] (
	[IdImport] [int] NOT NULL ,
	[Year] [int] NOT NULL ,
	[Validation] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ANNUAL_BUDGET_IMPORT_LOGS_DETAILS] (
	[IdImport] [int] NOT NULL ,
	[Id] [int] IDENTITY (1, 1) NOT NULL ,
	[IdRow] [int] NOT NULL ,
	[Details] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Module] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ANNUAL_EXCLUSION_COST_CENTERS] (
	[CountryCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CostCenterCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ANNUAL_EXCLUSION_GL_ACCOUNTS] (
	[CountryCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[GLAccountCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ASSOCIATES] (
	[Id] [int] NOT NULL ,
	[IdCountry] [int] NOT NULL ,
	[EmployeeNumber] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[InergyLogin] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IsActive] [bit] NOT NULL ,
	[PercentageFullTime] [int] NOT NULL ,
	[IsSubContractor] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ASSOCIATE_ROLES] (
	[IdAssociate] [int] NOT NULL ,
	[IdRole] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_COST_TYPES] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_INITIAL] (
	[IdProject] [int] NOT NULL ,
	[IsValidated] [bit] NOT NULL ,
	[ValidationDate] [smalldatetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_INITIAL_DETAIL] (
	[IdProject] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[HoursQty] [int] NULL ,
	[HoursVal] [decimal](18, 4) NULL ,
	[SalesVal] [decimal](18, 4) NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccountHours] [int] NOT NULL ,
	[IdAccountSales] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_INITIAL_DETAIL_COSTS] (
	[IdProject] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[IdCostType] [int] NOT NULL ,
	[CostVal] [decimal](18, 4) NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccount] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_INITIAL_STATES] (
	[IdProject] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[State] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[StateDate] [smalldatetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_REVISED] (
	[IdProject] [int] NOT NULL ,
	[IdGeneration] [int] NOT NULL ,
	[IsValidated] [bit] NOT NULL ,
	[ValidationDate] [smalldatetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_REVISED_DETAIL] (
	[IdProject] [int] NOT NULL ,
	[IdGeneration] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[HoursQty] [int] NULL ,
	[HoursVal] [decimal](18, 4) NULL ,
	[SalesVal] [decimal](18, 4) NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccountHours] [int] NOT NULL ,
	[IdAccountSales] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_REVISED_DETAIL_COSTS] (
	[IdProject] [int] NOT NULL ,
	[IdGeneration] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[IdCostType] [int] NOT NULL ,
	[CostVal] [decimal](18, 4) NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccount] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_REVISED_STATES] (
	[IdProject] [int] NOT NULL ,
	[IdGeneration] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[State] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[StateDate] [smalldatetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_STATES] (
	[StateCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_TOCOMPLETION] (
	[IdProject] [int] NOT NULL ,
	[IdGeneration] [int] NOT NULL ,
	[IsValidated] [bit] NOT NULL ,
	[ValidationDate] [smalldatetime] NULL ,
	[YearMonthActualData] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL] (
	[IdProject] [int] NOT NULL ,
	[IdGeneration] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[HoursQty] [int] NULL ,
	[HoursVal] [decimal](18, 4) NULL ,
	[SalesVal] [decimal](18, 4) NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccountHours] [int] NOT NULL ,
	[IdAccountSales] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL_COSTS] (
	[IdProject] [int] NOT NULL ,
	[IdGeneration] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCostCenter] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[IdCostType] [int] NOT NULL ,
	[CostVal] [decimal](18, 4) NULL ,
	[IdCountry] [int] NOT NULL ,
	[IdAccount] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_TOCOMPLETION_PROGRESS] (
	[IdProject] [int] NOT NULL ,
	[IdGeneration] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[Percent] [decimal](18, 2) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[BUDGET_TOCOMPLETION_STATES] (
	[IdProject] [int] NOT NULL ,
	[IdGeneration] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[State] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[StateDate] [smalldatetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[COST_CENTERS] (
	[Id] [int] NOT NULL ,
	[IdInergyLocation] [int] NOT NULL ,
	[Code] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IsActive] [bit] NOT NULL ,
	[IdDepartment] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[COST_INCOME_TYPES] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Rank] [tinyint] NOT NULL ,
	[DefaultAccount] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[COUNTRIES] (
	[Id] [int] NOT NULL ,
	[Code] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdRegion] [int] NULL ,
	[IdCurrency] [int] NOT NULL ,
	[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Rank] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CURRENCIES] (
	[Id] [int] NOT NULL ,
	[Code] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DEPARTMENTS] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdFunction] [int] NOT NULL ,
	[Rank] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ERROR_MESSAGES] (
	[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdLanguage] [int] NOT NULL ,
	[Message] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EXCHANGE_RATES] (
	[IdCategory] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[IdCurrencyTo] [int] NOT NULL ,
	[ConversionRate] [decimal](10, 4) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EXCHANGE_RATE_CATEGORIES] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[InFinanceCategoryId] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[FUNCTIONS] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Rank] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[GL_ACCOUNTS] (
	[IdCountry] [int] NOT NULL ,
	[Id] [int] NOT NULL ,
	[Account] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdCostType] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[HOURLY_RATES] (
	[IdCostCenter] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[HourlyRate] [decimal](12, 2) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IMPORTS] (
	[IdImport] [int] NOT NULL ,
	[ImportDate] [datetime] NOT NULL ,
	[FileName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[ExclusionCostCenterRowsNo] [int] NOT NULL ,
	[ExclusionGlAccountsRowsNo] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IMPORT_APPLICATION_TYPES] (
	[Id] [int] NOT NULL ,
	[Name] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
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
	[CountryCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
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

CREATE TABLE [dbo].[IMPORT_DETAILS] (
	[IdImport] [int] NOT NULL ,
	[IdRow] [int] NOT NULL ,
	[Country] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Year] [int] NULL ,
	[Month] [int] NULL ,
	[CostCenter] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProjectCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WPCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AccountNumber] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AssociateNumber] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Quantity] [decimal](18, 2) NULL ,
	[UnitQty] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Value] [decimal](18, 2) NULL ,
	[CurrencyCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Date] [smalldatetime] NULL 
) ON [PRIMARY]
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
	[Date] [smalldatetime] NULL ,
	[IdImportPrevious] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IMPORT_LOGS] (
	[IdImport] [int] NOT NULL ,
	[IdSource] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[Validation] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IMPORT_LOGS_DETAILS] (
	[IdImport] [int] NOT NULL ,
	[Id] [int] IDENTITY (1, 1) NOT NULL ,
	[IdRow] [int] NOT NULL ,
	[Details] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Module] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IMPORT_LOGS_DETAILS_KEYROWS_MISSING] (
	[IdImport] [int] NOT NULL ,
	[Id] [int] IDENTITY (1, 1) NOT NULL ,
	[IdRow] [int] NOT NULL ,
	[Details] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Module] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IMPORT_SOURCES] (
	[Id] [int] NOT NULL ,
	[IdApplicationTypes] [int] NULL ,
	[Code] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SourceName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Active] [bit] NOT NULL ,
	[Rank] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IMPORT_SOURCES_COUNTRIES] (
	[IdImportSource] [int] NOT NULL ,
	[IdCountry] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[INERGY_LOCATIONS] (
	[Id] [int] NOT NULL ,
	[Code] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdCountry] [int] NOT NULL ,
	[Rank] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[LANGUAGES] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[MODULES] (
	[Code] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OLAP_CATEGORIES] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Formula] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OLAP_GA_RATES] (
	[IdCountry] [int] NOT NULL ,
	[YearMonth] [int] NOT NULL ,
	[Rate] [decimal](18, 2) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OLAP_MARKUP_RATES] (
	[Year] [int] NOT NULL ,
	[Rate] [decimal](18, 2) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OLAP_MONTHS] (
	[Month] [int] NOT NULL ,
	[MonthName] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OLAP_PERIODS] (
	[YearMonthKey] [int] NOT NULL ,
	[Month] [int] NOT NULL ,
	[Year] [int] NOT NULL ,
	[MonthName] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OLAP_SCALINGS] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Formula] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OLAP_UNITS] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Formula] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OLAP_YEARS] (
	[Year] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OPERATIONS] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OWNERS] (
	[Id] [int] NOT NULL ,
	[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdOwnerType] [int] NOT NULL ,
	[Rank] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OWNER_TYPES] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PERMISSIONS] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROGRAMS] (
	[Id] [int] NOT NULL ,
	[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdOwner] [int] NOT NULL ,
	[IsActive] [bit] NOT NULL ,
	[Rank] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROJECTS] (
	[Id] [int] NOT NULL ,
	[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdProgram] [int] NOT NULL ,
	[IdProjectType] [int] NOT NULL ,
	[IsActive] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROJECTS_INTERCO] (
	[IdProject] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[IdWorkPackage] [int] NOT NULL ,
	[IdCountry] [int] NOT NULL ,
	[PercentAffected] [decimal](18, 2) NOT NULL ,
	[LastUpdate] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROJECTS_INTERCO_LAYOUT] (
	[IdProject] [int] NOT NULL ,
	[IdCountry] [int] NOT NULL ,
	[Position] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROJECT_CORE_TEAMS] (
	[IdProject] [int] NOT NULL ,
	[IdAssociate] [int] NOT NULL ,
	[IdFunction] [int] NOT NULL ,
	[LastUpdate] [datetime] NOT NULL ,
	[IsActive] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROJECT_FUNCTIONS] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[WPCodeSuffixes] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROJECT_PHASES] (
	[Id] [int] NOT NULL ,
	[Code] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROJECT_TYPES] (
	[Id] [int] NOT NULL ,
	[Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Rank] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[REGIONS] (
	[Id] [int] NOT NULL ,
	[Code] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Rank] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ROLES] (
	[Id] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ROLE_RIGHTS] (
	[IdRole] [int] NOT NULL ,
	[CodeModule] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IdOperation] [int] NOT NULL ,
	[IdPermission] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[USER_SETTINGS] (
	[AssociateId] [int] NOT NULL ,
	[AmountScaleOption] [int] NOT NULL ,
	[NumberOfRecordsPerPage] [int] NOT NULL ,
	[CurrencyRepresentation] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[WORK_PACKAGES] (
	[IdProject] [int] NOT NULL ,
	[IdPhase] [int] NOT NULL ,
	[Id] [int] NOT NULL ,
	[Code] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Rank] [int] NOT NULL ,
	[IsActive] [bit] NOT NULL ,
	[StartYearMonth] [int] NULL ,
	[EndYearMonth] [int] NULL ,
	[LastUpdate] [datetime] NOT NULL ,
	[LastUserUpdate] [int] NOT NULL 
) ON [PRIMARY]
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

ALTER TABLE [dbo].[ACTUAL_DATA] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACTUAL_DATA] PRIMARY KEY  CLUSTERED 
	(
		[IdProject]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_COSTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACTUAL_DATA_DETAIL_COSTS] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[YearMonth],
		[IdAssociate],
		[IdCountry],
		[IdAccount]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_HOURS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACTUAL_DATA_DETAILS] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[YearMonth],
		[IdAssociate],
		[IdCountry],
		[IdAccount]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_SALES] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACTUAL_DATA_DETAIL_SALES] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[YearMonth],
		[IdAssociate],
		[IdCountry],
		[IdAccount]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET] WITH NOCHECK ADD 
	CONSTRAINT [PK_ANNUAL_BUDGET] PRIMARY KEY  CLUSTERED 
	(
		[IdProject]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ANNUAL_BUDGET_DATA_DETAIL_COSTS] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[YearMonth],
		[IdCountry],
		[IdAccount]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ANNUAL_BUDGET_DATA_DETAILS] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[YearMonth],
		[IdCountry],
		[IdAccount]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_SALES] WITH NOCHECK ADD 
	CONSTRAINT [PK_ANNUAL_BUDGET_DATA_DETAILS_SALES] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[YearMonth],
		[IdCountry],
		[IdAccount]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ANNUAL_BUDGET_IMPORTS] PRIMARY KEY  CLUSTERED 
	(
		[IdImport]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORT_DETAILS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ANNUAL_BUDGET_IMPORT_DETAILS] PRIMARY KEY  CLUSTERED 
	(
		[IdImport],
		[IdRow]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORT_LOGS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ANNUAL_BUDGET_IMPORT_LOGS] PRIMARY KEY  CLUSTERED 
	(
		[IdImport]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORT_LOGS_DETAILS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ANNUAL_BUDGET_IMPORT_LOGS_DETAILS] PRIMARY KEY  CLUSTERED 
	(
		[IdImport],
		[Id],
		[IdRow]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ASSOCIATES] WITH NOCHECK ADD 
	CONSTRAINT [PK_ASSOCIATES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ASSOCIATE_ROLES] WITH NOCHECK ADD 
	CONSTRAINT [PK_ASSOCIATE_ROLES] PRIMARY KEY  CLUSTERED 
	(
		[IdAssociate],
		[IdRole]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_COST_TYPES] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_COST_TYPES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_INITIAL] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_INITIAL] PRIMARY KEY  CLUSTERED 
	(
		[IdProject]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_INITIAL_DETAIL] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL_COSTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_INITIAL_DETAIL_COSTS] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth],
		[IdCostType]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_INITIAL_STATES] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_INITIAL_STATES] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdAssociate]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_REVISED] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_REVISED] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdGeneration]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_REVISED_DETAIL] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdGeneration],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL_COSTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_REVISED_DETAIL_COSTS] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdGeneration],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth],
		[IdCostType]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_REVISED_STATES] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_REVISED_STATES] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdGeneration],
		[IdAssociate]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_STATES] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_STATES] PRIMARY KEY  CLUSTERED 
	(
		[StateCode]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_TOCOMPLETION] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_REFORECAST] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdGeneration]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_REFORECAST_DETAIL] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdGeneration],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL_COSTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_TOCOMPLETION_DETAIL_COSTS] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdGeneration],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth],
		[IdCostType]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_PROGRESS] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_TOCOMPLETION_PROGRESS] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdGeneration],
		[IdPhase],
		[IdAssociate],
		[IdWorkPackage]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_STATES] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_TOCOMPLETION_STATES] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdGeneration],
		[IdAssociate]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[COST_CENTERS] WITH NOCHECK ADD 
	CONSTRAINT [PK_COST_CENTERS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[COST_INCOME_TYPES] WITH NOCHECK ADD 
	CONSTRAINT [PK_COST_TYPES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[COUNTRIES] WITH NOCHECK ADD 
	CONSTRAINT [PK_Countries] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CURRENCIES] WITH NOCHECK ADD 
	CONSTRAINT [PK_CURRENCIES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DEPARTMENTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_DEPARTMENTS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ERROR_MESSAGES] WITH NOCHECK ADD 
	CONSTRAINT [PK_ERROR_MESSAGES] PRIMARY KEY  CLUSTERED 
	(
		[Code]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[EXCHANGE_RATES] WITH NOCHECK ADD 
	CONSTRAINT [PK_EXCHANGE_RATES] PRIMARY KEY  CLUSTERED 
	(
		[IdCategory],
		[YearMonth],
		[IdCurrencyTo]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[EXCHANGE_RATE_CATEGORIES] WITH NOCHECK ADD 
	CONSTRAINT [PK_CATEGORIES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FUNCTIONS] WITH NOCHECK ADD 
	CONSTRAINT [PK_FUNCTIONS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[GL_ACCOUNTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROJECT_NATURE] PRIMARY KEY  CLUSTERED 
	(
		[IdCountry],
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[HOURLY_RATES] WITH NOCHECK ADD 
	CONSTRAINT [PK_HOURLY_RATES] PRIMARY KEY  CLUSTERED 
	(
		[IdCostCenter],
		[YearMonth]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IMPORTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPORT_MASTER] PRIMARY KEY  CLUSTERED 
	(
		[IdImport]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IMPORT_APPLICATION_TYPES] WITH NOCHECK ADD 
	CONSTRAINT [PK_APPLICATION_TYPES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
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

ALTER TABLE [dbo].[IMPORT_DETAILS] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPORT_DETAILS] PRIMARY KEY  CLUSTERED 
	(
		[IdImport],
		[IdRow]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IMPORT_DETAILS_KEYROWS_MISSING] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPORT_DETAILS_KEYROWS_MISSING] PRIMARY KEY  CLUSTERED 
	(
		[IdImport],
		[IdRow]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IMPORT_LOGS] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPORT_LOGS] PRIMARY KEY  CLUSTERED 
	(
		[IdImport]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IMPORT_LOGS_DETAILS] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPORT_LOGS_DETAILS] PRIMARY KEY  CLUSTERED 
	(
		[IdImport],
		[Id],
		[IdRow]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IMPORT_LOGS_DETAILS_KEYROWS_MISSING] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPORT_LOGS_DETAILS_KEYROWS_MISSING] PRIMARY KEY  CLUSTERED 
	(
		[IdImport],
		[Id],
		[IdRow]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IMPORT_SOURCES] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPORT_SOURCES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IMPORT_SOURCES_COUNTRIES] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPORT_SOURCES_COUNTRIES] PRIMARY KEY  CLUSTERED 
	(
		[IdImportSource],
		[IdCountry]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[INERGY_LOCATIONS] WITH NOCHECK ADD 
	CONSTRAINT [PK_INERGY_SITES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LANGUAGES] WITH NOCHECK ADD 
	CONSTRAINT [PK_LANGUAGES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[MODULES] WITH NOCHECK ADD 
	CONSTRAINT [PK_MODULES] PRIMARY KEY  CLUSTERED 
	(
		[Code]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OLAP_CATEGORIES] WITH NOCHECK ADD 
	CONSTRAINT [PK_OLAP_CAT_PROGS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OLAP_GA_RATES] WITH NOCHECK ADD 
	CONSTRAINT [PK_OLAP_GARates] PRIMARY KEY  CLUSTERED 
	(
		[IdCountry],
		[YearMonth]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OLAP_MARKUP_RATES] WITH NOCHECK ADD 
	CONSTRAINT [PK_OLAP_MARKUPRATE] PRIMARY KEY  CLUSTERED 
	(
		[Year]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OLAP_MONTHS] WITH NOCHECK ADD 
	CONSTRAINT [PK_OLAP_Months] PRIMARY KEY  CLUSTERED 
	(
		[Month]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OLAP_PERIODS] WITH NOCHECK ADD 
	CONSTRAINT [PK_OLAP_PERIODS] PRIMARY KEY  CLUSTERED 
	(
		[YearMonthKey]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OLAP_SCALINGS] WITH NOCHECK ADD 
	CONSTRAINT [PK_OLAP_SCALINGS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OLAP_UNITS] WITH NOCHECK ADD 
	CONSTRAINT [PK_OLAP_UNITS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OLAP_YEARS] WITH NOCHECK ADD 
	CONSTRAINT [PK_OLAP_YEARS] PRIMARY KEY  CLUSTERED 
	(
		[Year]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OPERATIONS] WITH NOCHECK ADD 
	CONSTRAINT [PK_Operations] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OWNERS] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROGRAM_OWNERS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OWNER_TYPES] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROGRAM_ORGANIZATIONS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PERMISSIONS] WITH NOCHECK ADD 
	CONSTRAINT [PK_PERMISSIONS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROGRAMS] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROGRAMS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROJECTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROJECTS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROJECTS_INTERCO] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROJECTS_INTERCO] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage],
		[IdCountry]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROJECTS_INTERCO_LAYOUT] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROJECTS_INTERCO_LAYOUT] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdCountry]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROJECT_CORE_TEAMS] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROJECT_CORE_TEAMS] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdAssociate]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROJECT_FUNCTIONS] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROJECT_FUNCTIONS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROJECT_PHASES] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROJECT_PHASES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROJECT_TYPES] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROJECT_TYPES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[REGIONS] WITH NOCHECK ADD 
	CONSTRAINT [PK_REGIONS] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ROLES] WITH NOCHECK ADD 
	CONSTRAINT [PK_ROLES] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ROLE_RIGHTS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ROLE_RIGHTS] PRIMARY KEY  CLUSTERED 
	(
		[IdRole],
		[CodeModule],
		[IdOperation]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[USER_SETTINGS] WITH NOCHECK ADD 
	CONSTRAINT [PK_USER_SETTINGS] PRIMARY KEY  CLUSTERED 
	(
		[AssociateId]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[WORK_PACKAGES] WITH NOCHECK ADD 
	CONSTRAINT [PK_WORK_PACKAGES] PRIMARY KEY  CLUSTERED 
	(
		[IdProject],
		[IdPhase],
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[WORK_PACKAGES_TEMPLATE] WITH NOCHECK ADD 
	CONSTRAINT [PK_WORK_PACKAGES_TEMPLATE] PRIMARY KEY  CLUSTERED 
	(
		[IdPhase],
		[Id]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ASSOCIATES] WITH NOCHECK ADD 
	CONSTRAINT [UQ_ASSOCIATES_EMPLOYEENUMBER] UNIQUE  NONCLUSTERED 
	(
		[IdCountry],
		[EmployeeNumber]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] ,
	CONSTRAINT [UQ_ASSOCIATES_InergyLogin] UNIQUE  NONCLUSTERED 
	(
		[IdCountry],
		[InergyLogin]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_PROGRESS] WITH NOCHECK ADD 
	CONSTRAINT [CK_BUDGET_TOCOMPLETION_PROGRESS] CHECK ([Percent] <= 100 and [Percent] >= 0 or isnull([Percent],(-1)) = (-1))
GO

ALTER TABLE [dbo].[COST_INCOME_TYPES] WITH NOCHECK ADD 
	CONSTRAINT [DF_COST_INCOME_TYPES_Rank] DEFAULT (1) FOR [Rank]
GO

ALTER TABLE [dbo].[COUNTRIES] WITH NOCHECK ADD 
	CONSTRAINT [UQ_COUNTRIES] UNIQUE  NONCLUSTERED 
	(
		[Code]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] ,
	CONSTRAINT [UQ_COUNTRIES_2] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CURRENCIES] WITH NOCHECK ADD 
	CONSTRAINT [IX_CURRENCIES] UNIQUE  NONCLUSTERED 
	(
		[Code]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DEPARTMENTS] WITH NOCHECK ADD 
	CONSTRAINT [UQ_DEPARTMENTS] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FUNCTIONS] WITH NOCHECK ADD 
	CONSTRAINT [UQ_FUNCTIONS] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[GL_ACCOUNTS] WITH NOCHECK ADD 
	CONSTRAINT [UQ_GL_ACCOUNTS] UNIQUE  NONCLUSTERED 
	(
		[IdCountry],
		[Account]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IMPORT_SOURCES] WITH NOCHECK ADD 
	CONSTRAINT [IX_IMPORT_SOURCES_RANK] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[INERGY_LOCATIONS] WITH NOCHECK ADD 
	CONSTRAINT [UQ_INERGY_LOCATIONS_1] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OLAP_GA_RATES] WITH NOCHECK ADD 
	CONSTRAINT [CK_OLAP_GARates] CHECK ([Rate] >= 0),
	CONSTRAINT [CK_OLAP_GARates_Month_Overflow] CHECK ([yearmonth] % 100 >= 1 and [yearmonth] % 100 <= 12),
	CONSTRAINT [CK_OLAP_GARATES_Year_Overflow] CHECK ([yearmonth] / 100 >= 1900 and [yearmonth] / 100 < 2079)
GO

ALTER TABLE [dbo].[OLAP_MARKUP_RATES] WITH NOCHECK ADD 
	CONSTRAINT [CK_OLAP_MARKUPRATE_MarkUpRate] CHECK ([Rate] >= 0),
	CONSTRAINT [CK_OLAP_MARKUPRATE_Overflow] CHECK ([year] >= 1900 and [year] < 2079)
GO

ALTER TABLE [dbo].[OWNERS] WITH NOCHECK ADD 
	CONSTRAINT [UQ_OWNERS] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] ,
	CONSTRAINT [UQ_OWNERS_NAME] UNIQUE  NONCLUSTERED 
	(
		[Name]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROGRAMS] WITH NOCHECK ADD 
	CONSTRAINT [UQ_PROGRAMS] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] ,
	CONSTRAINT [UQ_PROGRAMS_CODE] UNIQUE  NONCLUSTERED 
	(
		[Code]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROJECTS] WITH NOCHECK ADD 
	CONSTRAINT [UQ_PROJECTS_CODE] UNIQUE  NONCLUSTERED 
	(
		[Code]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROJECT_PHASES] WITH NOCHECK ADD 
	CONSTRAINT [UQ_PROJECT_PHASES_CODE] UNIQUE  NONCLUSTERED 
	(
		[Code]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] ,
	CONSTRAINT [UQ_PROJECT_PHASES_NAME] UNIQUE  NONCLUSTERED 
	(
		[Name]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PROJECT_TYPES] WITH NOCHECK ADD 
	CONSTRAINT [UQ_PROJECT_TYPES] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[REGIONS] WITH NOCHECK ADD 
	CONSTRAINT [UQ_REGIONS] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[WORK_PACKAGES] WITH NOCHECK ADD 
	CONSTRAINT [UQ_WORK_PACKAGES] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] ,
	CONSTRAINT [UQ_WORK_PACKAGES_IdProject_Code] UNIQUE  NONCLUSTERED 
	(
		[IdProject],
		[Code]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[WORK_PACKAGES_TEMPLATE] WITH NOCHECK ADD 
	CONSTRAINT [UQ_WORK_PACKAGES_TEMPLATE] UNIQUE  NONCLUSTERED 
	(
		[Rank]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] ,
	CONSTRAINT [UQ_WORK_PACKAGES_TEMPLATE_Code] UNIQUE  NONCLUSTERED 
	(
		[Code]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_ACTUAL_DATA_DETAILS_COSTS] ON [dbo].[ACTUAL_DATA_DETAILS_COSTS]([IdImport] DESC ) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_ACTUAL_DATA_DETAILS_HOURS] ON [dbo].[ACTUAL_DATA_DETAILS_HOURS]([IdImport] DESC ) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_ACTUAL_DATA_DETAILS_SALES] ON [dbo].[ACTUAL_DATA_DETAILS_SALES]([IdImport] DESC ) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_ANNUAL_BUDGET_DATA_DETAILS_COSTS] ON [dbo].[ANNUAL_BUDGET_DATA_DETAILS_COSTS]([IdImport] DESC ) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_ANNUAL_BUDGET_DATA_DETAILS_HOURS] ON [dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS]([IdImport] DESC ) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_ANNUAL_BUDGET_DATA_DETAILS_SALES] ON [dbo].[ANNUAL_BUDGET_DATA_DETAILS_SALES]([IdImport] DESC ) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_ANNUAL_BUDGET_IMPORT_DETAILS] ON [dbo].[ANNUAL_BUDGET_IMPORT_DETAILS]([IdImport]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [IX_COST_CENTERS] ON [dbo].[COST_CENTERS]([IdInergyLocation], [Id]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [IX_COUNTRIES] ON [dbo].[COUNTRIES]([IdCurrency], [Id]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [IX_COUNTRIES_1] ON [dbo].[COUNTRIES]([IdRegion], [Id]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_EXCHANGE_RATES_CURRENCY_YEARMONTH] ON [dbo].[EXCHANGE_RATES]([YearMonth], [IdCurrencyTo]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_EXCHANGE_RATES_CURRENCY] ON [dbo].[EXCHANGE_RATES]([IdCurrencyTo]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_IMPORT_BUDGET_INITIAL_DETAILS] ON [dbo].[IMPORT_BUDGET_INITIAL_DETAILS]([IdImport]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_IMPORT_DETAILS] ON [dbo].[IMPORT_DETAILS]([IdImport]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_IMPORT_DETAILS_KEYROWS_MISSING] ON [dbo].[IMPORT_DETAILS_KEYROWS_MISSING]([IdImport]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [IX_INERGY_LOCATIONS] ON [dbo].[INERGY_LOCATIONS]([IdCountry], [Id]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

ALTER TABLE [dbo].[ACTUAL_DATA] ADD 
	CONSTRAINT [FK_ACTUAL_DATA_PROJECTS] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[PROJECTS] (
		[Id]
	)
GO

ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_COSTS] ADD 
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_COSTS_ACTUAL_DATA] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[ACTUAL_DATA] (
		[IdProject]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_COSTS_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_COSTS_BUDGET_COST_TYPES] FOREIGN KEY 
	(
		[IdCostType]
	) REFERENCES [dbo].[BUDGET_COST_TYPES] (
		[Id]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_COSTS_COST_CENTERS] FOREIGN KEY 
	(
		[IdCostCenter]
	) REFERENCES [dbo].[COST_CENTERS] (
		[Id]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_COSTS_GL_ACCOUNTS] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccount]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_COSTS_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[IMPORTS] (
		[IdImport]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_COSTS_WORK_PACKAGES] FOREIGN KEY 
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

ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_HOURS] ADD 
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_HOURS_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[IMPORTS] (
		[IdImport]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAILS_ACTUAL_DATA] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[ACTUAL_DATA] (
		[IdProject]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAILS_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAILS_COST_CENTERS] FOREIGN KEY 
	(
		[IdCostCenter]
	) REFERENCES [dbo].[COST_CENTERS] (
		[Id]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAILS_GL_ACCOUNTS] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccount]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAILS_WORK_PACKAGES] FOREIGN KEY 
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

ALTER TABLE [dbo].[ACTUAL_DATA_DETAILS_SALES] ADD 
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_SALES_ACTUAL_DATA] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[ACTUAL_DATA] (
		[IdProject]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_SALES_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_SALES_COST_CENTERS] FOREIGN KEY 
	(
		[IdCostCenter]
	) REFERENCES [dbo].[COST_CENTERS] (
		[Id]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_SALES_GL_ACCOUNTS1] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccount]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_SALES_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[IMPORTS] (
		[IdImport]
	),
	CONSTRAINT [FK_ACTUAL_DATA_DETAIL_SALES_WORK_PACKAGES] FOREIGN KEY 
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

ALTER TABLE [dbo].[ANNUAL_BUDGET_DATA_DETAILS_HOURS] ADD 
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_ANNUAL_BUDGET] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[ANNUAL_BUDGET] (
		[IdProject]
	),
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_HOURS_ANNUAL_BUDGET_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[ANNUAL_BUDGET_IMPORTS] (
		[IdImport]
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
	CONSTRAINT [FK_ANNUAL_BUDGET_DATA_DETAILS_SALES_ANNUAL_BUDGET_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[ANNUAL_BUDGET_IMPORTS] (
		[IdImport]
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

ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORTS] ADD 
	CONSTRAINT [FK_ANNUAL_BUDGET_IMPORTS_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORT_DETAILS] ADD 
	CONSTRAINT [FK_ANNUAL_BUDGET_IMPORT_DETAILS_ANNUAL_BUDGET_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[ANNUAL_BUDGET_IMPORTS] (
		[IdImport]
	)
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORT_LOGS] ADD 
	CONSTRAINT [FK_ANNUAL_BUDGET_IMPORT_LOGS_ANNUAL_BUDGET_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[ANNUAL_BUDGET_IMPORTS] (
		[IdImport]
	)
GO

ALTER TABLE [dbo].[ANNUAL_BUDGET_IMPORT_LOGS_DETAILS] ADD 
	CONSTRAINT [FK_ANNUAL_BUDGET_IMPORT_LOGS_DETAILS_ANNUAL_BUDGET_IMPORT_LOGS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[ANNUAL_BUDGET_IMPORT_LOGS] (
		[IdImport]
	)
GO

ALTER TABLE [dbo].[ASSOCIATES] ADD 
	CONSTRAINT [FK_ASSOCIATES_COUNTRIES] FOREIGN KEY 
	(
		[IdCountry]
	) REFERENCES [dbo].[COUNTRIES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[ASSOCIATE_ROLES] ADD 
	CONSTRAINT [FK_ASSOCIATE_ROLES_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_ASSOCIATE_ROLES_ROLES] FOREIGN KEY 
	(
		[IdRole]
	) REFERENCES [dbo].[ROLES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL] ADD 
	CONSTRAINT [FK_BUDGET_INITIAL_DETAIL_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_DETAIL_BUDGET_INITIAL] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[BUDGET_INITIAL] (
		[IdProject]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_DETAIL_COST_CENTERS] FOREIGN KEY 
	(
		[IdCostCenter]
	) REFERENCES [dbo].[COST_CENTERS] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_DETAIL_GL_ACCOUNTS] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccountHours]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_DETAIL_GL_ACCOUNTS1] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccountSales]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_DETAIL_PROJECT_CORE_TEAMS] FOREIGN KEY 
	(
		[IdProject],
		[IdAssociate]
	) REFERENCES [dbo].[PROJECT_CORE_TEAMS] (
		[IdProject],
		[IdAssociate]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_DETAIL_WORK_PACKAGES] FOREIGN KEY 
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

ALTER TABLE [dbo].[BUDGET_INITIAL_DETAIL_COSTS] ADD 
	CONSTRAINT [FK_BUDGET_INITIAL_DETAIL_COSTS_BUDGET_COST_TYPES] FOREIGN KEY 
	(
		[IdCostType]
	) REFERENCES [dbo].[BUDGET_COST_TYPES] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_DETAIL_COSTS_BUDGET_INITIAL_DETAIL] FOREIGN KEY 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth]
	) REFERENCES [dbo].[BUDGET_INITIAL_DETAIL] (
		[IdProject],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_DETAIL_COSTS_GL_ACCOUNTS] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccount]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_DETAIL_COSTS_PROJECT_CORE_TEAMS] FOREIGN KEY 
	(
		[IdProject],
		[IdAssociate]
	) REFERENCES [dbo].[PROJECT_CORE_TEAMS] (
		[IdProject],
		[IdAssociate]
	)
GO

ALTER TABLE [dbo].[BUDGET_INITIAL_STATES] ADD 
	CONSTRAINT [FK_BUDGET_INITIAL_STATES_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_STATES_BUDGET_INITIAL] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[BUDGET_INITIAL] (
		[IdProject]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_STATES_BUDGET_STATES] FOREIGN KEY 
	(
		[State]
	) REFERENCES [dbo].[BUDGET_STATES] (
		[StateCode]
	),
	CONSTRAINT [FK_BUDGET_INITIAL_STATES_PROJECT_CORE_TEAMS] FOREIGN KEY 
	(
		[IdProject],
		[IdAssociate]
	) REFERENCES [dbo].[PROJECT_CORE_TEAMS] (
		[IdProject],
		[IdAssociate]
	)
GO

ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL] ADD 
	CONSTRAINT [FK_BUDGET_REVISED_DETAIL_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_REVISED_DETAIL_BUDGET_REVISED] FOREIGN KEY 
	(
		[IdProject],
		[IdGeneration]
	) REFERENCES [dbo].[BUDGET_REVISED] (
		[IdProject],
		[IdGeneration]
	),
	CONSTRAINT [FK_BUDGET_REVISED_DETAIL_COST_CENTERS] FOREIGN KEY 
	(
		[IdCostCenter]
	) REFERENCES [dbo].[COST_CENTERS] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_REVISED_DETAIL_GL_ACCOUNTS] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccountHours]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_BUDGET_REVISED_DETAIL_GL_ACCOUNTS1] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccountSales]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_BUDGET_REVISED_DETAIL_PROJECT_CORE_TEAMS] FOREIGN KEY 
	(
		[IdProject],
		[IdAssociate]
	) REFERENCES [dbo].[PROJECT_CORE_TEAMS] (
		[IdProject],
		[IdAssociate]
	),
	CONSTRAINT [FK_BUDGET_REVISED_DETAIL_WORK_PACKAGES] FOREIGN KEY 
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

ALTER TABLE [dbo].[BUDGET_REVISED_DETAIL_COSTS] ADD 
	CONSTRAINT [FK_BUDGET_REVISED_DETAIL_COSTS_BUDGET_COST_TYPES1] FOREIGN KEY 
	(
		[IdCostType]
	) REFERENCES [dbo].[BUDGET_COST_TYPES] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_REVISED_DETAIL_COSTS_BUDGET_REVISED_DETAIL] FOREIGN KEY 
	(
		[IdProject],
		[IdGeneration],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth]
	) REFERENCES [dbo].[BUDGET_REVISED_DETAIL] (
		[IdProject],
		[IdGeneration],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth]
	),
	CONSTRAINT [FK_BUDGET_REVISED_DETAIL_COSTS_GL_ACCOUNTS] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccount]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_BUDGET_REVISED_DETAIL_COSTS_PROJECT_CORE_TEAMS] FOREIGN KEY 
	(
		[IdProject],
		[IdAssociate]
	) REFERENCES [dbo].[PROJECT_CORE_TEAMS] (
		[IdProject],
		[IdAssociate]
	)
GO

ALTER TABLE [dbo].[BUDGET_REVISED_STATES] ADD 
	CONSTRAINT [FK_BUDGET_REVISED_STATES_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_REVISED_STATES_BUDGET_REVISED] FOREIGN KEY 
	(
		[IdProject],
		[IdGeneration]
	) REFERENCES [dbo].[BUDGET_REVISED] (
		[IdProject],
		[IdGeneration]
	),
	CONSTRAINT [FK_BUDGET_REVISED_STATES_BUDGET_STATES] FOREIGN KEY 
	(
		[State]
	) REFERENCES [dbo].[BUDGET_STATES] (
		[StateCode]
	),
	CONSTRAINT [FK_BUDGET_REVISED_STATES_PROJECT_CORE_TEAMS] FOREIGN KEY 
	(
		[IdProject],
		[IdAssociate]
	) REFERENCES [dbo].[PROJECT_CORE_TEAMS] (
		[IdProject],
		[IdAssociate]
	)
GO

ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL] ADD 
	CONSTRAINT [FK_BUDGET_REFORECAST_DETAIL_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_REFORECAST_DETAIL_BUDGET_REFORECAST] FOREIGN KEY 
	(
		[IdProject],
		[IdGeneration]
	) REFERENCES [dbo].[BUDGET_TOCOMPLETION] (
		[IdProject],
		[IdGeneration]
	),
	CONSTRAINT [FK_BUDGET_REFORECAST_DETAIL_COST_CENTERS] FOREIGN KEY 
	(
		[IdCostCenter]
	) REFERENCES [dbo].[COST_CENTERS] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_REFORECAST_DETAIL_WORK_PACKAGES] FOREIGN KEY 
	(
		[IdProject],
		[IdPhase],
		[IdWorkPackage]
	) REFERENCES [dbo].[WORK_PACKAGES] (
		[IdProject],
		[IdPhase],
		[Id]
	),
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_DETAIL_BUDGET_TOCOMPLETION_PROGRESS] FOREIGN KEY 
	(
		[IdProject],
		[IdGeneration],
		[IdPhase],
		[IdAssociate],
		[IdWorkPackage]
	) REFERENCES [dbo].[BUDGET_TOCOMPLETION_PROGRESS] (
		[IdProject],
		[IdGeneration],
		[IdPhase],
		[IdAssociate],
		[IdWorkPackage]
	),
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_DETAIL_GL_ACCOUNTS] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccountHours]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_DETAIL_GL_ACCOUNTS1] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccountSales]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_DETAIL_PROJECT_CORE_TEAMS] FOREIGN KEY 
	(
		[IdProject],
		[IdAssociate]
	) REFERENCES [dbo].[PROJECT_CORE_TEAMS] (
		[IdProject],
		[IdAssociate]
	)
GO

ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_DETAIL_COSTS] ADD 
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_BUDGET_COST_TYPES] FOREIGN KEY 
	(
		[IdCostType]
	) REFERENCES [dbo].[BUDGET_COST_TYPES] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_BUDGET_TOCOMPLETION_DETAIL] FOREIGN KEY 
	(
		[IdProject],
		[IdGeneration],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth]
	) REFERENCES [dbo].[BUDGET_TOCOMPLETION_DETAIL] (
		[IdProject],
		[IdGeneration],
		[IdPhase],
		[IdWorkPackage],
		[IdCostCenter],
		[IdAssociate],
		[YearMonth]
	),
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_GL_ACCOUNTS] FOREIGN KEY 
	(
		[IdCountry],
		[IdAccount]
	) REFERENCES [dbo].[GL_ACCOUNTS] (
		[IdCountry],
		[Id]
	),
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_DETAIL_COSTS_PROJECT_CORE_TEAMS] FOREIGN KEY 
	(
		[IdProject],
		[IdAssociate]
	) REFERENCES [dbo].[PROJECT_CORE_TEAMS] (
		[IdProject],
		[IdAssociate]
	)
GO

ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_PROGRESS] ADD 
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_PROGRESS_PROJECT_CORE_TEAMS] FOREIGN KEY 
	(
		[IdProject],
		[IdAssociate]
	) REFERENCES [dbo].[PROJECT_CORE_TEAMS] (
		[IdProject],
		[IdAssociate]
	)
GO

ALTER TABLE [dbo].[BUDGET_TOCOMPLETION_STATES] ADD 
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_STATES_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_STATES_BUDGET_STATES] FOREIGN KEY 
	(
		[State]
	) REFERENCES [dbo].[BUDGET_STATES] (
		[StateCode]
	),
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_STATES_BUDGET_TOCOMPLETION] FOREIGN KEY 
	(
		[IdProject],
		[IdGeneration]
	) REFERENCES [dbo].[BUDGET_TOCOMPLETION] (
		[IdProject],
		[IdGeneration]
	),
	CONSTRAINT [FK_BUDGET_TOCOMPLETION_STATES_PROJECT_CORE_TEAMS] FOREIGN KEY 
	(
		[IdProject],
		[IdAssociate]
	) REFERENCES [dbo].[PROJECT_CORE_TEAMS] (
		[IdProject],
		[IdAssociate]
	)
GO

ALTER TABLE [dbo].[COST_CENTERS] ADD 
	CONSTRAINT [FK_GROUPS_DEPARTMENTS] FOREIGN KEY 
	(
		[IdDepartment]
	) REFERENCES [dbo].[DEPARTMENTS] (
		[Id]
	),
	CONSTRAINT [FK_GROUPS_INERGY_SITES] FOREIGN KEY 
	(
		[IdInergyLocation]
	) REFERENCES [dbo].[INERGY_LOCATIONS] (
		[Id]
	)
GO

ALTER TABLE [dbo].[COUNTRIES] ADD 
	CONSTRAINT [FK_COUNTRIES_CURRENCIES] FOREIGN KEY 
	(
		[IdCurrency]
	) REFERENCES [dbo].[CURRENCIES] (
		[Id]
	),
	CONSTRAINT [FK_COUNTRIES_REGIONS] FOREIGN KEY 
	(
		[IdRegion]
	) REFERENCES [dbo].[REGIONS] (
		[Id]
	)
GO

ALTER TABLE [dbo].[DEPARTMENTS] ADD 
	CONSTRAINT [FK_DEPARTMENTS_FUNCTIONS] FOREIGN KEY 
	(
		[IdFunction]
	) REFERENCES [dbo].[FUNCTIONS] (
		[Id]
	)
GO

ALTER TABLE [dbo].[ERROR_MESSAGES] ADD 
	CONSTRAINT [FK_ERROR_MESSAGES_LANGUAGES] FOREIGN KEY 
	(
		[IdLanguage]
	) REFERENCES [dbo].[LANGUAGES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[EXCHANGE_RATES] ADD 
	CONSTRAINT [FK_EXCHANGE_RATES_CATEGORIES] FOREIGN KEY 
	(
		[IdCategory]
	) REFERENCES [dbo].[EXCHANGE_RATE_CATEGORIES] (
		[Id]
	),
	CONSTRAINT [FK_EXCHANGE_RATES_CURRENCIES] FOREIGN KEY 
	(
		[IdCurrencyTo]
	) REFERENCES [dbo].[CURRENCIES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[GL_ACCOUNTS] ADD 
	CONSTRAINT [FK_GL_ACCOUNTS_COST_TYPES] FOREIGN KEY 
	(
		[IdCostType]
	) REFERENCES [dbo].[COST_INCOME_TYPES] (
		[Id]
	),
	CONSTRAINT [FK_PROJECT_NATURE_COUNTRIES] FOREIGN KEY 
	(
		[IdCountry]
	) REFERENCES [dbo].[COUNTRIES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[HOURLY_RATES] ADD 
	CONSTRAINT [FK_HOURLY_RATES_COST_CENTERS] FOREIGN KEY 
	(
		[IdCostCenter]
	) REFERENCES [dbo].[COST_CENTERS] (
		[Id]
	)
GO

ALTER TABLE [dbo].[IMPORTS] ADD 
	CONSTRAINT [FK_IMPORTS_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	)
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

ALTER TABLE [dbo].[IMPORT_DETAILS] ADD 
	CONSTRAINT [FK_IMPORT_DETAILS_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[IMPORTS] (
		[IdImport]
	)
GO

ALTER TABLE [dbo].[IMPORT_DETAILS_KEYROWS_MISSING] ADD 
	CONSTRAINT [FK_IMPORT_DETAILS_KEYROWS_MISSING_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[IMPORTS] (
		[IdImport]
	)
GO

ALTER TABLE [dbo].[IMPORT_LOGS] ADD 
	CONSTRAINT [FK_IMPORT_LOGS_IMPORT_SOURCES] FOREIGN KEY 
	(
		[IdSource]
	) REFERENCES [dbo].[IMPORT_SOURCES] (
		[Id]
	),
	CONSTRAINT [FK_IMPORT_LOGS_IMPORTS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[IMPORTS] (
		[IdImport]
	)
GO

ALTER TABLE [dbo].[IMPORT_LOGS_DETAILS] ADD 
	CONSTRAINT [FK_IMPORT_LOGS_DETAILS_IMPORT_DETAILS] FOREIGN KEY 
	(
		[IdImport],
		[IdRow]
	) REFERENCES [dbo].[IMPORT_DETAILS] (
		[IdImport],
		[IdRow]
	),
	CONSTRAINT [FK_IMPORT_LOGS_DETAILS_IMPORT_LOGS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[IMPORT_LOGS] (
		[IdImport]
	),
	CONSTRAINT [FK_IMPORT_LOGS_DETAILS_MODULES] FOREIGN KEY 
	(
		[Module]
	) REFERENCES [dbo].[MODULES] (
		[Code]
	)
GO

ALTER TABLE [dbo].[IMPORT_LOGS_DETAILS_KEYROWS_MISSING] ADD 
	CONSTRAINT [FK_IMPORT_LOGS_DETAILS_KEYROWS_MISSING_IMPORT_DETAILS_KEYROWS_MISSING] FOREIGN KEY 
	(
		[IdImport],
		[IdRow]
	) REFERENCES [dbo].[IMPORT_DETAILS_KEYROWS_MISSING] (
		[IdImport],
		[IdRow]
	) NOT FOR REPLICATION ,
	CONSTRAINT [FK_IMPORT_LOGS_DETAILS_KEYROWS_MISSING_IMPORT_LOGS] FOREIGN KEY 
	(
		[IdImport]
	) REFERENCES [dbo].[IMPORT_LOGS] (
		[IdImport]
	)
GO

ALTER TABLE [dbo].[IMPORT_SOURCES] ADD 
	CONSTRAINT [FK_IMPORT_SOURCES_IMPORT_APPLICATION_TYPES] FOREIGN KEY 
	(
		[IdApplicationTypes]
	) REFERENCES [dbo].[IMPORT_APPLICATION_TYPES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[IMPORT_SOURCES_COUNTRIES] ADD 
	CONSTRAINT [FK_IMPORT_SOURCES_COUNTRIES_COUNTRY] FOREIGN KEY 
	(
		[IdCountry]
	) REFERENCES [dbo].[COUNTRIES] (
		[Id]
	),
	CONSTRAINT [FK_IMPORT_SOURCES_COUNTRIES_SOURCE] FOREIGN KEY 
	(
		[IdImportSource]
	) REFERENCES [dbo].[IMPORT_SOURCES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[INERGY_LOCATIONS] ADD 
	CONSTRAINT [FK_INERGY_SITES_COUNTRIES] FOREIGN KEY 
	(
		[IdCountry]
	) REFERENCES [dbo].[COUNTRIES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[OLAP_GA_RATES] ADD 
	CONSTRAINT [FK_OLAP_GARates_COUNTRIES] FOREIGN KEY 
	(
		[IdCountry]
	) REFERENCES [dbo].[COUNTRIES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[OWNERS] ADD 
	CONSTRAINT [FK_PROGRAM_OWNERS_PROGRAM_ORGANIZATIONS] FOREIGN KEY 
	(
		[IdOwnerType]
	) REFERENCES [dbo].[OWNER_TYPES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[PROGRAMS] ADD 
	CONSTRAINT [FK_PROGRAMS_PROGRAM_OWNERS] FOREIGN KEY 
	(
		[IdOwner]
	) REFERENCES [dbo].[OWNERS] (
		[Id]
	)
GO

ALTER TABLE [dbo].[PROJECTS] ADD 
	CONSTRAINT [FK_PROJECTS_PROGRAMS] FOREIGN KEY 
	(
		[IdProgram]
	) REFERENCES [dbo].[PROGRAMS] (
		[Id]
	),
	CONSTRAINT [FK_PROJECTS_PROJECT_TYPES] FOREIGN KEY 
	(
		[IdProjectType]
	) REFERENCES [dbo].[PROJECT_TYPES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[PROJECTS_INTERCO] ADD 
	CONSTRAINT [FK_PROJECTS_INTERCO_COUNTRIES] FOREIGN KEY 
	(
		[IdCountry]
	) REFERENCES [dbo].[COUNTRIES] (
		[Id]
	),
	CONSTRAINT [FK_PROJECTS_INTERCO_WORK_PACKAGES] FOREIGN KEY 
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

ALTER TABLE [dbo].[PROJECTS_INTERCO_LAYOUT] ADD 
	CONSTRAINT [FK_PROJECTS_INTERCO_LAYOUT_COUNTRIES] FOREIGN KEY 
	(
		[IdCountry]
	) REFERENCES [dbo].[COUNTRIES] (
		[Id]
	),
	CONSTRAINT [FK_PROJECTS_INTERCO_LAYOUT_PROJECTS] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[PROJECTS] (
		[Id]
	)
GO

ALTER TABLE [dbo].[PROJECT_CORE_TEAMS] ADD 
	CONSTRAINT [FK_PROJECT_CORE_TEAMS_ASSOCIATES] FOREIGN KEY 
	(
		[IdAssociate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_PROJECT_CORE_TEAMS_PROJECT_FUNCTIONS] FOREIGN KEY 
	(
		[IdFunction]
	) REFERENCES [dbo].[PROJECT_FUNCTIONS] (
		[Id]
	),
	CONSTRAINT [FK_PROJECT_CORE_TEAMS_PROJECTS] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[PROJECTS] (
		[Id]
	)
GO

ALTER TABLE [dbo].[ROLE_RIGHTS] ADD 
	CONSTRAINT [FK_ROLE_RIGHTS_MODULES] FOREIGN KEY 
	(
		[CodeModule]
	) REFERENCES [dbo].[MODULES] (
		[Code]
	),
	CONSTRAINT [FK_ROLE_RIGHTS_OPERATIONS] FOREIGN KEY 
	(
		[IdOperation]
	) REFERENCES [dbo].[OPERATIONS] (
		[Id]
	),
	CONSTRAINT [FK_ROLE_RIGHTS_PERMISSIONS] FOREIGN KEY 
	(
		[IdPermission]
	) REFERENCES [dbo].[PERMISSIONS] (
		[Id]
	),
	CONSTRAINT [FK_ROLE_RIGHTS_ROLES] FOREIGN KEY 
	(
		[IdRole]
	) REFERENCES [dbo].[ROLES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[USER_SETTINGS] ADD 
	CONSTRAINT [FK_USER_SETTINGS_ASSOCIATES] FOREIGN KEY 
	(
		[AssociateId]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	)
GO

ALTER TABLE [dbo].[WORK_PACKAGES] ADD 
	CONSTRAINT [FK_WORK_PACKAGES_ASSOCIATES] FOREIGN KEY 
	(
		[LastUserUpdate]
	) REFERENCES [dbo].[ASSOCIATES] (
		[Id]
	),
	CONSTRAINT [FK_WORK_PACKAGES_PROJECT_PHASES] FOREIGN KEY 
	(
		[IdPhase]
	) REFERENCES [dbo].[PROJECT_PHASES] (
		[Id]
	),
	CONSTRAINT [FK_WORK_PACKAGES_PROJECTS] FOREIGN KEY 
	(
		[IdProject]
	) REFERENCES [dbo].[PROJECTS] (
		[Id]
	)
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

