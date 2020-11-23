--Drops the Procedure catSelectCountry_InergyLocation if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectCountry_InergyLocation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectCountry_InergyLocation
GO
CREATE PROCEDURE catSelectCountry_InergyLocation
	@Id AS INT, 	--The Id of the  selected country
	@IdInergyLocation AS INT --The Id of the selected inergylocation
AS
	--If @Id has the value -1, it will return all Countries
	IF @IdInergyLocation = -1
		SELECT 	C.Id		AS 'Id',		
			C.Name		AS 'Name'		
		FROM COUNTRIES AS C(nolock)	
		LEFT JOIN INERGY_LOCATIONS IL
			ON C.ID = IL.IdCountry 
		WHERE C.Id =CASE @Id
					WHEN -1 THEN C.Id
					ELSE @Id
					END	
		GROUP BY C.Id, C.Name
		ORDER BY C.Name
	ELSE
		SELECT 	C.Id		AS 'Id',		
			C.Name		AS 'Name'		
		FROM COUNTRIES AS C(nolock)	
		LEFT JOIN INERGY_LOCATIONS IL
			ON C.ID = IL.IdCountry 
		WHERE ISNULL(IL.Id,0) =@IdInergyLocation
		GROUP BY C.Id, C.Name
		ORDER BY C.Name
GO
