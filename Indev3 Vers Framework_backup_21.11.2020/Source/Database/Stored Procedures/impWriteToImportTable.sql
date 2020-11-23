--Drops the Procedure impWriteToImportTable if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteToImportTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteToImportTable
GO

--sp_helptext impWRiteToImportTable
--impWriteToImportTable 'D:\Work\INDEV3\Source\Indev3WebSite\Indev3WebSite\UploadDirectories\InProcess\XLSROM012007.csv',4, 10
CREATE    PROCEDURE impWriteToImportTable
	@fileName 	nvarchar(400), 	--The name of the file
	@IdAssociate INT		--ID of the associate
	
AS

DECLARE @ROWCOUNTDELETED_CC INT,
	@ROWCOUNTDELETED_GL INT

	IF (@fileName is null )
	BEGIN 
		RAISERROR('No file has been selected',16,1)		
		RETURN -1
	END

	
-- create tempporary table
	DECLARE @SQL varchar(2000)
	CREATE TABLE #tempTable 
	(		
		[Country] varchar(3), 
		[Year] varchar(4), 
		[Month]	varchar(2), 
		[CostCenter]	varchar(10), 
		[ProjectCode] 	varchar(10), 
		[WPCode]	varchar(4), 
		[AccountNumber]	varchar(10), 
		[AssociateNumber]	varchar(15), 
		[Quantity]	varchar(15), 
		[UnitQty]	varchar(4), 
		[Value]	varchar(19), 
		[CurrencyCode]	varchar(3), 
		[Date]	varchar(8) 		
	)

	

	DECLARE @RealFileName nvarchar(100)
	Select @RealFileName = dbo.fnGetFileNameFromPath(@FileName)
-- 	PRINT @RealFileName
	
	
	--HACK for network -- to be removed--replace @FileNameNoPath with @fileName
	DECLARE @UNCPath nvarchar(400)
	--SET @UNCPath = '\\zdgh\UploadDirectories\InProcess\'+ @FileNameNoPath
	SET @UNCPath = @fileName

	--fill the temporary table from file
	SET @SQL = 'BULK INSERT #tempTable FROM '''+ @UNCPath +
	''' WITH (FIELDTERMINATOR  = '';'',ROWTERMINATOR = ''\n'',FIRSTROW = 1,CODEPAGE = 1252,TABLOCK)
	ALTER TABLE #tempTable ADD  [IdRow] int Identity'
	EXEC(@SQL)

-- CREATE INDEX IndexCostCenter on #tempTable (Country, CostCenter)
-- CREATE INDEX IndexGLAccounts on #tempTable (Country, AccountNumber)
DECLARE @COMMAND NVARCHAR(2000)
SET @COMMAND = 'CREATE INDEX IndexCostCenter_'+CAST(@@SPID as varchar(10)) + ' on #tempTable (Country, CostCenter);'
SET @COMMAND = @COMMAND + 'CREATE INDEX IndexGLAccounts_' + CAST(@@SPID as varchar(10)) + '  on #tempTable (Country, AccountNumber)'
EXEC(@COMMAND) 

-- #####   GET RIDD OF THE RECORDS FROM EXCLUSION TABLES #######
			
	DELETE #tempTable
	FROM #tempTable t
	INNER JOIN ACTUAL_DATA_EXCLUSION_COST_CENTERS AEC
		ON t.Country = AEC.CountryCode AND
		   t.CostCenter = AEC.CostCenterCode
	SET @ROWCOUNTDELETED_CC = @@ROWCOUNT
-- PRINT @@ROWCOUNT

	DELETE #tempTable
	FROM #tempTable t
	INNER JOIN  ACTUAL_DATA_EXCLUSION_GL_ACCOUNTS AEG
		ON t.Country = AEG.CountryCode AND
		   t.AccountNumber = AEG.GLAccountCode

	SET @ROWCOUNTDELETED_GL = @@ROWCOUNT
-- PRINT @@ROWCOUNT

	-- added on 2020-1-17
	--Could you make INDEV recognize 0 as 000, X as 00X, XX as 0XX 
	update #tempTable
	set WPCode = right('00' + rtrim(WPCode),3)
	where len(rtrim(ltrim(WPCode))) < 3
	and WPCode like '%[0-9]'


-- 	############################################################

	--fill imports/import_logs/import_details table
	DECLARE @IdImport 	INT,
		@IDSOURCE	INT,
		@YEARMONTH 	INT

	SELECT @IDSOURCE = dbo.fnGetIdSourceFromFileName(@fileName)

	-- set @fileName = 'D:\Work\INDEV3\Source\Indev3WebSite\Indev3WebSite\UploadDirectories\InProcess\XLSROM052007.csv'
	SET @YEARMONTH=SUBSTRING(SUBSTRING(RIGHT(@fileName,CHARINDEX('\',REVERSE(@fileName))-1),7,6),3,4) + 
		       SUBSTRING(SUBSTRING(RIGHT(@fileName,CHARINDEX('\',REVERSE(@fileName))-1),7,6),1,2)

	SELECT @IdImport = ISNULL(MAX(IdImport),0)+1 
	FROM IMPORTS (TABLOCKX)

	
	INSERT INTO [IMPORTS]
		([IdImport], [ImportDate], [FileName], [IdAssociate], 
			ExclusionCostCenterRowsNo, ExclusionGlAccountsRowsNo)
	VALUES	(@IdImport,  GETDATE(),	   @RealFileName , @IdAssociate,
			@ROWCOUNTDELETED_CC, @ROWCOUNTDELETED_GL)

	INSERT INTO [IMPORT_LOGS]
		([IdImport], [IdSource], [YearMonth], [Validation])
	VALUES (@IdImport, @IDSOURCE, @YEARMONTH, 'R')

	INSERT INTO [IMPORT_DETAILS]
		( [IdImport], [IdRow], [Country]
		, [Year] ,[Month], [CostCenter]
		, [ProjectCode], [WPCode],[AccountNumber]
		, [AssociateNumber], [Quantity], [UnitQty]
		 ,[Value], [CurrencyCode], [Date])

	SELECT @IdImport, [IdRow],RTRIM(LTRIM([Country])) 
		,RTRIM(LTRIM([Year])), RTRIM(LTRIM([Month])),RTRIM(LTRIM([CostCenter]))
		,RTRIM(LTRIM([ProjectCode])),RTRIM(LTRIM([WPCode])), RTRIM(LTRIM([AccountNumber]))
		,RTRIM(LTRIM([AssociateNumber])),RTRIM(LTRIM([Quantity])),RTRIM(LTRIM([UnitQty])), 
		RTRIM(LTRIM([Value])), RTRIM(LTRIM([CurrencyCode])), RTRIM(LTRIM([Date]))
	FROM #tempTable

	RETURN @IdImport
	
GO

