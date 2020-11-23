--Drops the Procedure extExtractProgramInitialData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractProgramInitialData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractProgramInitialData
GO

--exec extExtractProgramInitialData 165

CREATE PROCEDURE extExtractProgramInitialData
(
	@IdProgram int,
	@WPActiveStatus varchar(1),
	@IdCurrencyAssociate	INT
)

AS

CREATE TABLE #InitialTemp
(
	ProjectCode 		varchar(10),
	ProjectName 		varchar(50),	
	PhaseCode 		varchar(3),
	WorkPackageCode 	varchar(3),
	WorkPackageName varchar(30),
	WorkPackageRank int,
	CountryName 		varchar(30),
	InergyLocationName 	varchar(30),
	CostCenterCode 		varchar(15),
	CostCenterName 		varchar(30),
	DepartmentName 		varchar(30),
	FunctionName 		varchar(30),
	EmployeeName 		varchar(50),
	EmployeeNumber 		varchar(15),
	CostTypeName 		varchar(50),
	GLAccountNumber 	varchar(20),
	GLAccountDescription 	varchar(30),
	ExtractCategoty	varchar(10),
	[Year] 			int,
	[Month] 		int,
	SumQuantity 		int,
	SumValue 		bigint,
	CurrencyCode 		varchar(3),
	ExchangeRate 		decimal(18,4),
	ValidationDate	varchar(10)
)


DECLARE ProgramInitialCursor CURSOR FAST_FORWARD FOR
--GET PROJECTS FROM @IDPROGRAM
	SELECT Id
	FROM PROJECTS
	WHERE IdProgram = @IdProgram		
OPEN ProgramInitialCursor
DECLARE @IdProject INT	

	FETCH NEXT FROM ProgramInitialCursor INTO @IdProject
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #InitialTemp
		exec extExtractProjectInitialData @IdProject, @WPActiveStatus,@IdCurrencyAssociate
		
		FETCH NEXT FROM ProgramInitialCursor INTO @IdProject
	END
CLOSE ProgramInitialCursor
DEALLOCATE ProgramInitialCursor

SELECT ProjectCode as 		[Project Code],
	ProjectName as 		[Project Name],	
	PhaseCode as		[Phase Code],
	WorkPackageCode as 	[WP Code],
	WorkPackageName as	[WP Name],
	WorkPackageRank as	[WP Rank],
	CountryName as 		[Country Name],
	InergyLocationName as 	[Inergy Location Name],
	CostCenterCode as 	[Cost Center Code],
	CostCenterName as 	[Cost Center Name],
	DepartmentName as 	[Department Name],
	FunctionName as 	[Function Name],
	EmployeeName as 	[Employee Name],
	EmployeeNumber as 	[Employee Number],
	CostTypeName as 	[Cost Type Name],
	GLAccountNumber as 	[GL Account Number],
	GLAccountDescription as	[GL Account Description],
	ExtractCategoty	as [Extract Category],
	[Year] as 		[Year],
	[Month] as 		[Month],
	SumQuantity as 		[Quantity],
	SumValue as 		[Value],
	CurrencyCode as		[Currency],
	ExchangeRate as 	[Exchange Rate],
	ValidationDate	as	[Validation Date]
FROM #InitialTemp

GO

