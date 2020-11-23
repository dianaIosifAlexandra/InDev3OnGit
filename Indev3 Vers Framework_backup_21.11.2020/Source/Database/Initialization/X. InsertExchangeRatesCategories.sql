
DELETE FROM EXCHANGE_RATE_CATEGORIES  

	--Inserts all the Exchange Rate Categories into schema

	INSERT INTO EXCHANGE_RATE_CATEGORIES ([Id],[Name], InFinanceCategoryId)
	VALUES			(1, 'Actual', 1)
	INSERT INTO EXCHANGE_RATE_CATEGORIES ([Id],[Name], InFinanceCategoryId)
	VALUES			(2, 'Budget', 2)
	INSERT INTO EXCHANGE_RATE_CATEGORIES ([Id],[Name], InFinanceCategoryId)
	VALUES			(3, 'Business Plan', 29)
GO

