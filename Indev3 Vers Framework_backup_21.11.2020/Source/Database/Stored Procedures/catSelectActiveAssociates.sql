--Drops the Procedure catSelectAssociate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectActiveAssociates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectActiveAssociates
GO
CREATE PROCEDURE catSelectActiveAssociates
	@IdCountry 	INT
AS
	SELECT 	
		C.Name			AS 'CountryName',
		A.EmployeeNumber	AS 'EmployeeNumber',
		A.Name			AS 'Name',
		A.InergyLogin		AS 'InergyLogin',
		A.IsActive		AS 'IsActive',
		A.PercentageFullTime 	AS 'PercentageFullTime',
		A.IsSubContractor 	AS 'IsSubContractor',
		A.Id			AS 'Id',
		A.IdCountry		AS 'IdCountry'
	FROM ASSOCIATES AS A(nolock)
	INNER JOIN COUNTRIES AS C(nolock)
		ON A.IdCountry = C.Id
	WHERE 	C.Id = CASE WHEN @IdCountry = -1 THEN C.Id ELSE @IdCountry END AND
		ISNULL(C.IdRegion,0) <> 0 AND
		A.IsActive = 1
	ORDER BY A.Name
GO
