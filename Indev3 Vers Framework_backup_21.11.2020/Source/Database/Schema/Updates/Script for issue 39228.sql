IF NOT EXISTS (
		SELECT * 
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'PROJECT_FUNCTIONS' AND 
		      COLUMN_NAME = 'WPCodeSuffixes'
	       )
BEGIN
	ALTER TABLE dbo.PROJECT_FUNCTIONS 
		ADD WPCodeSuffixes varchar(29) NULL
END

GO

UPDATE dbo.PROJECT_FUNCTIONS
SET WPCodeSuffixes = 
	CASE
		WHEN Id IN (1, 7, 8)	THEN '01'
		WHEN Id = 2		THEN '21;22'
		WHEN Id = 3		THEN '31'	
		WHEN Id = 4		THEN '11'
		WHEN Id = 5		THEN '41'
		WHEN Id = 6		THEN '02'
	END
GO

ALTER TABLE dbo.PROJECT_FUNCTIONS 
	ALTER COLUMN WPCodeSuffixes varchar(29) NOT NULL
GO
