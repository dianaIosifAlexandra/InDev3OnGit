if NOT EXISTS (SELECT * from PROJECT_FUNCTIONS where Name = 'CSAE')
BEGIN
	insert into PROJECT_FUNCTIONS
	values(9, 'CSAE', '51;52')

	alter table PROJECT_FUNCTIONS
	add Rank int NULL
	
	update PROJECT_FUNCTIONS
	set Rank = 1
	where Name = 'Program Manager'

	update PROJECT_FUNCTIONS
	set Rank = 2
	where Name = 'PAE'


	update PROJECT_FUNCTIONS
	set Rank = 3
	where Name = 'IE'


	update PROJECT_FUNCTIONS
	set Rank = 4
	where Name = 'QE'


	update PROJECT_FUNCTIONS
	set Rank = 5
	where Name = 'PB'


	update PROJECT_FUNCTIONS
	set Rank = 6
	where Name = 'CSAE'


	update PROJECT_FUNCTIONS
	set Rank = 7
	where Name = 'Sales'


	update PROJECT_FUNCTIONS
	set Rank = 8
	where Name = 'Program Assistant'


	update PROJECT_FUNCTIONS
	set Rank = 9
	where Name = 'Project Reader'

	ALTER TABLE PROJECT_FUNCTIONS ALTER COLUMN Rank INT NOT NULL
		
	select * from PROJECT_FUNCTIONS
END