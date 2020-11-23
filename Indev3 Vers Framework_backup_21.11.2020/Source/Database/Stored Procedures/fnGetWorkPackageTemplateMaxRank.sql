--Drops the Function fnGetWorkPackageTemplateMaxRank if it exists
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE ID= object_id(N'[dbo].[fnGetWorkPackageTemplateMaxRank]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[fnGetWorkPackageTemplateMaxRank]
GO
CREATE   FUNCTION fnGetWorkPackageTemplateMaxRank
()
RETURNS INT
AS
BEGIN

	DECLARE @Rank INT

	SELECT @Rank = ISNULL(MAX(WP.Rank),0)+1
	FROM WORK_PACKAGES_TEMPLATE WP

RETURN @Rank
END

GO		

