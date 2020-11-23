--Drops the Procedure catUpdateRelatedTablesForWorkPackage if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateWPKeyReferences]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateWPKeyReferences
GO

CREATE PROCEDURE catUpdateWPKeyReferences	
	@IdProject	  INT,
	@IdPhase	  INT,
	@IdWorkPackageNew INT,
	@Id		  INT,
	@IdPhase_Original INT
	
AS

BEGIN
--INTERCO
		UPDATE PROJECTS_INTERCO
		SET IdWorkPackage 	= @IdWorkPackageNew,
		    IdPhase	  	= @IdPhase
		WHERE IdProject 	= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage 	= @Id

-- 		BUDGET INTIAL
-- 		INSERT NEW RECORD BECAUSE OF THE FOREIGN KEY MECHANISM
		INSERT INTO BUDGET_INITIAL_DETAIL
		SELECT 	IdProject, 
			@IdPhase, 
			@IdWorkPackageNew, 
			IdCostCenter, 
			IdAssociate, 
			YearMonth, 
			HoursQty, 
			HoursVal, 
			SalesVal, 
			IdCountry, 
			IdAccountHours,
			IdAccountSales
		FROM BUDGET_INITIAL_DETAIL
		WHERE IdProject 	= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage 	= @Id		

		UPDATE BUDGET_INITIAL_DETAIL_COSTS
		SET IdWorkPackage 	= @IdWorkPackageNew,
		    IdPhase		= @IdPhase
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id
-- 		AFTER UPDATES DELETE OLD RECORDS
		DELETE FROM BUDGET_INITIAL_DETAIL		
		WHERE IdProject 	= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage 	= @Id
	


-- 		BUDGET_REVISED
		INSERT INTO BUDGET_REVISED_DETAIL
		SELECT 	IdProject, 
			IdGeneration, 
			@IdPhase, 
			@IdWorkPackageNew, 
			IdCostCenter, 
			IdAssociate, 
			YearMonth, 
			HoursQty, 
			HoursVal, 
			SalesVal, 
			IdCountry, 
			IdAccountHours, 
			IdAccountSales 
		FROM BUDGET_REVISED_DETAIL
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id


		UPDATE BUDGET_REVISED_DETAIL_COSTS
		SET IdWorkPackage	= @IdWorkPackageNew,
		    IdPhase		= @IdPhase
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id

		DELETE FROM BUDGET_REVISED_DETAIL		
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id
		
-- 		BUDGET_TOCOMPLETION
		INSERT INTO BUDGET_TOCOMPLETION_PROGRESS
		SELECT 	IdProject, 
			IdGeneration, 
			@IdPhase, 
			@IdWorkPackageNew, 
			IdAssociate, 
			[Percent]
		FROM BUDGET_TOCOMPLETION_PROGRESS
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id


		INSERT INTO BUDGET_TOCOMPLETION_DETAIL
		SELECT 	IdProject, 
			IdGeneration, 
			@IdPhase, 
			@IdWorkPackageNew, 
			IdCostCenter, 
			IdAssociate, 
			YearMonth, 
			HoursQty, 
			HoursVal, 
			SalesVal, 
			IdCountry, 
			IdAccountHours, 
			IdAccountSales 
		FROM BUDGET_TOCOMPLETION_DETAIL
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id

		
		UPDATE BUDGET_TOCOMPLETION_DETAIL_COSTS
		SET IdWorkPackage	= @IdWorkPackageNew,
		    IdPhase		= @IdPhase
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id		


		DELETE FROM BUDGET_TOCOMPLETION_DETAIL		
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id
		
		DELETE FROM BUDGET_TOCOMPLETION_PROGRESS		
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id

-- 		ACTUAL_DATA
		
		UPDATE ACTUAL_DATA_DETAILS_HOURS
		SET IdWorkPackage	= @IdWorkPackageNew,
		    IdPhase		= @IdPhase
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id
		
		UPDATE ACTUAL_DATA_DETAILS_SALES
		SET IdWorkPackage	= @IdWorkPackageNew,
		    IdPhase		= @IdPhase
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id

		UPDATE ACTUAL_DATA_DETAILS_COSTS
		SET IdWorkPackage	= @IdWorkPackageNew,
		    IdPhase		= @IdPhase
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id


-- 		ANNUAL_DATA
		UPDATE ANNUAL_BUDGET_DATA_DETAILS_HOURS
		SET IdWorkPackage	= @IdWorkPackageNew,
		    IdPhase		= @IdPhase
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id

		UPDATE ANNUAL_BUDGET_DATA_DETAILS_SALES
		SET IdWorkPackage	= @IdWorkPackageNew,
		    IdPhase		= @IdPhase
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id

		UPDATE ANNUAL_BUDGET_DATA_DETAILS_COSTS
		SET IdWorkPackage	= @IdWorkPackageNew,
		    IdPhase		= @IdPhase
		WHERE IdProject		= @IdProject AND
		      IdPhase		= @IdPhase_Original AND
		      IdWorkPackage	= @Id
END


GO

