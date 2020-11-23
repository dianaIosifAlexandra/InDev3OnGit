
	--This script inserts into scema all the Roles
	--***************************************************************************************************
	--*****ATTENTION!!! This is an artificial initialization, to be able to insert Associates  **********
	--*****(which are also in this case users). In Delivery this script should be changed.	   **********
	--***************************************************************************************************

	INSERT INTO ROLES	([Id], [Name])
	VALUES			(1,'Business Administrator')
	INSERT INTO ROLES	([Id], [Name])
	VALUES			(2,'Technical Administrator')
	INSERT INTO ROLES	([Id], [Name])
	VALUES			(3,'Financial Team')
	INSERT INTO ROLES	([Id], [Name])
	VALUES			(4,'Program Manager')
	INSERT INTO ROLES	([Id], [Name])
	VALUES			(5,'Core Team Member')
	INSERT INTO ROLES	([Id], [Name])
	VALUES			(6,'Functional Manager')
	INSERT INTO ROLES	([Id], [Name])
	VALUES			(7,'Program Reader')
GO

