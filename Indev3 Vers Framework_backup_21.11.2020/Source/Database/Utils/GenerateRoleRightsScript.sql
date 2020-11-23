SELECT 
	'INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (' + CAST(IdRole as VARCHAR(3)) + ', ''' + CodeModule + ''', ' + CAST(IdOperation AS VARCHAR(3)) + ', ' + CAST(IdPermission AS VARCHAR(3)) + ')' 
FROM ROLE_RIGHTS