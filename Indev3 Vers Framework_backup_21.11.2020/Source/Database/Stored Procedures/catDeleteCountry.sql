--Drops the Procedure catDeleteCountry if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catDeleteCountry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catDeleteCountry
GO
CREATE PROCEDURE catDeleteCountry
	@Id AS INT 	--The Id of the selected Country
	
AS
DECLARE @Rowcount 	INT,
	@CountDep 	INT,
	@ChildName	VARCHAR(50),
	@MasterName	VARCHAR(50),
	@ErrorMessage	VARCHAR(255)

	SET @MasterName = 'G/L Account'
	SET @ChildName	= 'Country'

	SELECT 	@CountDep = GA.IdCountry
	FROM GL_ACCOUNTS AS GA
	WHERE GA.IdCountry = @Id
	

	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	SET @MasterName = 'Inergy Location'

	SELECT 	@CountDep = IL.IdCountry
	FROM INERGY_LOCATIONS AS IL
	WHERE IL.IdCountry = @Id
	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2
	END

	SET @MasterName = 'Associate'

	DECLARE @CountryCode VARCHAR(3)
	SELECT 	@CountryCode = Code
	FROM 	COUNTRIES
	WHERE 	[Id] = @Id
	
	SELECT 	@CountDep = A.IdCountry
	FROM 	ASSOCIATES AS A
	WHERE 	A.IdCountry = @Id AND
		A.InergyLogin <> @CountryCode + '\null'
		
	
	IF (@CountDep > 0)
	BEGIN
		EXEC   auxSelectErrorMessage_2 @Code = 'DELETE_MANDATORY_COLUMN_2',@IdLanguage = 1,@Parameter1 = @ChildName,@Parameter2 = @MasterName, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -3
	END

	------------------------------------------------Delete the null associate of this country---------------------------------------------------
	DECLARE @NullIdAssociate INT
	SELECT 	@NullIdAssociate = [Id]
	FROM	ASSOCIATES
	WHERE	IdCountry = @Id AND
		InergyLogin = @CountryCode + '\null'

	DECLARE @RetVal INT
	EXEC @RetVal = catDeleteAssociate @NullIdAssociate, @Id

	IF (@@ERROR <> 0 OR @RetVal < 0)
		RETURN -4
	--------------------------------------------------------------------------------------------------------------------------------------------
	
	DECLARE @Rank INT
	SELECT @Rank = Rank from COUNTRIES WHERE [ID] = @Id	

	DELETE FROM COUNTRIES
	WHERE [Id] = @Id
	SET @Rowcount = @@ROWCOUNT

	exec catUpdateCatalogRank 'COUNTRIES', @Rank, 0, NULL

	RETURN @Rowcount
GO

