IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authIsAssociateKeyUserImpersonatingManagerOnProject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authIsAssociateKeyUserImpersonatingManagerOnProject
GO



create PROCEDURE [dbo].authIsAssociateKeyUserImpersonatingManagerOnProject
	
@IdProject AS INT,
	
@IdAssociate AS INT,		
	
@IdImpersonated as int

AS	

declare @IdRole int
select @IdRole = IdRole from ASSOCIATE_ROLES where IdAssociate = @IdAssociate

if @IdRole = 8 and exists(select IdAssociate from PROJECT_CORE_TEAMS where IdProject = @IdProject and IdAssociate = @IdImpersonated and IdFunction = 1)
   select 1
else
  select 0

return

Go
