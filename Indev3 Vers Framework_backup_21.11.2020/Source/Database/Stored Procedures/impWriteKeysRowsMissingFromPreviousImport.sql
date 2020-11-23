IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impWriteKeysRowsMissingFromPreviousImport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impWriteKeysRowsMissingFromPreviousImport
GO

--impSelectMissingKeysFromPreviousImport 6
CREATE PROCEDURE impWriteKeysRowsMissingFromPreviousImport
	@IdImport 	INT --ID of the import
AS
BEGIN

Declare	@IdImportPrevious int

Declare @IdSource int,
	@YearMonth int,
	@MaxIdRow int

DECLARE @NULLTempAssociateNumber varchar(15)
SET @NULLTempAssociateNumber = 'WKRM________' 

DECLARE @IMPORT_PREVIOUS TABLE
(
	IdImport		int,
	IdRow			int,
	ProjectCode		varchar(10),
	WPCode			varchar(3),
	CostCenter		varchar(15),
	AssociateNumber		varchar(15),
	Country			varchar(3),
	AccountNumber		varchar(20)

	PRIMARY KEY (IdImport, IdRow),
	UNIQUE (ProjectCode, WPCode, CostCenter, AssociateNumber, Country, AccountNumber)
)

DECLARE @IMPORT_CURRENT TABLE
(
	ProjectCode		varchar(10),
	WPCode			varchar(3),
	CostCenter		varchar(15),
	AssociateNumber		varchar(15),
	Country			varchar(3),
	AccountNumber		varchar(20),

	PRIMARY KEY (ProjectCode, WPCode, CostCenter, AssociateNumber, Country, AccountNumber)
)

SELECT @IdSource = IL.IdSource,
	@YearMonth = IL.YearMonth
FROM IMPORT_LOGS IL
WHERE IL.IdImport = @IdImport

--we look for the previous import succeded for the same source, same year and with a month before
select @IdImportPrevious = IMP.IdImport
from IMPORTS IMP
INNER JOIN IMPORT_LOGS IL
	ON IMP.IdImport = IL.IdImport
WHERE IL.IdSource = @IdSource AND                -- same source
      IL.YearMonth/100 = @YearMonth/100 and      -- same year
      IL.YearMonth = @YearMonth - 1 and 	-- only the previous and current months
      IL.Validation = 'G'

IF (@IdImportPrevious is NULL)
BEGIN
	-- no previous succesfull import found - bail out - we have nothing to compare to
	RETURN
END

INSERT INTO @IMPORT_PREVIOUS
	(IdImport, IdRow, ProjectCode, WPCode, CostCenter, AssociateNumber, Country, AccountNumber)
SELECT	@IdImportPrevious,
	MAX(IdRow), -- we will have multiple IdRows in case the associate is NULL for multiple rows with the same rest of the key
	ProjectCode,
	WPCode, 
	CostCenter, 
	ISNULL(AssociateNumber, @NULLTempAssociateNumber) AS AssociateNumber,
	Country,  
	AccountNumber
from IMPORT_DETAILS
where IdImport = @IdImportPrevious
group by ProjectCode, WPCode, CostCenter, AssociateNumber, Country, AccountNumber

INSERT INTO @IMPORT_CURRENT
	(ProjectCode, WPCode, CostCenter, AssociateNumber, Country, AccountNumber)
select  ProjectCode,
	WPCode, 
	CostCenter, 
	ISNULL(AssociateNumber, @NULLTempAssociateNumber) AS AssociateNumber,
	Country,  
	AccountNumber
from IMPORT_DETAILS
where IdImport = @IdImport
group by ProjectCode, WPCode, CostCenter, AssociateNumber, Country, AccountNumber

--we remove the rows that are found in the next import
DELETE P
FROM @IMPORT_PREVIOUS P
INNER JOIN @IMPORT_CURRENT C
	ON P.ProjectCode = C.ProjectCode AND
    	   P.WPCode = C.WPCode AND
    	   P.CostCenter = C.CostCenter AND
    	   P.AssociateNumber = C.AssociateNumber AND
    	   P.Country = C.Country AND
    	   P.AccountNumber = C.AccountNumber


select @MaxIdRow = MAX(IdRow) FROM IMPORT_DETAILS where IdImport = @IdImport

Declare @RowCount int

INSERT INTO
IMPORT_DETAILS_KEYROWS_MISSING
	(IdImport, IdRow, Country, Year, Month, 
	CostCenter, ProjectCode, WPCode, AccountNumber, AssociateNumber, 
	Quantity, UnitQty, Value, CurrencyCode, Date, IdImportPrevious )
SELECT  @IdImport, IMD.IdRow + @MaxIdRow, IMD.Country, IMD.[Year], IMD.[Month] + 1, 
	IMD.CostCenter, IMD.ProjectCode, IMD.WPCode, IMD.AccountNumber, NULLIF(IMD.AssociateNumber, @NULLTempAssociateNumber),
	0,NULL,0,IMD.CurrencyCode, IMD.[Date], @IdImportPrevious
FROM IMPORT_DETAILS IMD
INNER JOIN @IMPORT_PREVIOUS IP
	on IMD.IdImport = IP.IdImport AND
	   IMD.IdRow = IP.IdRow
SET @RowCount = @@ROWCOUNT

Return @RowCount

END
GO



