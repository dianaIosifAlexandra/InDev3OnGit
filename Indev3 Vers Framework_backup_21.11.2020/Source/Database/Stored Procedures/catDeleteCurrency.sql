--Drops the Procedure catDeleteCurrency if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteCurrency]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteCurrency
GO
CREATE PROCEDURE catDeleteCurrency
	@Id AS INT 	--The Id of the selected Currency
AS
DECLARE @Rowcount INT
	DELETE FROM CURRENCIES
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

