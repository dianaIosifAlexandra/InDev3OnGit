--Drops the Procedure catDeleteCustomerSite if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteCustomerSite]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteCustomerSite
GO
CREATE PROCEDURE catDeleteCustomerSite
	@Id AS INT 	--The Id of the selected Customer Site
AS
DECLARE @RowCount INT

	DELETE FROM CUSTOMER_SITES
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

