--Drops the Procedure impWriteToActualTable if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteToActualTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteToActualTable
GO

--impWriteToActualTable 10,5
CREATE PROCEDURE impWriteToActualTable
	@IdAssociate INT,		--ID of the associate	
	@IdImport INT,			--ID of the import	
	@SkipCCHRError bit		--Skip Cost Center without Hourly Rate error
AS
BEGIN
	DECLARE @result 	INT,
		@YEARMONTH 	INT,
		@IdSource 	INT,
		@Message 	varchar(255)
	
	SELECT @IdSource = IL.IdSource, 
		   @YearMonth = IL.YearMonth
	FROM IMPORT_LOGS IL
	WHERE IL.IdImport = @IdImport

	IF EXISTS (SELECT IdImport
		   FROM IMPORT_DETAILS
		   WHERE IdImport = @IdImport AND
			[YEAR]*100 + [MONTH] <> @YEARMONTH)
	BEGIN
		DECLARE @YMString varchar(255)
		SET @YMString = 'There is at list one row in the imported file that do not belong to YearMonth: ' + dbo.fnGetYMStringRepresentation(@YearMonth)
		exec impProcessErrorToLogTable @IdImport, @YMString
		RETURN -3
	END
		
	--check mandatory fields
	--#########################   INSERT INTO LOGS IF NULL OR NOT EXISTS
		
	IF EXISTS
	(
		SELECT IdImport 
		FROM Import_details IMD
		WHERE 
		IMD.IdImport = @IdImport
		AND
		
		(
			-- no country
			(IMD.Country IS NULL  OR 
				NOT EXISTS(SELECT ID 
					   FROM COUNTRIES 
					   WHERE CODE = IMD.Country)
			)
			-- no import source for country
			OR NOT EXISTS(SELECT C.Id	   
						  FROM COUNTRIES C
						  INNER JOIN IMPORT_SOURCES_COUNTRIES ISC 
							 ON C.Id = ISC.IdCountry AND
								@IdSource = ISC.IdImportSource
						   WHERE C.Code = IMD.Country)
			-- NO YEAR
			OR  IMD.Year IS NULL
-- 			YEAR not valid
			OR IMD.Year NOT BETWEEN 1900 AND 2079
			--NO MONTH
			OR IMD.Month IS NULL
			OR IMD.Month NOT BETWEEN 1 and 12
			-- NO cost center
			OR (IMD.CostCenter IS NULL OR
			    NOT EXISTS
				(
					SELECT CC.Id 
					FROM COST_CENTERS CC 
					INNER JOIN INERGY_LOCATIONS IL 
					        ON CC.IdInergyLocation = IL.ID 
					INNER JOIN Countries C 
						ON IL.IdCountry = C.Id     
					WHERE CC.CODE = IMD.CostCenter AND
					      C.Code = IMD.Country
				)
			   )
			--NO project code
			OR (IMD.ProjectCode IS NULL  OR 
				NOT EXISTS(SELECT ID 
					   FROM PROJECTS 
					   WHERE CODE = IMD.ProjectCode )
			    )
			--NO WP code
			OR (IMD.WPCode IS NULL OR
				NOT EXISTS(SELECT TOP 1  WP.Code 
					   FROM WORK_PACKAGES WP
					   INNER JOIN PROJECTS P
					      ON P.Id = WP.IdProject AND
						 P.Code = IMD.ProjectCode
					   WHERE WP.CODE = IMD.WPCode
						      )
			    )
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
			OR (IMD.Quantity IS NULL)		
			--NO Hourly Rate
			-- Commented on 11/18/2014 per request

		)
	)
	BEGIN
		exec impWriteToLogTables @IdImport, @IdAssociate
		return -4
	END
	
