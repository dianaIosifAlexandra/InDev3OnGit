--insert project
IF NOT EXISTS (SELECT * FROM [INDEV3Work].[dbo].[PROJECTS] 
                WHERE [INDEV3Work].[dbo].[PROJECTS].[Id]=6)
BEGIN
    INSERT INTO [INDEV3Work].[dbo].[PROJECTS] ([Id], [Code], [Name], [IdProgram], [IdProjectType], [IsActive])
	    VALUES(6,'PrjG1','ProjectGabi1',1,1,1)
END

--insert workpackages
INSERT INTO [INDEV3Work].[dbo].[WORK_PACKAGES]([IdProject], [IdPhase], [Id], [Code], [Name], [DisplayNo], [IsActive], [StartYearMonth], [EndYearMonth],[LastUpdate],[LastUserUpdate])
	VALUES(6, 1,10,'WG1','WorkG10101',100,1,200009,200011,GETDATE(),1)
INSERT INTO [INDEV3Work].[dbo].[WORK_PACKAGES]([IdProject], [IdPhase], [Id], [Code], [Name], [DisplayNo], [IsActive], [StartYearMonth], [EndYearMonth],[LastUpdate],[LastUserUpdate])
	VALUES(6, 2,11,'WG2','WorkG10201',100,1,200011,200012,GETDATE(),1)
INSERT INTO [INDEV3Work].[dbo].[WORK_PACKAGES]([IdProject], [IdPhase], [Id], [Code], [Name], [DisplayNo], [IsActive], [StartYearMonth], [EndYearMonth],[LastUpdate],[LastUserUpdate])
	VALUES(6, 2,12,'WG3','WorkG10202',100,1,200012,200103,GETDATE(),1)
INSERT INTO [INDEV3Work].[dbo].[WORK_PACKAGES]([IdProject], [IdPhase], [Id], [Code], [Name], [DisplayNo], [IsActive], [StartYearMonth], [EndYearMonth],[LastUpdate],[LastUserUpdate])
	VALUES(6, 3,13,'WG4','WorkG10301',100,1,200103,200105,GETDATE(),1)
INSERT INTO [INDEV3Work].[dbo].[WORK_PACKAGES]([IdProject], [IdPhase], [Id], [Code], [Name], [DisplayNo], [IsActive], [StartYearMonth], [EndYearMonth],[LastUpdate],[LastUserUpdate])
	VALUES(6, 4,14,'WG5','WorkG10401',100,1,200105,200106,GETDATE(),1)
INSERT INTO [INDEV3Work].[dbo].[WORK_PACKAGES]([IdProject], [IdPhase], [Id], [Code], [Name], [DisplayNo], [IsActive], [StartYearMonth], [EndYearMonth],[LastUpdate],[LastUserUpdate])
	VALUES(6, 4,15,'WG6','WorkG10402',100,1,200106,200108,GETDATE(),1)
INSERT INTO [INDEV3Work].[dbo].[WORK_PACKAGES]([IdProject], [IdPhase], [Id], [Code], [Name], [DisplayNo], [IsActive], [StartYearMonth], [EndYearMonth],[LastUpdate],[LastUserUpdate])
	VALUES(6, 4,16,'WG7','WorkG10403',100,1,200108,200108,GETDATE(),1)

--insert cost centers
INSERT INTO [INDEV3Work].[dbo].[COST_CENTERS]([Id], [IdInergyLocation], [Code], [Name], [IsActive], [IdDepartment])
	VALUES(4,1,'ccCode1','ccName1',1,1)
INSERT INTO [INDEV3Work].[dbo].[COST_CENTERS]([Id], [IdInergyLocation], [Code], [Name], [IsActive], [IdDepartment])
	VALUES(5,1,'ccCode2','ccName2',1,1)
INSERT INTO [INDEV3Work].[dbo].[COST_CENTERS]([Id], [IdInergyLocation], [Code], [Name], [IsActive], [IdDepartment])
	VALUES(6,2,'ccCode3','ccName3',1,1)


--insert budget cost types
INSERT INTO [INDEV3Work].[dbo].[BUDGET_COST_TYPES]([Id], [Name])
	VALUES(1,'T&E')
INSERT INTO [INDEV3Work].[dbo].[BUDGET_COST_TYPES]([Id], [Name])
	VALUES(2,'Proto parts')
INSERT INTO [INDEV3Work].[dbo].[BUDGET_COST_TYPES]([Id], [Name])
	VALUES(3,'Proto toling')
INSERT INTO [INDEV3Work].[dbo].[BUDGET_COST_TYPES]([Id], [Name])
	VALUES(4,'Trials')
INSERT INTO [INDEV3Work].[dbo].[BUDGET_COST_TYPES]([Id], [Name])
	VALUES(5,'Others expenses')

--insert budget initial detail
DELETE FROM [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL_COSTS]
DELETE FROM [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL]
DELETE FROM [INDEV3Work].[dbo].[BUDGET_INITIAL]

