--Drops the Procedure auxSelectErrorMessage_1 if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[auxSelectErrorMessage_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE auxSelectErrorMessage_1
GO
CREATE PROCEDURE auxSelectErrorMessage_1
	@Code 		VARCHAR(50),		--The Code of the selected Error
	@IdLanguage	INT,			--The Language Id
	@Parameter1	VARCHAR(50),		--First parameter 
	@Message	VARCHAR(200) OUTPUT	--The output message
AS
DECLARE	@Position	INT

	SELECT @Message = EM.Message 
	FROM	ERROR_MESSAGES AS EM
	WHERE EM.Code = @Code AND
	      EM.IdLanguage = @IdLanguage

	SELECT @Position = CHARINDEX('%s',@Message,1)
	SELECT @Message = STUFF(@Message, @Position, 2, @Parameter1)

	SELECT @Message
GO

