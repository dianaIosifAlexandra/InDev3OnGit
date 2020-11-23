--Drops the Procedure impWriteToLogAnnualTables if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteToLogAnnualTables]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteToLogAnnualTables
GO


CREATE  PROCEDURE impWriteToLogAnnualTables
	@fileName 	nvarchar(400), 	--The name of the file		
	@IDImport INT			-- id of the import	
	
AS

DECLARE @Module VARCHAR(50),
	@RowCount INT

	IF (@fileName is null )
	BEGIN 
		RAISERROR('No file has been selected!',16,1)		
		RETURN -1
	END
DECLARE @Year INT
--#############BECAUSE THE FILENAME IS FIXED FORM WE CAN AFFORD TO TAKE THE YEAR FROM IT
-- 	DECLARE @fileName 	nvarchar(400)
-- 	SET @filename = 'D:\Work\INDEV3\Source\Indev3WebSite\Indev3WebSite\UploadDirectories\InProcess\FRA2007_1_2007_9_4.csv'
	SET @Year=SUBSTRING(RIGHT(@fileName,CHARINDEX('\',REVERSE(@fileName)) -1),4,4)
-- 	PRINT @YEAR
--#############################################################################################	



	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS]
		( [IdImport],[Year], [Validation] )
	VALUES (@IDImport, @Year, 'O')
	----------------------------------------------

	SELECT @Module = RTRIM(Code) FROM MODULES WHERE NAME =N'Country'

	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	-- ########## CHECK F1
	
	SELECT @IDImport, IMD.IdRow,
		'Country field is N/A!'
		, @Module
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	-- no country
	(IMD.Country IS NULL)
	AND IMD.IDImport = @IDImport
	

	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	-- ########## CHECK F1
	
	SELECT @IDImport, IMD.IdRow,
		'Country code: '  + ISNULL(IMD.Country,'N/A') + ' does not exist in Country catalogue!'
		, @Module
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	-- no country
	(NOT EXISTS(SELECT ID FROM COUNTRIES WHERE CODE =IMD.Country) )
	AND IMD.IDImport = @IDImport 

	
	-- ########## CHECK F3
	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Year field is N/A!'		
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	-- NO YEAR
	( IMD.Year IS NULL) AND IMD.IDImport = @IDImport
-- 	##################### CHECK if year in 1900 - 2079 interval
	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Year field: ' + CAST(IMD.Year as VARCHAR(9))+ ' is not in (1900 - 2079) interval'
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 	
		( IMD.Year NOT BETWEEN 1900 AND 2079) AND 
		IMD.IDImport = @IDImport

	---- ########## CHECK F5
	SELECT @Module =  RTRIM(Code) FROM MODULES WHERE NAME =N'Cost Center'
	
	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,
		'Cost Center is N/A!'
		,@Module		
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 		
	-- NO cost center
	(IMD.CostCenter IS NULL)
		
	AND IMD.IDImport = @IDImport
	

	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Cost Center '''  + ISNULL(IMD.CostCenter,'N/A') + ''' for country ''' + ISNULL(IMD.Country,'N/A') + ''' does not exists in Cost Center catalogue!'
		,@Module		
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
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
	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow, 
		'Project Code field is N/A!'
		,@Module	
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	--NO project code
		(IMD.ProjectCode IS NULL)
	AND IMD.IDImport = @IDImport



	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,
		'Project Code: '  + ISNULL(IMD.ProjectCode,'N/A') + ' does not exist in Projects catalog!',
		@Module			
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	--NO project code
		(NOT EXISTS(SELECT ID FROM PROJECTS WHERE CODE=IMD.ProjectCode))
	AND IMD.IDImport = @IDImport 


	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,
		'Project Code: '  + ISNULL(IMD.ProjectCode,'N/A') + ' is not of type C,Z,R,A,I,N,B!',
		@Module			
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	----project code exist but is not of type CZRAINB
	IMD.ProjectCode is not null
	AND left(IMD.ProjectCode,1) not in ('C','R','A','I','N','Z','B')
	AND	(EXISTS(SELECT ID FROM PROJECTS WHERE CODE=IMD.ProjectCode))
	AND IMD.IDImport = @IDImport 


	---- ########## CHECK F7
	SELECT @Module =  RTRIM(Code) FROM MODULES WHERE NAME =N'Work Package'
	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,
		'Work Package Code is N/A!'
		,@Module
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	--NO WP code
	(IMD.WPCode IS NULL) 
	AND IMD.IDImport = @IDImport

	
	
	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,
		'Work Package Code: '  + ISNULL(IMD.WPCode,'N/A') + ' does not exist for Project Code: ' + ISNULL(IMD.ProjectCode,'N/A') + '!'
		,@Module
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	--NO WP code
	( NOT EXISTS(
			SELECT TOP 1  WP.Code 
		      	FROM WORK_PACKAGES WP							
		      	INNER JOIN PROJECTS P
		      		ON WP.IdProject = P.Id					
		     	WHERE WP.CODE = IMD.WPCode AND
			P.Code = IMD.ProjectCode
		     )
	)	    
	AND IMD.IDImport = @IDImport 



	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,
		'Work Package Code: '  + IMD.WPCode + ' starts with 0 and Project Code: ' + ISNULL(IMD.ProjectCode,'N/A') + ' is not of type Z,R,A,I,N,B!'
		,@Module
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	IMD.WPCode like '0%'
	AND IMD.ProjectCode is not null
	AND left(IMD.ProjectCode,1) not in ('Z','R','A','I','N','B')
	--WP code exists
	AND (EXISTS(
			SELECT TOP 1  WP.Code 
		      	FROM WORK_PACKAGES WP							
		      	INNER JOIN PROJECTS P
		      		ON WP.IdProject = P.Id					
		     	WHERE WP.CODE = IMD.WPCode AND
			P.Code = IMD.ProjectCode
		     )
	)	    
	AND IMD.IDImport = @IDImport 

	/*
	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,
		'Work Package Code: '  + IMD.WPCode + ' is not 000 and Project Code: ' + ISNULL(IMD.ProjectCode,'N/A') + ' is of type R,A,I,N!'
		,@Module
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	IMD.WPCode <> '000'
	AND IMD.ProjectCode is not null
	AND left(IMD.ProjectCode,1) in ('R','A','I','N')
	--WP code exists
	AND (EXISTS(
			SELECT TOP 1  WP.Code 
		      	FROM WORK_PACKAGES WP							
		      	INNER JOIN PROJECTS P
		      		ON WP.IdProject = P.Id					
		     	WHERE WP.CODE = IMD.WPCode AND
			P.Code = IMD.ProjectCode
		     )
	)	    
	AND IMD.IDImport = @IDImport 
	*/
	
	---- ########## CHECK F8
	SELECT @Module =  RTRIM(Code) FROM MODULES WHERE NAME =N'G/L Account'
	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Account Number Code is N/A!'
		,@Module
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	--NO Account Number
		(IMD.AccountNumber IS NULL)
	AND IMD.IDImport = @IDImport

	
	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,	
		'Account Number Code: '  + ISNULL(IMD.AccountNumber,'N/A') + ' does not exists in G/L Accounts catalogue for country:' + ISNULL(IMD.Country,'N/A') + '!'
		,@Module
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE 
	--NO Account Number
		(NOT EXISTS(SELECT GL.ID 
				FROM GL_ACCOUNTS GL 
				INNER JOIN COUNTRIES C
					ON GL.IdCountry = C.Id
				WHERE Account = IMD.AccountNumber AND
				C.Code = IMD.Country))
	AND IMD.IDImport = @IDImport 
		

	INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
	(
		[IdImport], [IdRow], [Details], [Module]
	)
	SELECT @IDImport, IMD.IdRow,	
		left('Account Number Code is not 10000000 and '
		+ case when isnull(quantity1,0) <> 0 then ' Quantity1 <> 0' else '' end
		+ case when isnull(quantity2,0) <> 0 then ' Quantity2 <> 0' else '' end
		+ case when isnull(quantity3,0) <> 0 then ' Quantity3 <> 0' else '' end
		+ case when isnull(quantity4,0) <> 0 then ' Quantity4 <> 0' else '' end
		+ case when isnull(quantity5,0) <> 0 then ' Quantity5 <> 0' else '' end
		+ case when isnull(quantity6,0) <> 0 then ' Quantity6 <> 0' else '' end
		+ case when isnull(quantity7,0) <> 0 then ' Quantity7 <> 0' else '' end
		+ case when isnull(quantity8,0) <> 0 then ' Quantity8 <> 0' else '' end
		+ case when isnull(quantity9,0) <> 0 then ' Quantity9 <> 0' else '' end
		+ case when isnull(quantity10,0) <> 0 then ' Quantity10 <> 0' else '' end
		+ case when isnull(quantity11,0) <> 0 then ' Quantity11 <> 0' else '' end
		+ case when isnull(quantity12,0) <> 0 then ' Quantity12 <> 0' else '' end, 255)
		,@Module
	FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
	WHERE IMD.IDImport = @IDImport and
	IMD.AccountNumber <> '10000000' and 
	(isnull(Quantity1,0) <> 0 or isnull(Quantity2,0) <> 0 or isnull(Quantity3,0) <> 0 or isnull(Quantity4,0) <> 0
	 or isnull(Quantity5,0) <> 0 or isnull(Quantity6,0) <> 0 or isnull(Quantity7,0) <> 0 or isnull(Quantity8,0) <> 0
	 or isnull(Quantity9,0) <> 0 or isnull(Quantity10,0) <> 0 or isnull(Quantity11,0) <> 0 or isnull(Quantity12,0) <> 0)

GO

