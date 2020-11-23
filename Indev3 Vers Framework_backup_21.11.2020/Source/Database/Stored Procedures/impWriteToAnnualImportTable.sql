--Drops the Procedure impWriteToAnnualImportTable if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteToAnnualImportTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteToAnnualImportTable
GO

--sp_helptext impWriteToAnnualImportTable
--impWriteToAnnualImportTable 'D:\Work\INDEV3\Source\Indev3WebSite\Indev3WebSite\UploadDirectories\InProcess\XLSROM012007.csv',4, 10
CREATE    PROCEDURE impWriteToAnnualImportTable
	@fileName 	nvarchar(400),
	@IdAssociate	int
	
AS

declare @Year int
SET @Year=SUBSTRING(RIGHT(@fileName,CHARINDEX('\',REVERSE(@fileName)) -1),4,4)


DECLARE @ROWCOUNTDELETED_CC INT,
	@ROWCOUNTDELETED_GL INT

	IF (@fileName is null )
	BEGIN 
		RAISERROR('No file has been selected',16,1)		
		RETURN -1
	END


-- create temporary table
	DECLARE @SQL varchar(2000)
	CREATE TABLE #tempTable 
	(		
		[Country] varchar(3),
		[Year] varchar(4), 
		[CostCenter]	varchar(15), 
		[ProjectCode] 	varchar(10), 
		[WPCode]	varchar(3), 
		[AccountNumber]	varchar(20),
		[Value1]	varchar(19), 
		[Value2]	varchar(19), 
		[Value3]	varchar(19), 
		[Value4]	varchar(19), 
		[Value5]	varchar(19), 
		[Value6]	varchar(19), 
		[Value7]	varchar(19), 
		[Value8]	varchar(19), 
		[Value9]	varchar(19), 
		[Value10]	varchar(19), 
		[Value11]	varchar(19), 
		[Value12]	varchar(19), 
		[Quantity1]	varchar(15),
		[Quantity2]	varchar(15),
		[Quantity3]	varchar(15),
		[Quantity4]	varchar(15),
		[Quantity5]	varchar(15),
		[Quantity6]	varchar(15),
		[Quantity7]	varchar(15),
		[Quantity8]	varchar(15),
		[Quantity9]	varchar(15),
		[Quantity10]	varchar(15),
		[Quantity11]	varchar(15),
		[Quantity12]	varchar(15),
		[CurrencyCode]	varchar(3), 
		[Date]	varchar(203)--,
		--[FunctionName]	varchar(30),
		--[CostCenterName]	varchar(30),
		--[ProjectName]	varchar(50),
		--[CostType]	varchar(50),
		--[InergyLocationName]	varchar(30)
	)

-- CREATE INDEX IndexCostCenter on #tempTable (Country, CostCenter)
-- CREATE INDEX IndexGLAccounts on #tempTable (Country, AccountNumber)
	

	DECLARE @RealFileName nvarchar(100)
	Select @RealFileName = dbo.fnGetFileNameFromPath(@FileName)
-- 	PRINT @RealFileName


	--fill the temporary table from file
	SET @SQL = 'BULK INSERT #tempTable FROM '''+ @FileName +
	''' WITH (FIELDTERMINATOR  = '';'',ROWTERMINATOR = ''\n'',FIRSTROW = 1,CODEPAGE = 1252,TABLOCK)
	ALTER TABLE #tempTable ADD  [IdRow] int Identity '
	EXEC(@SQL)

	--update [Date] field in case the imported file has additional columns
	UPDATE #tempTable SET [Date] = LEFT([Date], 8)

	-- added on 2020-1-17
	--Could you make INDEV recognize 0 as 000, X as 00X, XX as 0XX 
	update #tempTable
	set WPCode = right('00' + rtrim(WPCode),3)
	where len(rtrim(ltrim(WPCode))) < 3
	and WPCode like '%[0-9]'


DECLARE @COMMAND NVARCHAR(2000)
SET @COMMAND = 'CREATE INDEX AnnualIndexCostCenter_'+CAST(@@SPID as varchar(10)) + ' on #tempTable (Country, CostCenter);'
SET @COMMAND = @COMMAND + 'CREATE INDEX AnnualIndexGLAccounts_' + CAST(@@SPID as varchar(10)) + '  on #tempTable (Country, AccountNumber)'
EXEC(@COMMAND) 

-- #####   GET RIDD OF THE RECORDS FROM EXCLUSION TABLES #######
			
	DELETE #tempTable
	FROM #tempTable t
	INNER JOIN ANNUAL_EXCLUSION_COST_CENTERS AEC
		ON t.Country = AEC.CountryCode AND
		   t.CostCenter = AEC.CostCenterCode

	SET @ROWCOUNTDELETED_CC = @@ROWCOUNT
-- PRINT @@ROWCOUNT

	DELETE #tempTable
	FROM #tempTable t
	INNER JOIN  ANNUAL_EXCLUSION_GL_ACCOUNTS AEG
		ON t.Country = AEG.CountryCode AND
		   t.AccountNumber = AEG.GLAccountCode

	SET @ROWCOUNTDELETED_GL = @@ROWCOUNT
-- PRINT @@ROWCOUNT

-- Check if previous import failed but it wrote some records in data tables
declare @IdImportOld int

select @IdImportOld = max(IdImport)
from ANNUAL_BUDGET_IMPORTS a
where [FileName] = @RealFileName

if @IdImportOld is not null 
   begin
	 if (select [Validation] from [ANNUAL_BUDGET_IMPORT_LOGS] where IdImport = @IdImportOld)  <> 'G'
	    begin
			delete ANNUAL_BUDGET_DATA_DETAILS_SALES where IdImport = @IdImportOld
			delete ANNUAL_BUDGET_DATA_DETAILS_COSTS where IdImport = @IdImportOld
			delete ANNUAL_BUDGET_DATA_DETAILS_HOURS where IdImport = @IdImportOld
		end
   end

-- 	############################################################

	--fill imports table
	DECLARE @IdImport INT
	SELECT @IdImport  = ISNULL(MAX(IdImport),0)+1 
	FROM ANNUAL_BUDGET_IMPORTS (TABLOCKX)

-- 	############################################################
		if exists(select IdRow from #tempTable
				where isnumeric(quantity1) = 0 or isnumeric(quantity2) = 0 or isnumeric(quantity3) = 0 or isnumeric(quantity4) = 0
				or isnumeric(quantity5) = 0 or isnumeric(quantity6) = 0 or isnumeric(quantity7) = 0 or isnumeric(quantity7) = 0
				or isnumeric(quantity8) = 0 or isnumeric(quantity9) = 0 or isnumeric(quantity10) = 0 or isnumeric(quantity11) = 0 or isnumeric(quantity12) = 0
				or isnumeric(Value1) = 0 or isnumeric(Value2) = 0 or isnumeric(Value3) = 0 or isnumeric(Value4) = 0
				or isnumeric(Value5) = 0 or isnumeric(Value6) = 0 or isnumeric(Value7) = 0 or isnumeric(Value7) = 0
				or isnumeric(Value8) = 0 or isnumeric(Value9) = 0 or isnumeric(Value10) = 0 or isnumeric(Value11) = 0 or isnumeric(Value12) = 0)

		  begin
				INSERT INTO [ANNUAL_BUDGET_IMPORTS]
					([IdImport], [ImportDate], [FileName], [IdAssociate], 
						ExclusionCostCenterRowsNo, ExclusionGlAccountsRowsNo)
				VALUES	(@IdImport,  GETDATE(),	   @RealFileName, @IdAssociate,
					@ROWCOUNTDELETED_CC, @ROWCOUNTDELETED_GL)


				INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS]
				( [IdImport],[Year], [Validation] )
				VALUES (@IDImport, @YEAR, 'R')


				INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
				( [IdImport], [IdRow], [Details], [Module] )
				select @IdImport, [IdRow],'Row ' + cast(IdRow as varchar) 
				+ case when isnumeric(quantity1) = 0 then ' column Quantity1 is not numeric' else '' end
				+ case when isnumeric(quantity2) = 0 then ' column Quantity2 is not numeric' else '' end
				+ case when isnumeric(quantity3) = 0 then ' column Quantity3 is not numeric' else '' end
				+ case when isnumeric(quantity4) = 0 then ' column Quantity4 is not numeric' else '' end
				+ case when isnumeric(quantity5) = 0 then ' column Quantity5 is not numeric' else '' end
				+ case when isnumeric(quantity6) = 0 then ' column Quantity6 is not numeric' else '' end
				+ case when isnumeric(quantity7) = 0 then ' column Quantity7 is not numeric' else '' end
				+ case when isnumeric(quantity8) = 0 then ' column Quantity8 is not numeric' else '' end
				+ case when isnumeric(quantity9) = 0 then ' column Quantity9 is not numeric' else '' end
				+ case when isnumeric(quantity10) = 0 then ' column Quantity10 is not numeric' else '' end
				+ case when isnumeric(quantity11) = 0 then ' column Quantity11 is not numeric' else '' end
				+ case when isnumeric(quantity12) = 0 then ' column Quantity12 is not numeric' else '' end
				,null
				from #tempTable
				where isnumeric(quantity1) = 0 or isnumeric(quantity2) = 0 or isnumeric(quantity3) = 0 or isnumeric(quantity4) = 0
				or isnumeric(quantity5) = 0 or isnumeric(quantity6) = 0 or isnumeric(quantity7) = 0 or isnumeric(quantity7) = 0
				or isnumeric(quantity8) = 0 or isnumeric(quantity9) = 0 or isnumeric(quantity10) = 0 or isnumeric(quantity11) = 0 or isnumeric(quantity12) = 0

				INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
				( [IdImport], [IdRow], [Details], [Module] )
				select @IdImport, [IdRow],'Row ' + cast(IdRow as varchar) 
				+ case when isnumeric(Value1) = 0 then ' column Value1 is not numeric' else '' end
				+ case when isnumeric(Value2) = 0 then ' column Value2 is not numeric' else '' end
				+ case when isnumeric(Value3) = 0 then ' column Value3 is not numeric' else '' end
				+ case when isnumeric(Value4) = 0 then ' column Value4 is not numeric' else '' end
				+ case when isnumeric(Value5) = 0 then ' column Value5 is not numeric' else '' end
				+ case when isnumeric(Value6) = 0 then ' column Value6 is not numeric' else '' end
				+ case when isnumeric(Value7) = 0 then ' column Value7 is not numeric' else '' end
				+ case when isnumeric(Value8) = 0 then ' column Value8 is not numeric' else '' end
				+ case when isnumeric(Value9) = 0 then ' column Value9 is not numeric' else '' end
				+ case when isnumeric(Value10) = 0 then ' column Value10 is not numeric' else '' end
				+ case when isnumeric(Value11) = 0 then ' column Value11 is not numeric' else '' end
				+ case when isnumeric(Value12) = 0 then ' column Value12 is not numeric' else '' end
				,null
				from #tempTable
				where isnumeric(Value1) = 0 or isnumeric(Value2) = 0 or isnumeric(Value3) = 0 or isnumeric(Value4) = 0
				or isnumeric(Value5) = 0 or isnumeric(Value6) = 0 or isnumeric(Value7) = 0 or isnumeric(Value7) = 0
				or isnumeric(Value8) = 0 or isnumeric(Value9) = 0 or isnumeric(Value10) = 0 or isnumeric(Value11) = 0 or isnumeric(Value12) = 0
		  end
		else
		  begin
			INSERT INTO [ANNUAL_BUDGET_IMPORTS]
				([IdImport], [ImportDate], [FileName], [IdAssociate], 
					ExclusionCostCenterRowsNo, ExclusionGlAccountsRowsNo)
			VALUES	(@IdImport,  GETDATE(),	   @RealFileName, @IdAssociate,
				@ROWCOUNTDELETED_CC, @ROWCOUNTDELETED_GL)

			INSERT INTO [ANNUAL_BUDGET_IMPORT_DETAILS]
				( [IdImport], [IdRow], [Country]
				, [Year], [CostCenter]
				, [ProjectCode], [WPCode],[AccountNumber]
				, [Quantity1], [Quantity2], [Quantity3], [Quantity4] 
				, [Quantity5], [Quantity6], [Quantity7], [Quantity8] 
				, [Quantity9], [Quantity10], [Quantity11], [Quantity12]
				, [Value1], [Value2], [Value3], [Value4]
				, [Value5], [Value6], [Value7], [Value8]
				, [Value9], [Value10], [Value11], [Value12]
				, [CurrencyCode], [Date])

			SELECT @IdImport, [IdRow], RTRIM(LTRIM([Country])) 
				,RTRIM(LTRIM([Year])), RTRIM(LTRIM([CostCenter]))
				,RTRIM(LTRIM([ProjectCode])), RTRIM(LTRIM([WPCode])), RTRIM(LTRIM([AccountNumber]))
				,RTRIM(LTRIM([Quantity1])), RTRIM(LTRIM([Quantity2])), RTRIM(LTRIM([Quantity3])), RTRIM(LTRIM([Quantity4])) 
				,RTRIM(LTRIM([Quantity5])), RTRIM(LTRIM([Quantity6])), RTRIM(LTRIM([Quantity7])), RTRIM(LTRIM([Quantity8]))
				,RTRIM(LTRIM([Quantity9])), RTRIM(LTRIM([Quantity10])), RTRIM(LTRIM([Quantity11])), RTRIM(LTRIM([Quantity12])) 
				,RTRIM(LTRIM([Value1])), RTRIM(LTRIM([Value2])), RTRIM(LTRIM([Value3])), RTRIM(LTRIM([Value4])) 
				,RTRIM(LTRIM([Value5])), RTRIM(LTRIM([Value6])), RTRIM(LTRIM([Value7])), RTRIM(LTRIM([Value8])) 
				,RTRIM(LTRIM([Value9])), RTRIM(LTRIM([Value10])), RTRIM(LTRIM([Value11])), RTRIM(LTRIM([Value12]))
				,RTRIM(LTRIM([CurrencyCode])), RTRIM(LTRIM([Date]))
			FROM #tempTable
		  end

	RETURN @IdImport
	GO

