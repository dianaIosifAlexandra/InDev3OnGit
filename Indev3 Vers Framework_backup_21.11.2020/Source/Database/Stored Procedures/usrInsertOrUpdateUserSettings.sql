--Drops the Procedure catUpdateCurrency if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[usrInsertOrUpdateUserSettings]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE usrInsertOrUpdateUserSettings
GO
CREATE PROCEDURE usrInsertOrUpdateUserSettings
(
	@AssociateId	INT,		--The Id of the Associated User
	@AmountScaleOption INT,		--The Id of Enum Scale option you want to Insert
 	@NumberOfRecordsPerPage	INT,	--The Number of records an user wants to see on page
					-- you want to Insert
	@CurrencyRepresentation	INT	--the currency an user wants to see budget figures
)
AS
DECLARE @ErrorMessage		VARCHAR(200),
	@LogicalKey		VARCHAR(20)
	
	SET @LogicalKey = 'AssociateId'

	IF(@AssociateId IS NULL OR 
	   @AmountScaleOption IS NULL OR 
	   @NumberOfRecordsPerPage IS NULL OR 
	   @CurrencyRepresentation IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -2		
	END

	IF EXISTS( 
		SELECT *
		FROM USER_SETTINGS AS U
		WHERE 	U.AssociateId = @AssociateId
	)
	BEGIN 
		UPDATE USER_SETTINGS
		SET
			[AmountScaleOption] = @AmountScaleOption,
			[NumberOfRecordsPerPage] = @NumberOfRecordsPerPage,
			[CurrencyRepresentation] = @CurrencyRepresentation
		WHERE  [AssociateId] = @AssociateId
		
	END
	ELSE
	BEGIN
		INSERT INTO USER_SETTINGS	([AssociateId],[AmountScaleOption],[NumberOfRecordsPerPage],[CurrencyRepresentation])
			VALUES		     	(@AssociateId, @AmountScaleOption ,@NumberOfRecordsPerPage, @CurrencyRepresentation)
	END
GO
