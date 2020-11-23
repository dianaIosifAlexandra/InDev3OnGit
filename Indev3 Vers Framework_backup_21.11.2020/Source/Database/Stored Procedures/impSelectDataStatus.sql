--Drops the Procedure impSelectDataStatus if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impSelectDataStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impSelectDataStatus
GO
CREATE PROCEDURE impSelectDataStatus
	@Year	AS	INT
AS
	SELECT 				  0 as IdImport,
						  IMS.SourceName 	AS	'Country',
					  	  0 AS  'January',
					  	  0 AS  'February',
					  	  0 AS  'March',
					  	  0 AS  'April',
					  	  0 AS  'May',
					  	  0 AS  'June',
					  	  0 AS  'July',
					  	  0 AS  'August',
					  	  0 AS  'September',
					  	  0 AS  'October',
					  	  0 AS  'November',
					  	  0 AS  'December',
			IMS.Rank AS Rank
	INTO #DataLogs
	FROM IMPORT_SOURCES IMS
	WHERE Active = 1 or (Active = 0 and @Year < DiscontinuationYear)


	UPDATE a
	SET 
		January = 1, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 1 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName 
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)

	UPDATE a
	SET 
		February = 1, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 2 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName 
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)

	UPDATE a
	SET 
		March = 1, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 3 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName 
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)


	UPDATE a
	SET 
		April = 1, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 4 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName 
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)

	UPDATE a
	SET 
		May = 1, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 5 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName 
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)


	UPDATE a
	SET 
		June = 1, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 6 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName 
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)


	UPDATE a
	SET 
		July = 1, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 7 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName 
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)


	UPDATE a
	SET 
		August = 1, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 8 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName 
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)


	UPDATE a
	SET 
		September = 1, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 9 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName  
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)


	UPDATE a
	SET 
		October = 1, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 10 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName  
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)


	UPDATE a
	SET 
		November = 11, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 11 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName  
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)

	UPDATE a
	SET 
		December = 12, IdImport = IL.IdImport
	from #DataLogs a
	join IMPORT_LOGS IL on IL.YearMonth / 100 = @Year AND IL.YearMonth % 100 = 12 AND IL.Validation = 'G'
	INNER JOIN IMPORT_SOURCES AS IMS ON IMS.Id = IL.IdSource
	where a.Country = IMS.SourceName  
	--and not exists(select IdImport from IMPORT_LOGS x INNER JOIN IMPORT_SOURCES y ON y.Id = x.IdSource where YearMonth / 100 > @Year and Validation = 'G' and  y.SourceName = a.Country)

	SELECT IdImport,
		   Country,
		   January,
		   February,
		   March,
		   April,
		   May,
		   June,
		   July,
		   August,
		   September,
		   October,
		   November,
		   December
	FROM #DataLogs
	ORDER BY Rank

GO