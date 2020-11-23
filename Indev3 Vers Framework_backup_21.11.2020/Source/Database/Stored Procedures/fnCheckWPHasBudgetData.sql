--Drops the Function fnCheckWPHasBudgetData if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnCheckWPHasBudgetData]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnCheckWPHasBudgetData]
GO
CREATE   FUNCTION fnCheckWPHasBudgetData
(	
	@IdProject	INT,
	@IdPhase	INT,
	@IdWP		INT
)
RETURNS  @ValidationTable table
(ValidationResult int, --has the value 0 if ok, negative value if not ok
 ErrorMessage     varchar(255) -- contains the string representing the error
) 
AS
BEGIN
	
	DECLARE @WPCode varchar(100),
	@errMessage varchar(255)
	
	
	IF EXISTS
	(
		SELECT TOP 1 IdWorkPackage 
		FROM BUDGET_INITIAL_DETAIL
		WHERE  	IdProject =@IdProject AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP
	)
	BEGIN
		SELECT @WPCode = CODE + ' - '+ Name
		FROM WORK_PACKAGES
		WHERE IdProject = @IDProject AND
		IdPhase = @IdPhase AND
		Id = @IdWP

		set @errMessage = REPLACE('WP Code: ''%d'' cannot be removed because has budget information. Please refresh your information.', '%d', @WPCode)
		INSERT INTO @ValidationTable
		VALUES (-1, @errMessage)
		RETURN
	END
	
	IF EXISTS
	(
		SELECT TOP 1 IdWorkPackage 
		FROM BUDGET_REVISED_DETAIL
		WHERE  IdProject = @IdProject AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP
	)
	BEGIN
		SELECT @WPCode = CODE + ' - '+ Name
		FROM WORK_PACKAGES
		WHERE IdProject = @IDProject AND
		IdPhase = @IdPhase AND
		Id = @IdWP

		set @errMessage = REPLACE('WP Code: ''%d'' cannot be removed because has budget information. Please refresh your information.', '%d', @WPCode)
		INSERT INTO @ValidationTable
		VALUES (-1, @errMessage)
		RETURN
	END
	
	IF EXISTS
	(
		SELECT TOP 1 IdWorkPackage 
		FROM BUDGET_TOCOMPLETION_DETAIL
		WHERE  IdProject = @IdProject AND
			IdPhase = @IdPhase AND
			IdWorkPackage = @IdWP
	)
	BEGIN
		SELECT @WPCode = CODE + ' - '+ Name
		FROM WORK_PACKAGES
		WHERE IdProject = @IDProject AND
		IdPhase = @IdPhase AND
		Id = @IdWP

		set @errMessage = REPLACE('WP Code: ''%d'' cannot be removed because has budget information. Please refresh your information.', '%d', @WPCode)
		INSERT INTO @ValidationTable
		VALUES (-1, @errMessage)
		RETURN
	END
	
	RETURN

END

GO

