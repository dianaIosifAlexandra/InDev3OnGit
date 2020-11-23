--Drops the Procedure impDeleteImportSourcesCountries if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impDeleteImportSourcesCountries]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impDeleteImportSourcesCountries
GO

CREATE PROCEDURE [dbo].[impDeleteImportSourcesCountries]
	@IdCountry	AS INT		
AS
BEGIN
	DELETE FROM [IMPORT_SOURCES_COUNTRIES]
	WHERE 	IdCountry = @IdCountry 
	IF (@@ERROR <> 0)
		BEGIN
			RAISERROR ('There was error deleting ImportSourcesCountries.',16,1)
			RETURN -1
		END	
END
GO

