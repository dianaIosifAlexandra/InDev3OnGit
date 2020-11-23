IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnGetEuroId]'))
	DROP FUNCTION fnGetEuroId
GO

CREATE FUNCTION fnGetEuroId()
RETURNS INT
AS
BEGIN
	DECLARE @Id INT

	SELECT @Id=Id FROM Currencies 
	WHERE Code = 'EUR'

	RETURN @Id
END
GO

