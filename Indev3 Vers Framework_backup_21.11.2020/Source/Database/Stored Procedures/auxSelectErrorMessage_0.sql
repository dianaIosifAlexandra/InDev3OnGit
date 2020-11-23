--Drops the Procedure auxSelectErrorMessage_0 if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[auxSelectErrorMessage_0]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE auxSelectErrorMessage_0
GO
CREATE PROCEDURE auxSelectErrorMessage_0
	@Code 		VARCHAR(50),		--The Code of the selected Error
	@IdLanguage	INT,			--The Language Id
	@Message	VARCHAR(200) OUTPUT	--The output message
AS
DECLARE	@Position	INT

	SELECT @Message = EM.Message 
	FROM	ERROR_MESSAGES AS EM
	WHERE EM.Code = @Code AND
	      EM.IdLanguage = @IdLanguage

	SELECT @Message
GO

