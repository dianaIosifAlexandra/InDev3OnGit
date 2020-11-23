IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnGetWeightedAveragePercent]'))
	DROP FUNCTION fnGetWeightedAveragePercent
GO

CREATE FUNCTION fnGetWeightedAveragePercent
	 (@IdProject 		int, 
	 @IdGeneration 		int, 
	 @IdPhase			int, 
	 @IdWorkPackage		int, 
	 @IdAssociate		int)
RETURNS decimal (18,2)
AS
BEGIN
	declare @PercentWeighted	decimal(18,2)

	declare @ProgressTemp table
	( 	
		IdProject			int not null, 
		IdGeneration		int not null, 
		IdPhase				int not null, 
		IdWorkPackage		int not null, 
		IdAssociate			int not null,
		HoursQty			decimal(18,2) null,
		[Percent]			decimal(18,2) null,
		Product				decimal(18,2) null, -- HoursQty * Percent --because of a technical limitation in functions
		PRIMARY KEY (IdProject, IdGeneration, IdPhase, IdWorkPackage, IdAssociate)
	)
	
	INSERT INTO @ProgressTemp
	SELECT IdProject, IdGeneration, IdPhase, IdWorkPackage, IdAssociate, SUM(HoursQty), NULL, NULL
	FROM BUDGET_TOCOMPLETION_DETAIL BTD
	WHERE BTD.IdProject = @IdProject and
		  BTD.IdGeneration = @IdGeneration and
		  BTD.IDPhase = @IdPhase and
		  BTD.IdWorkPackage = @IdWorkPackage and
		  BTD.IdAssociate = CASE WHEN @IdAssociate = -1 THEN BTD.IdAssociate ELSE @IdAssociate END
	GROUP BY IdProject, IdGeneration, IdPhase, IdWorkPackage, IdAssociate

	UPDATE pt 
	SET [Percent] = BTP.[Percent],
		Product = BTP.[Percent] * pt.HoursQty
	FROM @ProgressTemp pt
	INNER JOIN BUDGET_TOCOMPLETION_PROGRESS BTP
		on pt.IdProject = BTP.IdProject and
		   pt.IdGeneration = BTP.IdGeneration and
		   pt.IDPhase = BTP.IdPhase and
		   pt.IdWorkPackage = BTP.IdWorkPackage and
		   pt.IdAssociate = BTP.IdAssociate

	SELECT @PercentWeighted = CASE when SUM(PT.HoursQty) is null then null
								   when isnull(SUM(PT.HoursQty),0) = 0 then 0
								   else SUM(PT.[Product]) / SUM(PT.HoursQty) end
	FROM @ProgressTemp pt

	RETURN @PercentWeighted
END
GO

