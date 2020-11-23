--Drops the Procedure catDeleteProjectInterco if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteProjectInterco]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteProjectInterco
GO
CREATE PROCEDURE catDeleteProjectInterco
	@IdProject 	AS INT,		--The Id of the Project that corresponds to the current Project Interco 
	@IdPhase	AS INT,		--The Id of the Phase that corresponds to the current Project Interco 
	@IdWorkPackage	AS INT,		--The Id of the WorkPackage that corresponds to the current Project Interco 
	@IdCountry	AS INT		--The Id of the Country that corresponds to the current Project Interco 
AS
DECLARE @RowCount INT

	DELETE FROM PROJECTS_INTERCO
	WHERE 	IdProject = @IdProject AND 
		IdPhase = @IdPhase AND 
		IdWorkPackage = @IdWorkPackage AND
		IdCountry = @IdCountry 

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

