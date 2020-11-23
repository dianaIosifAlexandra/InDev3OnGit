--Drops the Procedure catSelectProject if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectProject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectProject
GO
CREATE PROCEDURE catSelectProject
	@Id AS INT 	--The Id of the selected Project
AS
	DECLARE @HasActualData INT
	SET @HasActualData = 0
	
	IF @Id <> -1
		BEGIN
			-- Create 1st January of the current year
			declare @FirstJanuary datetime
			set @FirstJanuary = cast('1/1/' + cast(year(getdate()) as varchar(4)) as datetime)
			
			IF EXISTS(SELECT IdProject FROM ACTUAL_DATA WHERE IdProject = @Id and [Date] >= @FirstJanuary)
				SET @HasActualData = 1
		END
		
	--If @Id has the value -1, it will return all Projects
	SELECT 	
		P.Code 			AS 'Code',
		P.[Name]		AS 'Name',
		PR.[Code]		AS 'ProgramCode',
		PT.Type			AS 'ProjectType',
		P.IsActive		AS 'IsActive',
		(SELECT COUNT(IdAssociate) FROM PROJECT_CORE_TEAMS WHERE IsActive = 1 AND IdProject = CASE WHEN @Id=-1 THEN P.Id ELSE @Id END)
					AS 'ActiveMembers',
		dbo.fnGetPercentageWpWithTimingAndInterco(P.Id)	AS 'TimingIntercoPercent',
		ISNULL((SELECT IsValidated FROM BUDGET_INITIAL WHERE IdProject = CASE WHEN @Id=-1 THEN P.Id ELSE @Id END), 0) 
					AS 'IsInitialBudgetValidated',
		PR.[Name]		AS 'ProgramName',
		P.[Id]			AS 'Id',
		P.IdProgram		AS 'IdProgram',
		P.IdProjectType 	AS 'IdProjectType',
		@HasActualData	AS 'HasActualData'
	FROM PROJECTS P(nolock)
	INNER JOIN PROGRAMS PR(nolock)
		ON P.IdProgram = PR.[Id]
	INNER JOIN PROJECT_TYPES PT(nolock)
		ON P.IdProjectType = PT.[Id]
	WHERE P.Id = CASE WHEN @Id=-1 THEN P.Id ELSE @Id END
	ORDER BY P.Code
GO

