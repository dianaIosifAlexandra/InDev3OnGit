--Drops the Procedure [logInsertITrackingActivity]if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[logInsertITrackingActivity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE logInsertITrackingActivity
GO


create  PROCEDURE [dbo].[logInsertITrackingActivity]
@IdAssociate int,
@IdMemberImpersonated int,
@IdProjectFunctionImpersonated int,
@IdProject int,
@IdAction int,
@IdGeneration int
	
AS
declare @IdRole int
select @IdRole = IdRole from ASSOCIATE_ROLES where IdAssociate = @IdAssociate
declare @ProjectCode varchar(10)

BEGIN
	if @IdMemberImpersonated <= 0
	   set @IdMemberImpersonated = null
	
	if @IdProject <= 0
		begin
			set @IdProject = null
		end

	if @IdAction <= 0
	   set @IdAction = null

	if @IdGeneration <= 0
		set @IdGeneration = null

	if @IdProjectFunctionImpersonated <= 0
		set @IdProjectFunctionImpersonated = null


	INSERT INTO TRACKING_ACTIVITY_LOG 
		(IdAssociate, IdRole, IdMemberImpersonated, IdFunctionImpersonated,  IdProject, IdAction, IdGeneration, LogDate)
		VALUES	(@IdAssociate, @IdRole, @IdMemberImpersonated, @IdProjectFunctionImpersonated, @IdProject, @IdAction, @IdGeneration, GETDATE())
END

go