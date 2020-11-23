--Drops the Procedure catSelectDepartment if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectDepartment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectDepartment
GO
CREATE PROCEDURE catSelectDepartment
	@Id AS INT 	--The Id of the selected Department
AS
	--If @Id has the value -1, it will return all Departments

IF @Id=-1
BEGIN
	SELECT 	
		D.Name		AS 'Name',
		F.Name		AS 'FunctionName',
		D.Rank		AS 'Rank',
		D.Id		AS 'Id',
		D.IdFunction	AS 'IdFunction'
	FROM DEPARTMENTS AS D(nolock)
	INNER JOIN [FUNCTIONS] AS F(nolock)
		ON D.IdFunction = F.Id
	ORDER BY D.Rank

END

IF @Id=-2
BEGIN
	SELECT 	
		CAST(NULL AS VARCHAR(30))		AS 'Name',
		CAST(NULL AS VARCHAR(30))		AS 'FunctionName',
		ISNULL(MAX(D.Rank),0)+1			AS 'Rank',
		CAST(NULL AS INT)			AS 'Id',
		CAST(NULL AS INT)			AS 'IdFunction'
	FROM DEPARTMENTS AS D(nolock)
	INNER JOIN [FUNCTIONS] AS F(nolock)
		ON D.IdFunction = F.Id
END

IF @Id>0
BEGIN
	SELECT 	
		D.Name		AS 'Name',
		F.Name		AS 'FunctionName',
		D.Rank		AS 'Rank',
		D.Id		AS 'Id',
		D.IdFunction	AS 'IdFunction'
	FROM DEPARTMENTS AS D(nolock)
	INNER JOIN [FUNCTIONS] AS F(nolock)
		ON D.IdFunction = F.Id
	WHERE D.Id = @Id
END
GO

