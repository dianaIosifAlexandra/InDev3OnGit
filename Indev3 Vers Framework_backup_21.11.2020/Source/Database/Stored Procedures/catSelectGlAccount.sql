--Drops the Procedure catSelectGlAccount if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectGlAccount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectGlAccount
GO
CREATE PROCEDURE catSelectGlAccount
	@Id 		AS INT, 	--The Id of the selected GlAccount
	@IdCountry	AS INT		--The Id of the Country associated to this GLAccount
AS
	--it will return the selected GlAccount(s)
	SELECT 	
		C.Name		AS 'CountryName',
		GL.Account	AS 'G/L Account',
		GL.Name		AS 'Name',
		CT.Name		AS 'CostType',
		GL.Id		AS 'Id',
		GL.IdCountry	AS 'IdCountry',
		GL.IdCostType	AS 'IdCostType'
	FROM GL_ACCOUNTS GL(nolock)
	INNER JOIN COUNTRIES C(nolock)
		ON GL.IdCountry = C.Id
	INNER JOIN COST_INCOME_TYPES  CT(nolock)
		ON GL.IdCostType = CT.Id
	WHERE 	GL.[Id] = CASE WHEN @Id = -1 THEN GL.Id ELSE @Id END AND 
		GL.IdCountry = CASE WHEN  @IdCountry = -1 THEN GL.IdCountry ELSE @IdCountry END
	ORDER BY C.Name, GL.Account
GO

