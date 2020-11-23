	--Inserts all the error messages into schema
	
	INSERT INTO ERROR_MESSAGES (Code,IdLanguage,Message) 
	VALUES				('DUPLICATE_LOGIC_KEY_1',1,'There is already an entity that has the same field(s) (%s) as the one you want to insert in this catalogue.')
	
	INSERT INTO ERROR_MESSAGES (Code,IdLanguage,Message) 
	VALUES				('VALIDATION_DATA_TYPE_1',1,'The field %s has not the correct data type')
	
	INSERT INTO ERROR_MESSAGES (Code,IdLanguage,Message) 
	VALUES				('VERIFY_MANDATORY_COLUMN_0',1,'Not all the mandatory columns have been filled in.')

	INSERT INTO ERROR_MESSAGES (Code,IdLanguage,Message) 
	VALUES				('DELETE_MANDATORY_COLUMN_2',1,'%s cannot be deleted because it is used in %s catalog')

	INSERT INTO ERROR_MESSAGES (Code,IdLanguage,Message) 
	VALUES				('DUPLICATE_COST_CENTER_1',1,'The Cost Center %s is already added to Work Package %s.')

	INSERT INTO ERROR_MESSAGES (Code,IdLanguage,Message) 
	VALUES				('DUPLICATE_ACTUAL_DETAILS',1,'The file %s is already processed.')

GO

