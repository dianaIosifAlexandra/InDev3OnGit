--Drops the Procedure catSelectAssociate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectAssociate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectAssociate
GO
CREATE PROCEDURE catSelectAssociate
	@Id 		AS INT, 	--The Id of the selected Associate
	@IdCountry	AS INT 		--The Id of the Country selected for this Associate
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
	WHERE 	A.Id = case when @Id=-1 then A.Id else @Id end AND
		A.IdCountry = case when @IdCountry=-1 then A.IdCountry else @IdCountry end AND
		ISNULL(C.IdRegion,0) <> 0 AND
		A.InergyLogin <> C.Code + '\null'
	ORDER BY C.Name, A.Name
GO
