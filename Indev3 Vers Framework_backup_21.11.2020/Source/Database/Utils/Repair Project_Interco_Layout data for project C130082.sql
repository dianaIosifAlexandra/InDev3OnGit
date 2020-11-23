if not exists(select * from PROJECTS_INTERCO_LAYOUT where IdProject = 2057 and IdCountry = 5)
insert into PROJECTS_INTERCO_LAYOUT
select 2057,5,1