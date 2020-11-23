--Drops the Procedure catUpdateAssociate if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateAssociate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateAssociate
GO
CREATE PROCEDURE catUpdateAssociate
	@Id			INT,		--The Id of the selected Associate
	@IdCountry		INT,		--The Id of the Country that is connected to the Associate you want to insert
 	@EmployeeNumber		VARCHAR(15),	--The Employee Number of the Associate you want to Insert
	@Name			VARCHAR(50),	--The Name of the Associate you want to Insert
	@InergyLogin		VARCHAR(50),	--The Inergy Login of the Associate you want to Insert
	@PercentageFullTime 	INT,		--The AvailabilityPercent of the Associate you want to Insert
	@IsActive		BIT,		--The IsActive of the Associate you want to Insert
	@IsSubContractor	BIT		--The IsSubContractor of the Associate you want to Insert
	
AS
DECLARE	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(50),
	@Rowcount		INT,
	@RetVal			INT
	
	SET @LogicalKey = 'Country, Employee Number'

	IF EXISTS( SELECT *
	FROM ASSOCIATES AS A
	WHERE 	A.EmployeeNumber = @EmployeeNumber AND
		A.IdCountry = @IdCountry AND 
		A.[Id] <> @Id) 
	SET @ValidateLogicKey = 1
	
	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END
	
	SET @LogicalKey = 'Inergy Login, Country'

	IF EXISTS( SELECT *
	FROM ASSOCIATES AS A (TABLOCKX)
	WHERE 	A.InergyLogin = @InergyLogin AND
		A.IdCountry = @IdCountry AND 
		A.[Id] <> @Id
	)
	SET @ValidateLogicKey = 1

	IF (@ValidateLogicKey = 1)
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END

	IF(@IdCountry IS NULL OR 
	   @EmployeeNumber IS NULL OR 
	   @Name IS NULL OR 
	   @InergyLogin IS NULL OR 
	   @PercentageFullTime IS NULL OR 
	   @IsActive IS NULL OR 
	   @IsSubContractor IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	--If the current associate is made from active to inactive, check whether he is active as a core team member on at least 1 project.
	--If this is true, an error will be raised
	DECLARE @OldIsActive BIT
	SELECT 	@OldIsActive = IsActive
	FROM 	ASSOCIATES
	WHERE 	[Id] = @Id

	IF (@OldIsActive = 1 AND @IsActive = 0)
	BEGIN
		IF EXISTS
		(
			SELECT 	IdAssociate
			FROM	PROJECT_CORE_TEAMS
			WHERE 	IdAssociate = @Id AND
				IsActive = 1
		)
		BEGIN
			RAISERROR('Cannot make this associate inactive because he/she is an active core team member on at least one project.', 16, 1)
			RETURN -3
		END
	END

	--If the current associate has data in any budget and the country is changed, raise an error
	DECLARE @OldIdCountry INT
	SELECT  @OldIdCountry = IdCountry
	FROM 	ASSOCIATES
	WHERE 	[Id] = @Id

	IF (@OldIdCountry <> @IdCountry)
	BEGIN
		EXEC @RetVal = catIsUserCountryChangeAllowed @IdAssociate = @Id
		IF (@@ERROR <> 0 OR @RetVal < 0)
			RETURN -4
	END

	
	UPDATE ASSOCIATES 	
	SET EmployeeNumber = @EmployeeNumber,
	    [Name] = @Name,
	    InergyLogin = @InergyLogin,
	    PercentageFullTime = @PercentageFullTime,
	    IsActive = @IsActive,
	    IsSubContractor = @IsSubContractor,
	    IdCountry = @IdCountry
	WHERE 	[Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

