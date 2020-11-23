if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[catInsertWorkPackagesFromTemplate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[catInsertWorkPackagesFromTemplate]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE procedure catInsertWorkPackagesFromTemplate
	@IdProject int,
	@LastUserUpdate int 
as
declare @RetVal INT
Declare	@ErrorMessage		VARCHAR(255)

declare @IdPhase int
declare @Code varchar(3)
declare @Name varchar(30)
declare @Rank int
declare @IsActive bit
set @Rank = (select dbo.fnGetWorkPackageMaxRank())


declare WP_Template_Cursor CURSOR FAST_FORWARD FOR
select 
	IdPhase,
	Code, 
	[Name],
	IsActive
from WORK_PACKAGES_TEMPLATE
order by Rank
open WP_Template_Cursor
fetch next from WP_Template_Cursor
into @IdPhase, @Code, @Name, @IsActive
while @@fetch_status = 0
begin


	IF(@IdPhase IS NULL OR 
	   @Code IS NULL OR 
	   @Name IS NULL OR 
	   @Rank IS NULL OR 
	   @IsActive IS NULL)
	BEGIN 
		EXEC auxSelectErrorMessage_0 @Code = 'VERIFY_MANDATORY_COLUMN_0',@IdLanguage = 1, @Message = @ErrorMessage OUTPUT
		RAISERROR(@ErrorMessage,16,1)
		RETURN -1		
	END

	exec @RetVal =  catInsertWorkPackage 
			@IdPhase,
			@Code,
			@Name,
			@Rank,
			@IdProject,
			@IsActive,
			null,
			null,
			@LastUserUpdate	
			

	
	IF(@@ERROR<>0 OR @RetVal < 0)
	begin
		close WP_Template_Cursor
		deallocate WP_Template_Cursor
		return -2
	end	

	set @Rank = @Rank + 1


fetch next from WP_Template_Cursor
into @IdPhase, @Code, @Name, @IsActive
end
close WP_Template_Cursor
deallocate WP_Template_Cursor


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

