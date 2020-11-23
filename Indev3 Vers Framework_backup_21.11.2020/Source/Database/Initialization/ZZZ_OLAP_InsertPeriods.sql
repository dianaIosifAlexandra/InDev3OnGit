INSERT INTO OLAP_PERIODS (YearMonthKey, Month, Year, MonthName)
SELECT 	Years.Year*100+Months.Month,
	Months.Month,
	Years.Year,
	Months.MonthName + ' ' + CAST(Years.Year AS Char(4))
FROM OLAP_YEARS Years
CROSS JOIN
OLAP_MONTHS Months
WHERE Year >= 2005 AND
Year <= Year(GETDATE())+2
ORDER BY Years.Year, Months.Month 