--Drops the Procedure authIsAssociateTrainerImpersonatingOnProject if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authIsAssociateTrainerImpersonatingOnProject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authIsAssociateTrainerImpersonatingOnProject
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[authIsAssociateKeyUserImpersonatingOnProject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE authIsAssociateKeyUserImpersonatingOnProject
GO

create PROCEDURE [dbo].authIsAssociateKeyUserImpersonatingOnProject
	@IdProject 		AS INT,
	@IdAssociate       	AS INT,		
	@IdImpersonated		as int
AS	

declare @IdRole int
select @IdRole = IdRole from ASSOCIATE_ROLES where IdAssociate = @IdAssociate

if @IdRole = 8 and exists(select IdAssociate from PROJECT_CORE_TEAMS where IdProject = @IdProject and IdAssociate = @IdImpersonated)
   select 1
else
  select 0

return

Go