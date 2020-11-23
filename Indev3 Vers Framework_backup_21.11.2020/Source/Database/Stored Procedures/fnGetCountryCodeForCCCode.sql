--Drops the Function fnGetCountryCodeFromCostCenter if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetCountryCodeFromCostCenter]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetCountryCodeFromCostCenter]
GO

--select dbo.fnGetCountryCodeFromCostCenter(3)
CREATE   FUNCTION fnGetCountryCodeFromCostCenter
(
	@CCId int
)	
RETURNS varchar(3)
AS
BEGIN
	DECLARE @CountryCode varchar(3)
	
	SELECT @CountryCode = C.Code 
	FROM COST_CENTERS CC 
	INNER JOIN INERGY_LOCATIONS IL 
	        ON CC.IdInergyLocation = IL.ID 
	INNER JOIN COUNTRIES C 
		ON IL.IdCountry = C.Id     
	WHERE CC.Id = @CCId

	RETURN @CountryCode
END
GO
