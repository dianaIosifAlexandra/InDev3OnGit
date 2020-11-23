--Drops the Procedure catSelectCostCenter if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectCostCenter]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectCostCenter
GO
CREATE PROCEDURE catSelectCostCenter
	@Id AS INT, 	--The Id of the selected Cost Center
	@IdInergyLocation AS INT --The Id of the selected Inergy Location
AS
	--If @Id has the value -1, it will return all Cost Centers
	SELECT 	
		
		IL.Name			AS 'InergyLocation',
		CC.Code			AS 'Code',
		CC.Name			AS 'Name',
		CC.IsActive		AS 'IsActive',
		D.Name			AS 'DepartmentName',
		F.Name			AS 'FunctionName',
		CC.Id			AS 'Id',	
		CC.IdInergyLocation	AS 'IdInergyLocation',	
		CC.IdDepartment		AS 'IdDepartment',
		F.Id			AS 'IdFunction'
	FROM COST_CENTERS AS CC(nolock)
	INNER JOIN INERGY_LOCATIONS AS IL(nolock)
		ON CC.IdInergyLocation = IL.[Id]
	INNER JOIN DEPARTMENTS AS D(nolock)
		ON CC.IdDepartment = D.[Id]
	INNER JOIN FUNCTIONS AS F(nolock)
		ON D.IdFunction = F.[Id]
	WHERE CC.Id = CASE @Id WHEN -1 THEN CC.Id ELSE @Id END
		AND CC.IdInergyLocation = CASE @IdInergyLocation WHEN -1 THEN CC.IdInergyLocation 
										ELSE @IdInergyLocation END
	ORDER BY CC.Name
GO

