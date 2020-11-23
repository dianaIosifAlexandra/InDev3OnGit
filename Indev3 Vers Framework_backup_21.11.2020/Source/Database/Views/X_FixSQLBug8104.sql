use master
go

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[MakeGuestDbOwnerONTEMPDB]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE MakeGuestDbOwnerONTEMPDB
GO

CREATE PROCEDURE MakeGuestDbOwnerONTEMPDB AS
exec tempdb..sp_addrolemember 'db_owner','guest'
GO

exec sp_procoption N'MakeGuestDbOwnerONTEMPDB', N'startup', N'true'
GO

