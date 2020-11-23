declare @IdProject int,
		@IdGeneration int
Select  @IdProject = -1,
		@IdGeneration = 2

select * from BUDGET_TOCOMPLETION
where IdProject = @IdProject and 
	  IdGeneration = @IdGeneration

select * from BUDGET_TOCOMPLETION_STATES
where IdProject = @IdProject and 
	  IdGeneration = @IdGeneration


Update BUDGET_TOCOMPLETION
set ValidationDate = null,
	YearMonthActualData = null,
	IsValidated = 0
where IdProject = @IdProject and IdGeneration = @IdGeneration

Update BUDGET_TOCOMPLETION_STATES
set State = 'W'
where IdProject = @IdProject and 
	  IdGeneration = @IdGeneration and 
	  State <> 'N'

select * from BUDGET_TOCOMPLETION
where IdProject = @IdProject and 
	  IdGeneration = @IdGeneration

select * from BUDGET_TOCOMPLETION_STATES
where IdProject = @IdProject and 
	  IdGeneration = @IdGeneration