-- CHECK TO SEE IF THERE ARE COST CENTERS WITHOUT HOURLEY RATE
if @SkipCCHRError = 0
  begin
	IF EXISTS
	(
		SELECT IdImport 
		FROM Import_details IMD
		WHERE 
		IMD.IdImport = @IdImport
		AND
		(
			--NO Hourly Rate
			-- Commented on 11/18/2014 per request
			  (NOT EXISTS(SELECT HourlyRate 
							FROM HOURLY_RATES AS HR
							INNER JOIN COST_CENTERS CC
									ON HR.IdCostCenter = CC.Id
							WHERE 	IMD.CostCenter = CC.Code AND
									HR.YearMonth = @YEARMONTH)
				)

		)
	)
	BEGIN
		exec impWriteToLogTables @IdImport, @IdAssociate
		return 1000 -- it is not a failure code
	END
  end
	

-- 	CHECK TO SEE IF THERE ARE DUPLICATED KEY VALUES IN IMPORT TABLE
	
	IF EXISTS
	(SELECT Country, 
		Year, 
		Month, 
		CostCenter, 
		ProjectCode, 
		WPCode, 
		AccountNumber,
		AssociateNumber
	FROM IMPORT_DETAILS
	WHERE IdImport = @IdImport AND
	      AssociateNumber IS NOT NULL
	GROUP BY Country, Year, Month, CostCenter, 
	 	ProjectCode, WPCode, AccountNumber,AssociateNumber
	HAVING COUNT(Country)>1)

	BEGIN
		

		UPDATE [IMPORT_LOGS]
		SET Validation = 'O'
		WHERE IdImport = @IdImport

		DECLARE @C VARCHAR(3), @Y int, @M int,
			@CC VARCHAR(10), @PC VARCHAR(10),
			@WP VARCHAR(4), @AN VARCHAR(10), @ASN VARCHAR(15)

		SET  @Message = 'There is at least another row which has the same Country + Year + Month + CostCenter + ProjectCode + WPCode + AccountNumber + AssociateNumber as this row. This is not allowed.'
		DECLARE log_cursor CURSOR FAST_FORWARD FOR
		SELECT 	Country, 
			Year, 
			Month, 
			CostCenter, 
			ProjectCode, 
			WPCode, 
			AccountNumber, 
			AssociateNumber
		FROM IMPORT_DETAILS
		WHERE IdImport = @IdImport AND
		AssociateNumber IS NOT NULL
		GROUP BY Country, Year, Month, CostCenter, 
		ProjectCode, WPCode, AccountNumber, AssociateNumber
		HAVING COUNT(Country)>1
		
		OPEN log_cursor
		FETCH NEXT FROM log_cursor 
		INTO @C,@Y, @M, @CC, @PC, @WP, @AN, @ASN
	
		WHILE @@FETCH_STATUS = 0
		BEGIN

			INSERT INTO [IMPORT_LOGS_DETAILS]
			([IdImport], [IdRow], [Details] )			
			SELECT @IdImport, IdRow, @Message
			FROM  IMPORT_DETAILS
			WHERE 	Country = @C AND
				Year = @Y AND
				Month = @M AND
				CostCenter = @CC AND
				ProjectCode = @PC AND
				WPCode = @WP AND
				AccountNumber = @AN AND
				AssociateNumber = @ASN AND
				IdImport = @IdImport
		
		FETCH NEXT FROM log_cursor 
		INTO @C,@Y, @M, @CC, @PC, @WP, @AN, @ASN
		END
	
		CLOSE log_cursor
		DEALLOCATE log_cursor
		

		return -5
	END

