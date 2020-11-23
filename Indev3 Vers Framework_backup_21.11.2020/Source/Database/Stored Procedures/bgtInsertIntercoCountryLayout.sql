--Drops the Procedure bgtInsertIntercoCountryLayout if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtInsertIntercoCountryLayout]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtInsertIntercoCountryLayout
GO
CREATE PROCEDURE bgtInsertIntercoCountryLayout
	@IdProject INT,
	@IdCountry INT,
	@Position INT
AS
	IF NOT EXISTS
	(
		SELECT 	IdProject
		FROM 	PROJECTS_INTERCO_LAYOUT
		WHERE 	IdProject = @IdProject AND
			IdCountry = @IdCountry
	)
	BEGIN
		INSERT INTO PROJECTS_INTERCO_LAYOUT 
			(IdProject, IdCountry, Position)
		VALUES	(@IdProject, @IdCountry, @Position)
	END
	ELSE
	BEGIN
		UPDATE 	PROJECTS_INTERCO_LAYOUT
		SET 	Position = @Position
		WHERE 	IdProject = @IdProject AND
			IdCountry = @IdCountry
	END
GO

