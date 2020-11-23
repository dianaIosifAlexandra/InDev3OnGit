--Drops the Procedure extExtractProgramActualData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[extExtractProgramActualData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE extExtractProgramActualData
GO

--exec extExtractProgramActualData 165

CREATE PROCEDURE extExtractProgramActualData
(
	@IdProgram int,
	@WPActiveStatus varchar(1),
	@IdCurrencyAssociate int
)

AS

CREATE TABLE #ActualTemp
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
	ExtractCategoty		varchar(10),
	[Year] 			int,
	[Month] 		int,
	SumQuantity 		decimal(12,2),
	SumValue 		decimal(18,2),
	CurrencyCode 		varchar(3),
	ExchangeRate 		decimal(18,4),
	ValidationDate	varchar(10)
)


DECLARE ProgramActualCursor CURSOR FAST_FORWARD FOR
--GET PROJECTS FROM @IDPROGRAM
	SELECT Id
	FROM PROJECTS
	WHERE IdProgram = @IdProgram		
OPEN ProgramActualCursor
DECLARE @IdProject INT	

	FETCH NEXT FROM ProgramActualCursor INTO @IdProject
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #ActualTemp
		exec extExtractProjectActualData @IdProject, @WPActiveStatus,@IdCurrencyAssociate
		
		FETCH NEXT FROM ProgramActualCursor INTO @IdProject
	END
CLOSE ProgramActualCursor
DEALLOCATE ProgramActualCursor

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
	GLAccountDescription	[GL Account Description],
	ExtractCategoty	as [Extract Category], 
	[Year] as 		[Year],
	[Month] as 		[Month],
	SumQuantity as 		[Quantity],
	SumValue as 		[Value],
	CurrencyCode as		[Currency],
	ExchangeRate as 	[Exchange Rate],
	ValidationDate	as	[Validation Date]
FROM #ActualTemp

GO

