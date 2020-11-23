
--#################### STORE PROCEDURE TO CHEKC THE CHRONOLOGICAL ORDER OR IMPORT FILE ####################
-- 		RETURNS 0 if OK TO CONTINUE IMPORT
-- 		YEARMONTH OF LAST CORRECT IMPORT IF NOT OK
--##########################################################################################################

--Drops the Procedure impCheckFileImportChronologicalOrder if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impCheckFileImportChronologicalOrder]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impCheckFileImportChronologicalOrder
GO


CREATE     PROCEDURE impCheckFileImportChronologicalOrder
	@fileName varchar(255)

AS
BEGIN	
	DECLARE @LAST_YearMonth INT
	DECLARE @File_YearMonth INT
	DECLARE @CountryCode varchar(3)
	DECLARE @YearMonth INT
	SET @CountryCode = SUBSTRING(@fileName, 4,3)

	DECLARE @Year varchar(4)
	DECLARE @Month varchar(2)
	DECLARE @ImportApplicationType varchar(3)
		
	SET @ImportApplicationType = SUBSTRING(@fileName, 1,3)
	SET @Year 		= SUBSTRING(@fileName, 9,4)
	SET @Month 		= SUBSTRING(@fileName,7,2)
	SET @File_YearMonth = @Year*100 + @Month

-- 	SELECT LAST SUCCEFULLY IMPORT YEARMONTH FOR THE FILE YEAR
	SELECT  @YearMonth = MAX(IL.YearMonth)
		FROM IMPORTS I
		INNER JOIN IMPORT_LOGS IL
			ON IL.IdImport = I.IdImport
		INNER JOIN IMPORT_SOURCES ISRC
			ON IL.IdSource = ISRC.Id
		INNER JOIN IMPORT_APPLICATION_TYPES IAT
			ON ISRC.IdApplicationTypes = IAT.Id
		WHERE  IL.Validation='G' AND
			   SUBSTRING(Filename, 4,3) = @CountryCode AND
		       IAT.Name = @ImportApplicationType AND
		       IL.YearMonth/100 = @Year

-- 	CHECK IF IS THIS IS THE FIRST IMPORT FROM THE SAME COUNTRY
	IF(@YearMonth IS NOT NULL)
	BEGIN
		SET @Month = @YearMonth % 100
		SET @Year = @YearMonth /100
		SET @Month = RIGHT('00' + CAST((CAST(@Month AS INT) -1) AS VARCHAR(2)),2)
		
	-- 	###################################
-- 		CHECK IF THE DATE FROM LAST SUCCESFULLY IMPORT IS THE PREVIOUS MONTH

		IF (@File_YearMonth - @YearMonth != 1)
		BEGIN
			SET @LAST_YearMonth=  @YearMonth		
		END			
	END
	
	DECLARE @ErrorMessage  VARCHAR(255)
	SET @ErrorMessage = 'File import must be made in chronological order. Expected period of imported file for year:' + @Year + ' is: ' + dbo.fnGetYMStringRepresentation(@LAST_YearMonth +1)
	IF (ISNULL(@LAST_YearMonth,0) <> 0)
		RAISERROR(@ErrorMessage, 16,1)
END

GO

