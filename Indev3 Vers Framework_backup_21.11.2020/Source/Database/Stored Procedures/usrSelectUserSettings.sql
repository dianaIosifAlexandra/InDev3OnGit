--Drops the Procedure catUpdateCurrency if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[usrSelectUserSettings]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE usrSelectUserSettings
GO
CREATE PROCEDURE usrSelectUserSettings
(
	@AssociateId AS INT 	--The Id of the selected Asociate
)
AS
	SELECT 	[AssociateId]	AS 'AssociateId',
		[AmountScaleOption] AS 'AmountScaleOption',
		[NumberOfRecordsPerPage]	AS 'NumberOfRecordsPerPage',
		[CurrencyRepresentation]	AS 'CurrencyRepresentation'
	FROM USER_SETTINGS
	WHERE AssociateId = @AssociateId

GO

