/****** Object:  StoredProcedure [dbo].[dbo.impWriteToAnnualTable]    Script Date: 06/16/2014 17:30:08 ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteToAnnualTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteToAnnualTable
GO



CREATE     PROCEDURE impWriteToAnnualTable
	@fileName 	nvarchar(400), 	--The name of the file	
	@IdImport INT,			-- ID of the import
	@SkipStartEndPhaseErrorsHours bit = 0, -- Skip Start/End Phase Validation for Hours/Vals
	@SkipStartEndPhaseErrorsCosts bit = 0, -- Skip Start/End Phase Validation for Costs
	@SkipStartEndPhaseErrorsSales bit = 0 -- Skip Start/End Phase Validation for Costs
AS

DECLARE @Year int
DECLARE @Country varchar(3)
DECLARE @Message varchar(200)
--#############BECAUSE THE FILENAME IS FIXED FORM WE CAN AFFORD TO TAKE THE YEAR FROM IT
-- 	DECLARE @fileName 	nvarchar(400)
-- 	SET @filename = 'D:\Work\INDEV3\Source\Indev3WebSite\Indev3WebSite\UploadDirectories\InProcess\FRA2007_2007_9_4.csv'
	SET @Year=SUBSTRING(RIGHT(@fileName,CHARINDEX('\',REVERSE(@fileName)) -1),4,4)
	set @Country = SUBSTRING(RIGHT(@fileName,CHARINDEX('\',REVERSE(@fileName)) -1),1,3)
-- 	PRINT @YEAR
--#############################################################################################

	DECLARE @RetVal INT


	IF (@fileName is null )
	BEGIN 
		RAISERROR('No file has been selected',16,1)		
		RETURN -1
	END

	-- Check if rows have imported into ANNUAL_BUDGET_IMPORT_DETAILS.
	-- If they don't and exist rows in ANNUAL_BUDGET_IMPORT_LOGS_DETAILS, this means
	-- that one of Quantity or Value columns was not numeric
	if exists(SELECT IdImport  FROM ANNUAL_BUDGET_IMPORTS WHERE IdImport = @IdImport)
	and not exists(select IdImport from ANNUAL_BUDGET_IMPORT_DETAILS WHERE IdImport = @IdImport)
	and exists(select IdImport from ANNUAL_BUDGET_IMPORT_LOGS_DETAILS WHERE IdImport = @IdImport)
	   begin
			SET @Message = 'There is at least one row in the imported file where there are not numeric Quantity or Value'
			RAISERROR(@Message, 16, 1)		
			RETURN -8
	   end

	IF EXISTS (SELECT IdImport
		   FROM ANNUAL_BUDGET_IMPORT_DETAILS
		   WHERE IdImport = @IdImport AND
			Country <> @Country AND 
			@Country <> 'All' )

	BEGIN
		SET @Message = 'There is at least one row in the imported file that do not belong to selected country: ' + @Country
		RAISERROR(@Message, 16, 1)		
		RETURN -1
	END

	IF EXISTS (SELECT IdImport
		   FROM ANNUAL_BUDGET_IMPORT_DETAILS
		   WHERE IdImport = @IdImport AND
			Year <> @Year )

	BEGIN
		SET @Message = 'There is at least one row in the imported file that do not belong to Year: ' + cast(@Year as varchar(4))
		RAISERROR(@Message, 16, 1)		
		RETURN -1
	END

	--check mandatory fields
	--#########################   INSERT INTO LOGS IF NULL OR NOT EXISTS
	
	
	IF EXISTS
	(
		SELECT IdImport 
		FROM ANNUAL_BUDGET_IMPORT_DETAILS IMD
		WHERE 
		IMD.IdImport = @IdImport
		AND
		
		(
			-- no country
			(IMD.Country IS NULL  OR 
				NOT EXISTS(SELECT ID 
						FROM COUNTRIES 
						WHERE CODE =IMD.Country)
			) 
			-- NO YEAR
			OR  IMD.Year IS NULL
			OR IMD.Year NOT BETWEEN 1900 and 2079
			-- NO cost center
			OR (IMD.CostCenter IS NULL
				OR NOT EXISTS
					(
						SELECT CC.Id 
						FROM COST_CENTERS CC 
						INNER JOIN INERGY_LOCATIONS IL 
							ON CC.IdInergyLocation = IL.ID 
						INNER JOIN Countries C 
							ON IL.IdCountry = C.Id						
						WHERE CC.CODE=IMD.CostCenter AND
						      C.Code =IMD.Country
					)
			   )
			--NO project code
			OR (IMD.ProjectCode IS NULL  OR 
				NOT EXISTS(SELECT ID FROM PROJECTS WHERE CODE=IMD.ProjectCode )
			    )
			-- Project is not of type CRAINB
			OR (left(IMD.ProjectCode,1) not in ('C','R','A','I','N','Z','B')
			)
			--NO WP code
			OR (IMD.WPCode IS NULL  
				OR NOT EXISTS(	SELECT TOP 1  WP.Code 
						FROM WORK_PACKAGES WP												
					      	INNER JOIN PROJECTS P
					      		ON P.Id	= WP.IdProject AND
							   P.Code = IMD.ProjectCode				
					     	WHERE WP.CODE = IMD.WPCode
					      )
			    )
            -- WPCode can be 0xy only and only for projects of type ZRAINB			    
			OR ( (IMD.WPCode like '0%' and left(IMD.ProjectCode,1) not in ('Z','R','A','I','N','B'))             )				  
			--NO Account Number
			OR (IMD.AccountNumber  IS NULL  OR 
					NOT EXISTS(SELECT GL.ID
						   FROM GL_ACCOUNTS GL 
						   INNER JOIN COUNTRIES C
							ON GL.IdCountry = C.Id 
						   WHERE Account = IMD.AccountNumber AND
							C.Code = IMD.Country )
			   )
			--NO Quantity
-- 			OR (IMD.Quantity IS NULL)
		)
		
	)
	
	BEGIN
		exec impWriteToLogAnnualTables @fileName, @IdImport
		RETURN -2
	END
	
-- 	CHECK TO SEE IF THERE ARE DUPLICATED KEY VALUES IN IMPORT TABLE
	DECLARE @ROWCOUNT INT


	IF EXISTS
	(SELECT Country, 
		ProjectCode,
		WPCode, 
		CostCenter,
		Year, 
		--Month, 
		AccountNumber
	FROM ANNUAL_BUDGET_IMPORT_DETAILS
	WHERE IdImport = @IdImport
	GROUP BY Country, ProjectCode, WPCode, CostCenter, Year, AccountNumber
	HAVING COUNT(ProjectCode) >1)		
	BEGIN
		INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS]
		( [IdImport],[Year], [Validation] )
		VALUES (@IDImport, @YEAR, 'O')

		DECLARE @C VARCHAR(3), @Y int, 
		@CC VARCHAR(10), @PC VARCHAR(10),
		@WP VARCHAR(4), @AN VARCHAR(10)
		
		SET  @Message = 'There is at least another row which has the same Country + Year + CostCenter + ProjectCode + WPCode + AccountNumber as this row. This is not allowed.'

		DECLARE alog_cursor CURSOR FAST_FORWARD FOR
		SELECT 	Country, 
			ProjectCode,
			WPCode, 
			CostCenter,
			Year, 
			AccountNumber
		FROM ANNUAL_BUDGET_IMPORT_DETAILS
		WHERE IdImport = @IdImport
		GROUP BY Country, ProjectCode, WPCode, CostCenter, Year, AccountNumber
		HAVING COUNT(ProjectCode) >1

		OPEN alog_cursor
		FETCH NEXT FROM alog_cursor 
		INTO @C,@PC, @WP, @CC, @Y, @AN

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS_DETAILS]
			([IdImport], [IdRow], [Details] )			
			SELECT @IdImport, IdRow, @Message
			FROM ANNUAL_BUDGET_IMPORT_DETAILS
			WHERE 	Country = @C AND
				Year = @Y AND
				CostCenter = @CC AND
				ProjectCode = @PC AND
				WPCode = @WP AND
				AccountNumber = @AN AND			
				IdImport = @IdImport

			FETCH NEXT FROM alog_cursor 
			INTO @C,@PC, @WP, @CC, @Y, @AN
		END
		CLOSE alog_cursor
		DEALLOCATE alog_cursor
		
		RETURN -3
	END


	--######################### IF NOT EXIST THEN DOCUMENT OK BEGIN IMPORT TO ANNUAL


	ELSE
	BEGIN
		

-- 		PRINT 'INSERT ANNUAL_BUDGET'
		INSERT INTO ANNUAL_BUDGET (IDProject, [Date])

		SELECT DISTINCT P.ID, GETDATE() 
		FROM Projects P 
		INNER JOIN ANNUAL_BUDGET_IMPORT_DETAILS IMD 
			ON P.Code = IMD.ProjectCode 
		LEFT JOIN ANNUAL_BUDGET AB
			ON AB.IdProject = P.ID
		WHERE IMD.IdImport = @IdImport
		AND AB.IdProject IS NULL	


		IF(@@ERROR<>0)
			RETURN -4
		

		--insert into hours table
		EXEC @RetVal = impWriteAnnualTableHours @IdImport, @SkipStartEndPhaseErrorsHours
		if (@@ERROR<>0 OR @RetVal < 0)
		   begin
			if @RetVal = -1000
			   return @RetVal
			else
				return -5
		   end

		-- insert into SALES table
		EXEC @RetVal = impWriteAnnualTableSales @IdImport, @SkipStartEndPhaseErrorsSales
		if (@@ERROR<>0 OR @RetVal < 0)
		   begin
			if @RetVal = -3000
			   return @RetVal
			else
				return -6
		   end
		
		--INSERT OTHER TYPE OF COSTS IN ANNUAL_BUDGET_DATA_DETAILS_COSTS
		EXEC @RetVal = impWriteAnnualTableDetailsCosts @IdImport, @SkipStartEndPhaseErrorsCosts
		if (@@ERROR<>0 OR @RetVal < 0)
		   begin
			if @RetVal = -2000
			   return @RetVal
			else
				return -7
		   end

		INSERT INTO [ANNUAL_BUDGET_IMPORT_LOGS]
			( [IdImport], [Year], [Validation] )
		VALUES (@IDImport, @YEAR, 'G')

	END



GO