-- 	########################### AUTOMATICALLY INSERT ALL IMPORT ASSOCIATES WITH NOT NULL ASSOCIATESNUMBERS THAT NOT EXISTS IN ASSOCIATES TABLE
-- 	________________________________________________________________________
	DECLARE @AssociateNumber varchar(15)
	DECLARE @AssociateIdCountry varchar(3) 

	DECLARE @INERGYLOGIN VARCHAR(30)
	DECLARE @COUNT_ASSOC INT
	SET @COUNT_ASSOC = 0
	
	DECLARE ImportAssociatesCursor CURSOR FAST_FORWARD FOR
	SELECT 	DISTINCT C.Id, IMD.AssociateNumber	
	FROM IMPORT_DETAILS IMD 
	INNER JOIN COUNTRIES C
		ON IMD.Country = C.Code
	LEFT JOIN ASSOCIATES A 
		ON IMD.AssociateNumber = A.EmployeeNumber AND
		   C.Id = A.IdCountry 
	WHERE 	AssociateNumber IS NOT NULL AND
	      	A.Id IS NULL AND
	      	IMD.IdImport = @IdImport

	OPEN ImportAssociatesCursor
	FETCH NEXT FROM ImportAssociatesCursor INTO @AssociateIdCountry, @AssociateNumber
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		SET @INERGYLOGIN = 'UPLOAD\' + @AssociateNumber + '_' + CAST(@IdImport AS VARCHAR(7))
		exec catInsertAssociate @AssociateIdCountry, @AssociateNumber, 'NULL, NULL', @INERGYLOGIN, 0, 0, 0

		SET @COUNT_ASSOC = @COUNT_ASSOC + 1

		FETCH NEXT FROM ImportAssociatesCursor INTO @AssociateIdCountry, @AssociateNumber
	END
	
	CLOSE ImportAssociatesCursor
	DEALLOCATE ImportAssociatesCursor	

-- 	######################### IF NO ERROR THEN BEGIN IMPORT TO ACTUAL	

	INSERT INTO ACTUAL_DATA (IDProject, [Date])
	SELECT DISTINCT P.ID, GETDATE()
	FROM PROJECTS P 
	INNER JOIN IMPORT_DETAILS IMD 
		ON P.CODE = IMD.PROJECTCODE
	LEFT JOIN ACTUAL_DATA AD
		ON AD.IDPROJECT = P.ID
	WHERE IMD.IDIMPORT = @IdImport AND 
	AD.IDPROJECT IS NULL
	
	IF(@@ERROR<>0)	
		return -6
	

	DECLARE @RetVal INT

	--insert hours
	EXEC @RetVal = impWriteActualTableHours @IdImport
	if (@@ERROR <> 0 OR @RetVal < 0)
		return -7

	--insert costs
	EXEC @RetVal = impWriteActualTableCosts @IdImport
	if (@@ERROR <> 0 OR @RetVal < 0)
		return -8

	-- insert sales
	EXEC @RetVal = impWriteActualTableSales @IdImport
	if (@@ERROR <> 0 OR @RetVal < 0)
		return -9


	-- import is succesfully
	UPDATE IMPORT_LOGS
	SET Validation = 'G'
	WHERE IdImport = @IdImport

	-- Do all 4 checks for the current import (hours, hoursval, costval, salesval)
	EXEC @RetVal = impCheckImportedDataConsistency @IdImport
	if (@@ERROR <> 0 OR @RetVal < 0)
	BEGIN
		-- import is not succesfully
		UPDATE IMPORT_LOGS
		SET Validation = 'R'
		WHERE IdImport = @IdImport

		RETURN -10
	END




	
	--mark in tocompletion  data the yearmonth in whcih the actual data has reached with data

	DECLARE @updatedProjects table
	(
		IdProject INT NOT NULL PRIMARY KEY
	)

	INSERT INTO @updatedProjects (IdProject)
	(SELECT DISTINCT IdProject
	FROM ACTUAL_DATA_DETAILS_HOURS
	WHERE IdImport = @IdImport)
	UNION
	(SELECT DISTINCT IdProject
	FROM ACTUAL_DATA_DETAILS_SALES
	WHERE IdImport = @IdImport)
	UNION
	(SELECT DISTINCT IdProject
	FROM ACTUAL_DATA_DETAILS_COSTS
	WHERE IdImport = @IdImport)


	UPDATE  BT
	SET YearMonthActualData = 
			CASE WHEN ISNULL(BT.YearMonthActualData,190001)<@YEARMONTH 
			THEN	@YEARMONTH ELSE BT.YearMonthActualData END
	FROM BUDGET_TOCOMPLETION BT
	INNER JOIN @updatedProjects up
	ON 	bt.IdProject = up.IdProject AND 
	      	bt.IdGeneration = (SELECT MAX(BTC.IdGeneration)
						  FROM BUDGET_TOCOMPLETION AS BTC
						  WHERE BTC.IdProject = bt.IdProject)
		

END

GO

