--Drops the Procedure bgtAssociateHasCurrentData if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[bgtAssociateHasCurrentData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[bgtAssociateHasCurrentData]
GO
create procedure [dbo].[bgtAssociateHasCurrentData]
@IdAssociate int

as

if exists(
	select IdAssociate from ACTUAL_DATA_DETAILS_HOURS where IdAssociate=@IdAssociate
	union
	select IdAssociate from ACTUAL_DATA_DETAILS_COSTS where IdAssociate=@IdAssociate
	union
	select IdAssociate from ACTUAL_DATA_DETAILS_SALES where IdAssociate=@IdAssociate
)
	select 1
else
	select 0


GO


