GO

	INSERT INTO MODULES 	([Code],[Name])
	VALUES			('EXT','Extract')

GO

	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (1, 'EXT', 1, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (1, 'EXT', 2, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (1, 'EXT', 3, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (1, 'EXT', 4, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (2, 'EXT', 1, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (2, 'EXT', 2, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (2, 'EXT', 3, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (2, 'EXT', 4, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (3, 'EXT', 1, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (3, 'EXT', 2, 3)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (3, 'EXT', 3, 3)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (3, 'EXT', 4, 3)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (4, 'EXT', 1, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (4, 'EXT', 2, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (4, 'EXT', 3, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (4, 'EXT', 4, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (5, 'EXT', 1, 2)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (5, 'EXT', 2, 3)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (5, 'EXT', 3, 3)
	INSERT INTO ROLE_RIGHTS (IdRole,CodeModule,IdOperation,IdPermission) VALUES (5, 'EXT', 4, 3)

GO


	BEGIN TRANSACTION
	DROP INDEX GL_ACCOUNTS.IX_GL_ACCOUNTS_1
	GO

	DROP INDEX GL_ACCOUNTS.IX_GL_ACCOUNTS
	GO
	
	ALTER TABLE dbo.GL_ACCOUNTS ADD CONSTRAINT
		UQ_GL_ACCOUNTS UNIQUE NONCLUSTERED 
		(
		IdCountry,
		Account
		) ON [PRIMARY]
	
	GO
	COMMIT

GO
