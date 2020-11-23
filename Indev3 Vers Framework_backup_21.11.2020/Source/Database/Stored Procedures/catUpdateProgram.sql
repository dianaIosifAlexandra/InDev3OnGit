--Drops the Procedure catUpdateProgram if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateProgram]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateProgram
GO
CREATE PROCEDURE catUpdateProgram
	@Id		INT,		--The Id of the selected Program
	@IdOwner	INT,		--The Id of the Owner that is connected to the Program you want to insert
	@Code		VARCHAR(10),	--The Code of the Program you want to Insert
 	@Name		VARCHAR(50),	--The Name of the Program you want to Insert
	@IsActive	BIT,		--Shows if the Program is Active or not
	@Rank		INT
	
AS
DECLARE @Rowcount 		INT,
	@ValidateLogicKey	BIT,
	@ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)

	DECLARE @RetVal INT

	--If the active flag is set to false, check if there are any active projects for this program. In this case
	--throw error
	IF (@IsActive = 0)
	BEGIN
		DECLARE @NoProjects INT
		SELECT 
			@NoProjects = COUNT([Id]) 
		FROM PROJECTS 
		WHERE IsActive = 1 AND IdProgram = @Id
		IF (@NoProjects > 0)
		BEGIN
			RAISERROR('Could not set program to inactive because it has %d active projects dependencies',16,1,@NoProjects)
			RETURN -1
		END
	END
	
	SET @LogicalKey = 'Code'

	IF EXISTS( SELECT *
		FROM PROGRAMS AS P(nolock)
		WHERE 	P.Code = @Code AND
			P.Id <> @Id) 
	BEGIN
		EXEC   auxSelectErrorMessage_1 @Code = 'DUPLICATE_LOGIC_KEY_1',@IdLanguage = 1,@Parameter1 = @LogicalKey, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1
	END


	IF(@IdOwner IS NULL OR 
	   @Code IS NULL OR 
	   @Name IS NULL OR 
	   @IsActive IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -3	
	END

	exec @RetVal = catUpdateCatalogRank 'PROGRAMS', @Rank,2, @Id

	IF(@@ERROR<>0 OR @RetVal < 0)
		return -3

	UPDATE PROGRAMS 	
	SET Code = @Code,
	    [Name] = @Name,
	    IdOwner = @IdOwner,
	    IsActive = @IsActive,
	    [Rank] = @Rank
	WHERE [Id] = @Id

	SET @Rowcount = @@ROWCOUNT
	RETURN @Rowcount
GO

