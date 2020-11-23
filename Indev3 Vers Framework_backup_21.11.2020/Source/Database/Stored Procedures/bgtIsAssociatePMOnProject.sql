--Drops the Procedure bgtIsAssociatePMOnProject if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtIsAssociatePMOnProject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtIsAssociatePMOnProject
GO

CREATE PROCEDURE bgtIsAssociatePMOnProject
	@IdProject 		AS INT,
	@IdAssociate       	AS INT		
AS	

SELECT dbo.fnIsAssociatePMOnProject(@IdProject, @IdAssociate) AS 'IsAssociatePMOnProject' 

GO


