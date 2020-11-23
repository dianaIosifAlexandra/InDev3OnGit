--Drops the Function fnGetNullAssociateId if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetNullAssociateId]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetNullAssociateId]
GO
CREATE   FUNCTION fnGetNullAssociateId
	(@CountryCode	VARCHAR(3))

RETURNS INT
AS
BEGIN
	DECLARE @NullAssociateId int

	SELECT @NullAssociateId = A.Id
	FROM ASSOCIATES A
	INNER JOIN COUNTRIES C
		ON A.IdCountry = C.Id
	WHERE C.Code = @CountryCode
	AND UPPER(A.InergyLogin) = UPPER(@CountryCode) + '\NULL'
	
	RETURN @NullAssociateId
END
GO
 