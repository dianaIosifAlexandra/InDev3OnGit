select distinct o.name, sum(i.rows) as SumRows from sysindexes i
join sysobjects o
on i.id=o.id
where o.xtype = 'U'
group by o.name

--de populat project_core_teams (1500 * 4 cu associates)
--de populat cost centere/departamente
--de populat exchange rates (500*4)
--de populat g/l accounts (500*4)
--de populat hourly rates (coscentere*12*4)
--de generat date pentru projects_interco si interco_layout bazate pe WP catalogue
--de populat user settings bazat pe associates

--------------oare ar trebui sa facem si asta?
--de populat import tables si actual data tables
--de populat budget table
