DELETE FROM OLAP_CATEGORIES

INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (1, 'Actual', NULL)
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (2, 'Annual Budget', NULL)
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (3, 'Actual vs. Annual Budget', '[CategoryName].[Actual]-[CategoryName].[Annual Budget]')
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (4, 'Reforecast', NULL)
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (5, 'Reforecast vs. Annual Budget', '[CategoryName].[Reforecast]-[CategoryName].[Annual Budget]')
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (6, 'Actual -1', '(ParallelPeriod([Periods].[Year]), [CategoryName].[Actual])')
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (7, 'Actual vs Actual-1', '[CategoryName].[Actual]-(ParallelPeriod([Periods].[Year]), [CategoryName].[Actual])')
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (8, 'Reforecast vs. Actual -1', '[CategoryName].[Reforecast]-(ParallelPeriod([Periods].[Year]), [CategoryName].[Actual])')
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (9, 'Annual Budget vs. Actual -1', '[CategoryName].[Annual Budget]-(ParallelPeriod([Periods].[Year]), [CategoryName].[Actual])')
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (10, 'Initial Budget', NULL)
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (11, 'Revised Budget', NULL)
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (12, 'Initial vs. Revised', '[CategoryName].[Initial Budget]-[CategoryName].[Revised Budget]')
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (13, 'Gap', '[CategoryName].[Reforecast]-[CategoryName].[Revised Budget]')
INSERT INTO OLAP_CATEGORIES (Id, Name, Formula) VALUES (14, '%Progress', NULL)




