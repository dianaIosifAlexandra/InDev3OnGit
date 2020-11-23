--Drops the Procedure impWriteToLogTables if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteToLogTables]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteToLogTables
GO


CREATE    PROCEDURE impWriteToLogTables
	@IdImport 	INT,		-- id of the import
	@IdAssociate 	INT		-- id of the associate	
AS

	DECLARE @Module VARCHAR(50), 		
		@IdSource INT,
		@SourceName varchar(100)
	
	-- update the state in IMPORT_LOGS	
	UPDATE IMPORT_LOGS
	SET Validation = 'O'
	WHERE IdImport = @IdImport

	----------------------------------------------

	SELECT @Module = RTRIM(Code) 
	FROM MODULES 
	WHERE NAME =N'Country'

	SELECT @IdSource = IL.IdSource, 
 	       @SourceName= IMS.SourceName
	FROM IMPORT_LOGS IL
	INNER JOIN IMPORT_SOURCES IMS
		ON IL.IdSource = IMS.Id
	WHERE IL.IdImport = @IdImport

	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	-- ########## CHECK F1
	
	SELECT @IDImport, IMD.IdRow,
		'Country field is N/A!'
		, @Module			
	FROM Import_details IMD
	WHERE 
	-- no country
	(IMD.Country IS NULL)
	AND IMD.IDImport = @IDImport
	

	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	-- ########## CHECK F1
	
	SELECT @IDImport, IMD.IdRow,
		'Country code: ' + ISNULL(IMD.Country,'N/A') + ' does not exist in Country catalogue!'
		, @Module
	FROM Import_details IMD
	WHERE 
	-- no country
	(NOT EXISTS(SELECT ID FROM COUNTRIES WHERE CODE =IMD.Country) )
	AND IMD.IDImport = @IDImport 

	
	-- ########## Check if the imported Country belongs to IMPORT_SOURCES
	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT IMD.IdImport, 
		   IMD.IdRow,
		   'Country ''' + ISNULL(IMD.Country,'N/A') + ''' does not belong to Import Source ''' + @SourceName + '''.',
		   null
	FROM IMPORT_DETAILS IMD
	INNER JOIN IMPORT_LOGS IML
		ON IMD.IdImport = IML.IdImport
	INNER JOIN IMPORT_SOURCES IMS
		ON IML.IdSource = IMS.Id
	INNER JOIN COUNTRIES C
		ON IMD.Country = C.Code
	WHERE IMD.IdImport = @IdImport AND
		  C.Id NOT IN 
			(SELECT IdCountry
			FROM IMPORT_SOURCES_COUNTRIES ISC
			WHERE ISC.IdImportSource = @IdSource)
	UNION
	SELECT IMD.IdImport, 
		   IMD.IdRow,
		   'Country ''' + ISNULL(IMD.Country,'N/A') + ''' does not belong to Import Source ''' + @SourceName + '''.',
		   null
	FROM IMPORT_DETAILS IMD
	LEFT JOIN COUNTRIES C
		ON IMD.Country = C.Code
	WHERE IMD.IdImport = @IdImport AND
	      C.Id IS NULL

	-- ########## CHECK F3
	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Year field is N/A!'		
	FROM Import_details IMD
	WHERE 
	-- NO YEAR
	( IMD.Year IS NULL) AND IMD.IDImport = @IDImport
-- 	############ CHECK if year is valid

	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Year field: ' + CAST(IMD.Year as VARCHAR(9)) + ' is not in (1900 - 2079) interval!'
	FROM Import_details IMD
	WHERE 
	
	( IMD.Year NOT BETWEEN 1900 AND 2079) AND IMD.IDImport = @IDImport

	---- ########## CHECK F4
	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Month field is N/A!'			
	FROM Import_details IMD
	WHERE 
	
	--NO MONTH
	(IMD.Month IS NULL) AND IMD.IDImport = @IDImport


	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Month field: ' + CAST(IMD.Month AS VARCHAR(9)) + ' is not in (1 - 12) interval!'			
	FROM Import_details IMD
	WHERE 
	
	--NO MONTH
	(IMD.Month NOT BETWEEN 1 AND 12) AND IMD.IDImport = @IDImport


	SELECT @Module =  RTRIM(Code) FROM MODULES WHERE NAME =N'Cost Center'

	---- ########## CHECK F5
	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,
		'Cost Center is N/A!'
		,@Module		
	FROM Import_details IMD
	WHERE 		
	-- NO cost center
	(IMD.CostCenter IS NULL)
		
	AND IMD.IDImport = @IDImport


	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Cost Center '''  + ISNULL(IMD.CostCenter,'N/A') + ''' for country ''' + ISNULL(IMD.Country,'N/A') + ''' does not exists in Cost Center catalogue!'
		,@Module		
	FROM Import_details IMD
	WHERE 		
	-- NO cost center
	( NOT EXISTS
		(
			SELECT CC.Id 
			FROM COST_CENTERS CC 
			INNER JOIN INERGY_LOCATIONS IL 
			        ON CC.IdInergyLocation = IL.ID 
			INNER JOIN COUNTRIES C 
				ON IL.IdCountry = C.Id     
			WHERE CC.CODE = IMD.CostCenter AND
			      C.Code = IMD.Country
		)
	)
	
	AND IMD.IDImport = @IDImport 

	---- ########## CHECK F6

	SELECT @Module =  RTRIM(Code) FROM MODULES WHERE NAME =N'Project'
	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow, 
		'Project Code field is N/A!'
		,@Module	
	FROM Import_details IMD
	WHERE 
	--NO project code
		(IMD.ProjectCode IS NULL)
	AND IMD.IDImport = @IDImport




	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,
		'Project Code: '  + ISNULL(IMD.ProjectCode,'N/A') + ' does not exist in Projects catalog!',
		@Module			
	FROM Import_details IMD
	WHERE 
	--NO project code
		(NOT EXISTS(SELECT ID FROM PROJECTS WHERE CODE=IMD.ProjectCode))
	AND IMD.IDImport = @IDImport 



	---- ########## CHECK F7
	SELECT @Module =  RTRIM(Code) FROM MODULES WHERE NAME =N'Work Package'
	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,
		'Work Package Code is N/A!'
		,@Module
	FROM Import_details IMD
	WHERE 
	--NO WP code
	(IMD.WPCode IS NULL) 
	AND IMD.IDImport = @IDImport


	
	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,
		'Work Package Code: '  + ISNULL(IMD.WPCode,'N/A') + ' does not exist in Project Code:' + ISNULL(IMD.ProjectCode,'N/A') + '!'
		,@Module
	FROM Import_details IMD
	WHERE 
	--NO WP code
	
	( NOT EXISTS(
			SELECT TOP 1  WP.Code 
		      	FROM WORK_PACKAGES WP 
-- 				INNER JOIN Project_Phases PP
-- 					ON WP.IdPhase = PP.Id					
		      	INNER JOIN PROJECTS P
		      		ON WP.IdProject = P.Id					
		     	WHERE WP.CODE = IMD.WPCode
-- 			AND PP.Code = SUBSTRING(ISNULL(IMD.WPCode,''), 1, 1)
			AND P.Code = IMD.ProjectCode
		     )
	)	    
		
	AND IMD.IDImport = @IDImport 

	
	---- ########## CHECK F8
	SELECT @Module =  RTRIM(Code) FROM MODULES WHERE NAME =N'G/L Account'
	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Account Number Code is N/A!'
		,@Module
	FROM Import_details IMD
	WHERE 
	--NO Account Number
		(IMD.AccountNumber IS NULL)
	AND IMD.IDImport = @IDImport


	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Account Number Code: '  + ISNULL(IMD.AccountNumber,'N/A') + ' does not exists in G/L Accounts catalogue for country:' + ISNULL(IMD.Country,'N/A') + '!'
		,@Module
	FROM Import_details IMD
	WHERE 
	--NO Account Number
		(NOT EXISTS(	SELECT GL.ID 
				FROM GL_ACCOUNTS GL INNER JOIN COUNTRIES C
				ON GL.IdCountry = C.Id
				WHERE Account = IMD.AccountNumber AND
				C.Code = IMD.Country))
	AND IMD.IDImport = @IDImport 




	-------#######CHECK QUANTITY

	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Quantity is N/A!'				
	FROM IMPORT_DETAILS IMD
	WHERE 
	--NO Quantity
		(IMD.Quantity IS NULL) AND IMD.IDImport = @IDImport
		
	
	
	
	-----#######CHECK HOURLY RATES
	SELECT @Module =  RTRIM(Code) FROM MODULES WHERE NAME =N'Hourly Rate'
	INSERT INTO [IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IdImport, IMD.IdRow,
			'Hourly rate for Cost Center ' + ISNULL(IMD.CostCenter, 'N/A') + ' and period ' + CAST((IMD.[Month]) as VARCHAR(2)) + '/' + CAST((IMD.[Year]) as VARCHAR(4)) + ' does not exist!'
			,@Module
	FROM IMPORT_DETAILS IMD
	WHERE
		(NOT EXISTS(SELECT HourlyRate 
					FROM HOURLY_RATES AS HR
					INNER JOIN COST_CENTERS CC
							ON HR.IdCostCenter = CC.Id
					WHERE 	IMD.CostCenter = CC.Code AND
						    HR.YearMonth = IMD.[Year]*100+IMD.[Month])
		)
		AND IMD.IDImport = @IDImport 

GO

	