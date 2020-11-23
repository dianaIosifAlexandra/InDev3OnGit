--Drops the Procedure fltCostCenterFilterCostCenters if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fltCostCenterFilterCostCenters]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE fltCostCenterFilterCostCenters
GO
CREATE PROCEDURE fltCostCenterFilterCostCenters
	@IdCountry		INT,
	@IdInergyLocation	INT,
	@IdFunction		INT
AS
	SELECT DISTINCT CC.[Id]					AS 'Id',
			CC.[Name]				AS 'Name',
			CC.Code	+ ' - ' + CC.[Name]		AS 'Code',
			F.[Id]					AS 'IdFunction',
			F.Name					AS 'FunctionName',
			IL.[Id]					AS 'IdInergyLocation',
			IL.Name					AS 'InergyLocationName',
			C.[Id]					AS 'IdCountry'			
	FROM COST_CENTERS CC
	INNER JOIN DEPARTMENTS D
		ON CC.IdDepartment = D.[Id]
	INNER JOIN [FUNCTIONS] F
		ON D.IdFunction = F.[Id]
	INNER JOIN INERGY_LOCATIONS IL
		ON CC.IdInergyLocation = IL.[Id]
	INNER JOIN COUNTRIES C
		ON IL.IdCountry = C.[Id]
	WHERE 	IL.IdCountry = CASE WHEN @IdCountry = -1 THEN IL.IdCountry ELSE @IdCountry END AND
		CC.IdInergyLocation = CASE WHEN @IdInergyLocation = -1 THEN CC.IdInergyLocation ELSE @IdInergyLocation END AND
		D.IdFunction = CASE WHEN @IdFunction = -1 THEN D.IdFunction ELSE @IdFunction END AND
		CC.IsActive = 1
	ORDER BY Code

GO

