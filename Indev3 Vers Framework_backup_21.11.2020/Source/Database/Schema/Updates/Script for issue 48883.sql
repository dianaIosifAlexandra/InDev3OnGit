-- Update Role Rights for Business Admin
update ROLE_RIGHTS
set IdPermission = 2
where IdRole=1 and CodeModule='INI'

update ROLE_RIGHTS
set IdPermission = 2
where IdRole=1 and CodeModule='REV'

update ROLE_RIGHTS
set IdPermission = 2
where IdRole=1 and CodeModule='REF'
