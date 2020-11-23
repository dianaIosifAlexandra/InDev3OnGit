--Drops the Procedure catDeleteWorkPackageTemplate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteWorkPackageTemplate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteWorkPackageTemplate
GO
CREATE PROCEDURE catDeleteWorkPackageTemplate
	@IdPhase	AS INT,	--The Id representing the Phase connected to the selected Work Package
	@Id 		AS INT 	--The Id of the selected Work Package
AS


DECLARE @Rowcount 	INT,
	@Rank INT

	SELECT @Rank = Rank from WORK_PACKAGES_TEMPLATE WHERE IdPhase = @IdPhase AND [ID] = @Id

	DELETE FROM WORK_PACKAGES_TEMPLATE
	WHERE 	IdPhase = @IdPhase AND
		[Id] = @Id
	SET @Rowcount = @@ROWCOUNT
	exec catUpdateWorkPackageTemplateRank 'WORK_PACKAGES_TEMPLATE', @Rank, 0, NULL, @IdPhase

	
	RETURN @Rowcount
GO

