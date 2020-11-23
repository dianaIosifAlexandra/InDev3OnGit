--Drops the Procedure bgtSelectProjectCoreTeam if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtSelectProjectCoreTeam]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE bgtSelectProjectCoreTeam
GO
CREATE PROCEDURE bgtSelectProjectCoreTeam
	@IdProject	AS INT,		--The Id of the Project that is connected to the selected Core Team Member
	@IdAssociate	AS INT		--The Id of the Associate that is connected to the selected Core Team Member
AS
	--If @Id has the value -1, it will return all Core Team Members, that have the specified Project
	IF (@IdProject < 0 )
	BEGIN 
		RAISERROR('No project has been selected',16,1)		
		RETURN -1
	END 

	IF( @IdAssociate = -1)
	BEGIN 
		SELECT 	
			A.[Name]	AS 'CoreTeamMemberName',
			A.EmployeeNumber as 'EmployeeNumber',
			PF.[Name]	AS 'FunctionName',
			C.[Name]   	AS 'Country',
			CTM.LastUpdate  AS 'LastUpdateDate',
			CTM.IsActive	AS 'IsActive',
			CTM.IdProject	AS 'IdProject',
			CTM.IdAssociate	AS 'IdAssociate',
			CTM.IdFunction	AS 'IdFunction',
			P.Name as 'ProjectName'
		FROM PROJECT_CORE_TEAMS AS CTM(nolock)
		INNER JOIN PROJECT_FUNCTIONS PF(nolock)
			ON CTM.IdFunction = PF.[Id]
		INNER JOIN ASSOCIATES A(nolock)
			ON CTM.IdAssociate = A.[Id]
		INNER JOIN PROJECTS P(nolock)
			ON CTM.IdProject = P.[Id]
		INNER JOIN COUNTRIES C (nolock)
			ON A.IdCountry  = C.Id
		WHERE CTM.IdProject = @IdProject
		ORDER BY PF.Rank

		RETURN
	END

	--If @Id does have the value different of -1 it will return the selected Core Team Member
	SELECT 	
		A.[Name]	AS 'CoreTeamMemberName',
		A.EmployeeNumber as 'EmployeeNumber',
		PF.[Name]	AS 'FunctionName',
		C.[Name]   	AS 'Country',
		CTM.LastUpdate  AS 'LastUpdateDate',
		CTM.IsActive	AS 'IsActive',
		CTM.IdProject	AS 'IdProject',
		CTM.IdAssociate	AS 'IdAssociate',
		CTM.IdFunction	AS 'IdFunction',
		P.Name as 'ProjectName'
	FROM PROJECT_CORE_TEAMS CTM(nolock)
		INNER JOIN PROJECT_FUNCTIONS PF(nolock)
	ON CTM.IdFunction = PF.[Id]
		INNER JOIN ASSOCIATES A(nolock)
	ON CTM.IdAssociate = A.[Id]
		INNER JOIN PROJECTS P(nolock)
	ON CTM.IdProject = P.[Id]
		INNER JOIN COUNTRIES C (nolock)
	ON A.IdCountry  = C.Id
	WHERE 	CTM.IdProject = @IdProject AND 
		CTM.IdAssociate = @IdAssociate
	ORDER BY PF.Rank

GO

