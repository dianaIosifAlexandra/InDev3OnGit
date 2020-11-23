--Drops the Procedure impIsUserAllowedOnImportSource if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impIsUserAllowedOnImportSource]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impIsUserAllowedOnImportSource
GO

CREATE PROCEDURE impIsUserAllowedOnImportSource
	@IdAssociate 		AS INT,
	@IdImportSource       	AS INT		
AS	
declare @IsAllowed int
declare @UserCountry int

select @UserCountry = IdCountry 
from ASSOCIATES 
where Id = @IdAssociate

if (select COUNT(*)
    from IMPORT_SOURCES_COUNTRIES ISC
    where ISC.IdImportSource = @IdImportSource and
          ISC.IdCountry = @UserCountry) > 0
	set @IsAllowed = 1
else
	set @IsAllowed = 0

select @IsAllowed as 'isAllowed'

GO


