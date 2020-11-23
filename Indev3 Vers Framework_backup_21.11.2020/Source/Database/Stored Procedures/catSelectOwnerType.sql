--Drops the Procedure catSelectOwnerType if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectOwnerType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectOwnerType
GO
CREATE PROCEDURE catSelectOwnerType
	@Id AS INT 	--The Id of the selected Function
AS
	--If @Id has the value -1, it will return all Owner Types
	IF (@Id = -1)
	BEGIN 
		SELECT 	
			OT.[Name]	AS 'Name',
			OT.[Id]		AS 'Id'
		FROM OWNER_TYPES OT(nolock)
	
		RETURN
	END

	--If @Id doesn't have the value -1 it will return the selected Owner Type
	SELECT 	OT.[Id]		AS 'Id',
		OT.[Name]	AS 'Name'
	FROM OWNER_TYPES OT(nolock)
	WHERE OT.[Id] = @Id
GO

