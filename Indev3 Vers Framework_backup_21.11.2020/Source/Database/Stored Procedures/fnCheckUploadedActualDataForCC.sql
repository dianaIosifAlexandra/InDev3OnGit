IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnCheckUploadedActualDataForCC]'))
	DROP FUNCTION fnCheckUploadedActualDataForCC
GO

CREATE FUNCTION fnCheckUploadedActualDataForCC
	(@IdCostCenter	INT,
	@YearMonth	INT)
RETURNS BIT
AS

BEGIN

	DECLARE @IsUploadedActualDataForCC BIT
	SET @IsUploadedActualDataForCC = 0
	
	IF EXISTS
	(
		SELECT IL.IdImport
		FROM IMPORT_LOGS IL
		INNER JOIN IMPORT_SOURCES_COUNTRIES ISC
			ON IL.IdSource = ISC.IdImportSource 
		INNER JOIN INERGY_LOCATIONS ILC
			ON ISC.IdCountry = ILC.IdCountry 
		INNER JOIN COST_CENTERS CC
			ON ILC.Id = CC.IdInergyLocation 
		WHERE 	IL.Validation = 'G' AND
			IL.YearMonth = @YearMonth AND  
			CC.Id = @IdCostCenter 
	)
	BEGIN
		SET @IsUploadedActualDataForCC = 1
	END
	
	RETURN @IsUploadedActualDataForCC
END

GO

