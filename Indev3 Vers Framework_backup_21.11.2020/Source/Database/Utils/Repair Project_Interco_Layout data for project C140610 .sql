if not exists(select * from PROJECTS_INTERCO_LAYOUT where IdProject = 2248 and IdCountry = 2)
insert into PROJECTS_INTERCO_LAYOUT
select 2248,2,2
