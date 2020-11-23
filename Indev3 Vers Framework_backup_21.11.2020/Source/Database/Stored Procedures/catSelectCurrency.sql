--Drops the Procedure catSelectCurrency if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectCurrency]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectCurrency
GO
CREATE PROCEDURE catSelectCurrency
	@Id AS INT 	--The Id of the selected Currency
AS
	--If @Id has the value -1, it will return all Currency
	IF (@Id = -1)
	BEGIN 
		SELECT 	
			C.Code		AS 'Code',
			C.Name		AS 'Name',
			C.Id		AS 'Id'
		FROM CURRENCIES C(nolock)
	END

	--If @Id doesn't have the value -1 or -2 it will return the selected Currencies
	SELECT 	C.Id		AS 'Id',
		C.Code 		AS 'Code',
		C.Name		AS 'Name'
	FROM CURRENCIES C(nolock)
	WHERE C.Id = @Id
GO

