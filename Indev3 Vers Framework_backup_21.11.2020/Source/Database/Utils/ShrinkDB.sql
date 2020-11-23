
ALTER DATABASE INDev3Work
SET RECOVERY SIMPLE;

GO

-- Shrink the truncated log file to 1 MB.

DBCC SHRINKFILE (INDEV3_log, 1)
DBCC SHRINKFILE (INDEV3Work_1_log, 1)

GO

-- Reset the database recovery model.

ALTER DATABASE INDev3Work
SET RECOVERY FULL;