DECLARE @IdAssociate INT,@MaxRecords INT
DECLARE @IdProject INT,@IdGeneration INT, @IdPhase INT, @IdWP INT, @IdCC INT, @YearMonth INT, @IdDetail INT
SET @IdAssociate = 8 		-- set associate value only for budget initial detail
SET @MaxRecords = 2000         	-- set maximum number of records
--insert budget initial
IF NOT EXISTS (SELECT * FROM [INDEV3Work].[dbo].[BUDGET_INITIAL] AS BI
		WHERE BI.IdProject = 6 AND BI.IsValidated = 0)
BEGIN
	INSERT INTO [INDEV3Work].[dbo].[BUDGET_INITIAL] ([IdProject], [IsValidated], [ValidationDate])
		VALUES(6, 0, GETDATE())
END
SET IDENTITY_INSERT [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL] ON
WHILE @MaxRecords >0
BEGIN
	SET @IdProject = 6
	SET @IdGeneration = ROUND(1+(2*RAND()),0)
	SET @IdWP = ROUND(10+(6*RAND()),0)
	SET @IdPhase = (SELECT IdPhase FROM WORK_PACKAGES AS WP
		WHERE WP.IdProject = @IdProject AND WP.[Id] = @IdWP) 
	SET @IdCC = ROUND(3+(3*RAND()),0)
--	SET @IdAssociate = ROUND(2+(1*RAND()),0)
	SET @YearMonth = (100*ROUND(2000+(1*RAND()),0))+ROUND(1+(11*RAND()),0)
	SELECT @IdDetail = ISNULL(Max(IdDetail)+1,1) FROM [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL]
	PRINT CONVERT(VARCHAR(3),@IdProject) +  ', ' + CONVERT(VARCHAR(3),@IdGeneration)
		+  ', ' + CONVERT(VARCHAR(5),@IdWP) +  ', ' + CONVERT(VARCHAR(5),@IdPhase)
		+  ', ' + CONVERT(VARCHAR(5),@IdCC) +  ', ' + CONVERT(VARCHAR(6),@YearMonth)
		+  ', ' + CONVERT(VARCHAR(5),@IdDetail)
	IF NOT EXISTS (SELECT * FROM [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL] AS BID
		WHERE BID.IdProject = @IdProject AND BID.IdPhase = @IdPhase AND BID.IdWorkPackage = @IdWP
			AND BID.IdCostCenter = @IdCC AND BID.IdAssociate = @IdAssociate AND BID.YearMonth = @YearMonth)
	BEGIN
	    INSERT INTO [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL]([IdProject], [IdPhase], [IdWorkPackage], [IdCostCenter], [IdAssociate], [YearMonth], [IdDetail], [HoursQty], [HoursVal], [SalesVal])
        	VALUES(@IdProject,@IdPhase ,@IdWP ,@IdCC , @IdAssociate, @YearMonth, @IdDetail,round(1+50*RAND(),0), round(1+50*RAND(),0), 50000000*RAND())

		INSERT INTO [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL_COSTS]
			([IdDetail], [IdCostType], [CostVal]) VALUES(@IdDetail, 1,  50000000*RAND())
		INSERT INTO [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL_COSTS]
			([IdDetail], [IdCostType], [CostVal]) VALUES(@IdDetail, 2,  50000000*RAND())
		INSERT INTO [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL_COSTS]
			([IdDetail], [IdCostType], [CostVal]) VALUES(@IdDetail, 3,  50000000*RAND())
		INSERT INTO [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL_COSTS]
			([IdDetail], [IdCostType], [CostVal]) VALUES(@IdDetail, 4,  50000000*RAND())
		INSERT INTO [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL_COSTS]
			([IdDetail], [IdCostType], [CostVal]) VALUES(@IdDetail, 5,  50000000*RAND())
	END
    SET @MaxRecords = @MaxRecords - 1
END
SET IDENTITY_INSERT [INDEV3Work].[dbo].[BUDGET_INITIAL_DETAIL] OFF
GO

select * from budget_states

--insert budget revised detail
DELETE FROM [INDEV3Work].[dbo].[BUDGET_REVISED_STATES]
DELETE FROM [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL_COSTS]
DELETE FROM [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL]
DELETE FROM [INDEV3Work].[dbo].[BUDGET_REVISED]
DECLARE @IdAssociate INT,@MaxRecords INT
DECLARE @IdProject INT,@IdGeneration INT, @IdPhase INT, @IdWP INT, @IdCC INT, @YearMonth INT, @IdDetail INT
SET @IdAssociate = 2 		-- set associate value only for budget initial detail
SET @MaxRecords = 1000         	-- set maximum number of records
--insert budget revised values
--SET IDENTITY_INSERT [INDEV3Work].[dbo].[BUDGET_REVISED] ON
INSERT INTO [INDEV3Work].[dbo].[BUDGET_REVISED]([IdProject], [IdGeneration], [IsValidated], [ValidationDate])
	VALUES(6, 1, 1, GETDATE())
