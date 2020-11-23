IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetCurrencyFromCC]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetCurrencyFromCC]
GO

CREATE   FUNCTION fnGetCurrencyFromCC
(@IdCostCenter INT)
RETURNS
INT
AS
BEGIN

	DECLARE @IdCurrency INT
	SELECT @IdCurrency = C.IdCurrency
	FROM COST_CENTERS CC	
	INNER JOIN INERGY_LOCATIONS IL
		ON CC.IdInergyLocation = IL.Id
	INNER JOIN COUNTRIES C
		ON IL.IdCountry = C.Id
	where CC.Id = @IdCostCenter
	
	RETURN @IdCurrency

END

GO


