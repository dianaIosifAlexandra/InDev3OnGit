--Drops the Procedure abgtSelectAnnualDataStatus if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[abgtSelectAnnualDataStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE abgtSelectAnnualDataStatus
GO
CREATE PROCEDURE [dbo].[abgtSelectAnnualDataStatus]
AS

	DECLARE @CurrentYear INT
	SET @CurrentYear= 2005
	
	DECLARE @Years TABLE  (
		[Year] INT
	)
	DECLARE @DataStatus table
	(
		IdCountry	INT,
		CountryCode	VARCHAR(3),
		Country		VARCHAR(30), 
		[Year]		INT,
		IsImport	BIT,
		IdImport	int
	)

	
	WHILE (@CurrentYear <= DATEPART(yyyy,GETDATE())+10)
	BEGIN
		INSERT INTO @Years ([Year]) VALUES (@CurrentYear)
	
		SET @CurrentYear = @CurrentYear + 1
	END
	
	INSERT INTO @DataStatus (IdCountry, CountryCode,Country, [Year],IsImport, IdImport)
	SELECT 
		C.[Id]		AS	IdCountry,
		C.Code		AS	CountryCode,
		C.[Name]	AS 	Country, 
		Y.[Year]	AS	[Year],
		0		AS	IsImport,
		0		as  IdImport
	
	FROM Countries AS C
	CROSS JOIN @Years AS Y
	WHERE C.IdRegion IS NOT NULL -- only inergy countries
	
	UPDATE DS
	SET DS.IsImport = 1, DS.IdImport =  case when not exists(select x.IdImport from ANNUAL_BUDGET_IMPORT_LOGS x INNER JOIN ANNUAL_BUDGET_IMPORTS y ON y.IdImport = x.IdImport where x.Validation='G' and x.Year > DS.Year and DS.CountryCode = SUBSTRING(y.[FileName],1,3)) then IL.IdImport else 0 end
	FROM @DataStatus DS
	INNER JOIN ANNUAL_BUDGET_IMPORT_LOGS  IL
		ON IL.[Year] = DS.[Year]
	INNER JOIN ANNUAL_BUDGET_IMPORTS AS  IMP 
		ON IL.IdImport = IMP.IdImport
	WHERE IL.Validation = 'G' AND	
	      DS.CountryCode = SUBSTRING(IMP.[FileName],1,3)


	SELECT 
		IdCountry	AS	IdCountry,
		Country		AS	Country,
		[Year]		AS	[Year],
		IdImport
	FROM @DataStatus WHERE IsImport = 1
	


	RETURN 1
GO