INSERT INTO [INDEV3Work].[dbo].[BUDGET_REVISED]([IdProject], [IdGeneration], [IsValidated], [ValidationDate])
	VALUES(6, 2, 1, GETDATE())
INSERT INTO [INDEV3Work].[dbo].[BUDGET_REVISED]([IdProject], [IdGeneration], [IsValidated], [ValidationDate])
	VALUES(6, 3, 0, GETDATE())
--SET IDENTITY_INSERT [INDEV3Work].[dbo].[BUDGET_REVISED] OFF

--generate revised detail
WHILE @MaxRecords >0
BEGIN
	SET @IdProject = 6
	SET @IdGeneration = ROUND(1+(2*RAND()),0)
	SET @IdWP = ROUND(10+(6*RAND()),0)
	SET @IdPhase = (SELECT IdPhase FROM WORK_PACKAGES AS WP
		WHERE WP.IdProject = @IdProject AND WP.[Id] = @IdWP) 
	SET @IdCC = ROUND(3+(3*RAND()),0)
	SET @YearMonth = (100*ROUND(2000+(1*RAND()),0))+ROUND(1+(11*RAND()),0)
	SELECT @IdDetail = ISNULL(Max(IdDetail)+1,1) FROM [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL]
	PRINT CONVERT(VARCHAR(3),@IdProject) +  ', ' + CONVERT(VARCHAR(3),@IdGeneration)
		+  ', ' + CONVERT(VARCHAR(5),@IdWP) +  ', ' + CONVERT(VARCHAR(5),@IdPhase)
		+  ', ' + CONVERT(VARCHAR(5),@IdCC) +  ', ' + CONVERT(VARCHAR(6),@YearMonth)
		+  ', ' + CONVERT(VARCHAR(5),@IdDetail)
	IF NOT EXISTS (SELECT * FROM [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL] AS BRD
		WHERE BRD.IdProject = @IdProject AND BRD.IdGeneration = @IdGeneration AND BRD.IdPhase = @IdPhase AND BRD.IdWorkPackage = @IdWP
			AND BRD.IdCostCenter = @IdCC AND BRD.IdAssociate = @IdAssociate AND BRD.YearMonth = @YearMonth)
	BEGIN
		SET IDENTITY_INSERT [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL] ON
		INSERT INTO [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL]
			([IdProject], [Idgeneration] ,[IdPhase], [IdWorkPackage], [IdCostCenter], [IdAssociate], [YearMonth],[IdDetail], [HoursQty], [HoursVal], [SalesVal])
	        	VALUES(@IdProject,@IdGeneration ,@IdPhase ,@IdWP ,@IdCC , @IdAssociate, @YearMonth, @IdDetail,round(1+50*RAND(),0), round(1+50*RAND(),0), 50000000*RAND())
		SET IDENTITY_INSERT [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL] OFF

		INSERT INTO [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL_COSTS]
			([IdDetail], [IdCostType], [CostVal]) VALUES(@IdDetail, 1,  50000000*RAND())
		INSERT INTO [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL_COSTS]
			([IdDetail], [IdCostType], [CostVal]) VALUES(@IdDetail, 2,  50000000*RAND())
		INSERT INTO [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL_COSTS]
			([IdDetail], [IdCostType], [CostVal]) VALUES(@IdDetail, 3,  50000000*RAND())
		INSERT INTO [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL_COSTS]
			([IdDetail], [IdCostType], [CostVal]) VALUES(@IdDetail, 4,  50000000*RAND())
		INSERT INTO [INDEV3Work].[dbo].[BUDGET_REVISED_DETAIL_COSTS]
			([IdDetail], [IdCostType], [CostVal]) VALUES(@IdDetail, 5,  50000000*RAND())

	END
    SET @MaxRecords = @MaxRecords - 1
END
GO


--insert hourly rates
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200009, 2, 9)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200009, 2, 12)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200009, 2, 6)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200010, 2, 10)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200010, 2, 11)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200010, 2, 7)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200011, 2, 11)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200011, 2, 10)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200011, 2, 8)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200012, 2, 12)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200012, 2, 9)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200012, 2, 9)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200101, 2, 13)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200101, 2, 8)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200101, 2, 10)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200102, 2, 14)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200102, 2, 7)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200102, 2, 11)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200103, 2, 15)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200103, 2, 6)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200103, 2, 12)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200104, 2, 14)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200104, 2, 5)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200104, 2, 13)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200105, 2, 13)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200105, 2, 4)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200105, 2, 14)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200106, 2, 12)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200106, 2, 3)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200106, 2, 15)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200107, 2, 11)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200107, 2, 2)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200107, 2, 14)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200108, 2, 10)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200108, 2, 1)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200108, 2, 13)

INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(4, 200109, 2, 9)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(5, 200109, 2, 2)
INSERT INTO [INDEV3Work].[dbo].[HOURLY_RATES]([IdCostCenter], [YearMonth], [IdCurrency], [HourlyRate])
	VALUES(6, 200109, 2, 12)

