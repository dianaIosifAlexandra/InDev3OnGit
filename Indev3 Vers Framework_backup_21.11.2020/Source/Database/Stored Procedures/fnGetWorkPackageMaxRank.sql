--Drops the Function fnGetWorkPackageMaxRank if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetWorkPackageMaxRank]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetWorkPackageMaxRank]
GO
CREATE   FUNCTION fnGetWorkPackageMaxRank
()
RETURNS INT
AS
BEGIN

	DECLARE @Rank INT

	SELECT @Rank = ISNULL(MAX(WP.Rank),0)+1
	FROM WORK_PACKAGES WP

RETURN @Rank
END

GO		

