
	--This script initializes one country
	--***************************************************************************************************
	--*****ATTENTION!!! This is an artificial initialization, to be able to insert Associates  **********
	--*****(which are also in this case users). In Delivery this script should be changed.	   **********
	--***************************************************************************************************

	INSERT INTO COUNTRIES 	([Id], Code, [Name], IdRegion, IdCurrency, Rank)
	VALUES			(1,   'C1' ,'TestCountry',1,	2, 1)
GO

