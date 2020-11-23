--Drops the Procedure impWriteToBudgetRevisedImportTable if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteToRevisedBudgetImportTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteToRevisedBudgetImportTable
GO

CREATE PROCEDURE impWriteToRevisedBudgetImportTable
	@fileName 	nvarchar(400),
	@IdAssociate	int
	
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
		ProjectCode varchar(10) NOT NULL,
		WPCode varchar(4) NOT NULL,
		AssociateNumber varchar(15) NOT NULL,
		CountryCode varchar(3) NOT NULL,
		CostCenterCode varchar(10) NOT NULL,
		HoursQty int,
		HoursVal decimal(18,4),
		SalesVal decimal(18,4),
		TE decimal(18,4),
		ProtoParts decimal(18,4),
		ProtoTooling decimal(18,4),
		Trials decimal(18,4),
		OtherExpenses decimal(18,4),
		CurrencyCode varchar(3) NOT NULL
	)	

	DECLARE @RealFileName nvarchar(100)
	Select @RealFileName = dbo.fnGetFileNameFromPath(@FileName)


	--fill the temporary table from file
	SET @SQL = 'BULK INSERT #tempTable FROM '''+ @FileName +
	''' WITH (FIELDTERMINATOR  = '';'',ROWTERMINATOR = ''\n'',FIRSTROW = 1,CODEPAGE = 1252,TABLOCK)
	ALTER TABLE #tempTable ADD  [IdRow] int Identity '
	EXEC(@SQL)
	

	--CHECK if the content of the file have the same ProjectCode as FileName
	DECLARE @Start int
	DECLARE @End int
	SET @Start = 0
	SET @End = 0
	DECLARE @ProjectCode varchar(200)
	
	SET @Start = PATINDEX('%RevisedBudget%', @RealFileName) + LEN('RevisedBudget')
	SET @End = PATINDEX('%.csv%', @RealFileName)
	
	IF( @Start > 0 AND @End > 0 AND @Start < @End )		
		SET @ProjectCode = SUBSTRING(@RealFileName, @Start, @End-@Start )
	
	IF ISNULL( @ProjectCode, '' ) = '' 
	BEGIN
		RAISERROR( 'The name of the file is invalid.', 16, 1)
		RETURN -1
	END

	IF EXISTS
	(
		SELECT * 
		FROM #tempTable 
		WHERE ProjectCode <> @ProjectCode
	)
	BEGIN
		DECLARE @Message varchar(200)
		SET @Message = 'This file must contain only data for the Project Code:' + CONVERT(varchar(200), @ProjectCode)
		RAISERROR( @Message, 16, 1)
		RETURN -1
	END

	-- added on 2020-1-17
	--Could you make INDEV recognize 0 as 000, X as 00X, XX as 0XX 
	update #tempTable
	set WPCode = right('00' + rtrim(WPCode),3)
	where len(rtrim(ltrim(WPCode))) < 3
	and WPCode like '%[0-9]'


	--fill imports table
	DECLARE @IDIMPORT INT
	SELECT @IDIMPORT  = ISNULL(MAX(IdImport),0)+1 
	FROM IMPORT_BUDGET_REVISED (TABLOCKX)

	INSERT INTO IMPORT_BUDGET_REVISED
		( IdImport,  ImportDate, FileName, idAssociate )
	VALUES( @IdImport, GETDATE(), @RealFileName, @IdAssociate )	

	INSERT INTO IMPORT_BUDGET_REVISED_DETAILS
		( IdImport, IdRow, ProjectCode, WPCode, AssociateNumber, CostCenterCode, 
		  CountryCode, HoursQty, HoursVal, SalesVal, TE, ProtoParts, ProtoTooling, 
		  Trials, OtherExpenses, CurrencyCode)
	
	SELECT @IdImport, IdRow, RTRIM(LTRIM(ProjectCode)) 
		,RTRIM(LTRIM(WPCode)), RTRIM(LTRIM(AssociateNumber)), RTRIM(LTRIM(CostCenterCode))
		,RTRIM(LTRIM(CountryCode)), RTRIM(LTRIM(HoursQty)), RTRIM(LTRIM(HoursVal)) 
		,RTRIM(LTRIM(SalesVal)), RTRIM(LTRIM(TE)), RTRIM(LTRIM(ProtoParts))
  		,RTRIM(LTRIM(ProtoTooling)), RTRIM(LTRIM(Trials))
		,RTRIM(LTRIM(OtherExpenses)), RTRIM(LTRIM(CurrencyCode))
	FROM #tempTable	
	
	DROP table #tempTable

	RETURN @IDIMPORT
GO


