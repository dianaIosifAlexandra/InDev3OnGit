--Drops the Procedure impGetNonExistingAssociateNumbers if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[impGetNonExistingAssociateNumbers]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE impGetNonExistingAssociateNumbers
GO


CREATE     PROCEDURE impGetNonExistingAssociateNumbers	
	@IdImport INT			-- ID of the import
	
AS

IF @IdImport IS NULL
BEGIN
	RAISERROR('No id import',16,1)		
	RETURN -1
END


-- #################### TAKE ALL RECORDS FROM IMPORT DETAILS THAT HAVE NON VALID ASSOCIATE NUMBER CODES######
SELECT DISTINCT IMD.AssociateNumber, A.ID
FROM IMPORT_DETAILS IMD
INNER JOIN COUNTRIES C
	ON C.Code = IMD.Country
LEFT JOIN ASSOCIATES A
	ON A.IdCountry = C.Id AND
	A.EmployeeNumber = IMD.AssociateNumber
WHERE 	IdImport = @IdImport AND
	SUBSTRING(A.InergyLogin,1,7) = 'UPLOAD\' AND
	IMD.AssociateNumber IS NOT NULL AND
	RIGHT(A.InergyLogin,LEN(A.InergyLogin)-CHARINDEX('_',A.InergyLogin)) = CONVERT(VARCHAR(10), @IdImport)


GO

