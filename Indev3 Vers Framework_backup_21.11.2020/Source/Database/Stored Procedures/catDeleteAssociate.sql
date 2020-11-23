--Drops the Procedure catDeleteAssociate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteAssociate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteAssociate
GO
CREATE PROCEDURE catDeleteAssociate
	@Id 		AS INT, 	--The Id of the selected Associate
	@IdCountry	AS INT		--The IdCountry of the selected Associate
AS
DECLARE @Rowcount 	INT,
	@CountDep 	INT,
	@ChildName	VARCHAR(50),
	@MasterName	VARCHAR(50),
	@ErrorMessage	VARCHAR(255)

	SET @ChildName	= 'Associate'
	SET @MasterName = 'Work package'

	SELECT 	@CountDep = WP.LastUserUpdate
	FROM WORK_PACKAGES AS WP
	WHERE WP.LastUserUpdate = @Id
		
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	SET @MasterName = 'Project Core Team'
	SELECT 	@CountDep = PCT.IdAssociate
	FROM PROJECT_CORE_TEAMS AS PCT
	WHERE PCT.IdAssociate= @Id
		
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2
	END

	DECLARE @AssociateName VARCHAR(50)	

	SELECT 	@CountDep = AD.IdAssociate,
		@AssociateName = A.Name
	FROM ACTUAL_DATA_DETAILS_COSTS AS AD
	INNER JOIN ASSOCIATES A ON
		A.Id = AD.IdAssociate
	WHERE AD.IdAssociate= @Id
		
	IF (@CountDep > 0)
	BEGIN
		RAISERROR('Associate ''%s'' cannot be deleted because it is used in Actual Data.',16,1, @AssociateName)
		RETURN -3
	END

	SELECT 	@CountDep = AD.IdAssociate,
		@AssociateName = A.Name
	FROM ACTUAL_DATA_DETAILS_HOURS AS AD
	INNER JOIN ASSOCIATES A ON
		A.Id = AD.IdAssociate
	WHERE AD.IdAssociate= @Id
		
	IF (@CountDep > 0)
	BEGIN
		RAISERROR('Associate ''%s'' cannot be deleted because it is used in Actual Data.',16,1, @AssociateName)
		RETURN -3
	END

	SELECT 	@CountDep = AD.IdAssociate,
		@AssociateName = A.Name
	FROM ACTUAL_DATA_DETAILS_SALES AS AD
	INNER JOIN ASSOCIATES A ON
		A.Id = AD.IdAssociate
	WHERE AD.IdAssociate= @Id
		
	IF (@CountDep > 0)
	BEGIN
		RAISERROR('Associate ''%s'' cannot be deleted because it is used in Actual Data.',16,1, @AssociateName)
		RETURN -3
	END	

	SELECT 	@CountDep = I.IdAssociate,
		@AssociateName = A.Name
	FROM IMPORTS AS I
	INNER JOIN ASSOCIATES A ON
		A.Id = I.IdAssociate
	WHERE I.IdAssociate= @Id
		
	IF (@CountDep > 0)
	BEGIN
		RAISERROR('Associate ''%s'' cannot be deleted because it is used in Imports.',16,1, @AssociateName)
		RETURN -4
	END
	
	SELECT 	@CountDep = IBI.IdAssociate,
		@AssociateName = A.Name
	FROM IMPORT_BUDGET_INITIAL AS IBI
	INNER JOIN ASSOCIATES A ON
		A.Id = IBI.IdAssociate
	WHERE IBI.IdAssociate= @Id
		
	IF (@CountDep > 0)
	BEGIN
		RAISERROR('Associate ''%s'' cannot be deleted because it is used in Import Budget Initial.',16,1, @AssociateName)
		RETURN -5
	END


	SELECT 	@CountDep = IBR.IdAssociate,
		@AssociateName = A.Name
	FROM IMPORT_BUDGET_REVISED AS IBR
	INNER JOIN ASSOCIATES A ON
		A.Id = IBR.IdAssociate
	WHERE IBR.IdAssociate= @Id
		
	IF (@CountDep > 0)
	BEGIN
		RAISERROR('Associate ''%s'' cannot be deleted because it is used in Import Budget Revised.',16,1, @AssociateName)
		RETURN -7
	END

	SELECT 	@CountDep = ABI.IdAssociate,
		@AssociateName = A.Name
	FROM ANNUAL_BUDGET_IMPORTS AS ABI
	INNER JOIN ASSOCIATES A ON
		A.Id = ABI.IdAssociate
	WHERE ABI.IdAssociate= @Id
		
	IF (@CountDep > 0)
	BEGIN
		RAISERROR('Associate ''%s'' cannot be deleted because it is used in Annual Budget Imports.',16,1, @AssociateName)
		RETURN -6
	END

	-- we delete the associate role too
	DELETE FROM ASSOCIATE_ROLES
	WHERE IdAssociate = @Id

	-- added deletion of settings before the actual delete of the associate
	DELETE FROM USER_SETTINGS
	WHERE AssociateId = @Id	 

	DELETE FROM ASSOCIATES
	WHERE 	IdCountry = @IdCountry AND
		[Id] = @Id 


	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

