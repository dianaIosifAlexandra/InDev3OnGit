INSERT INTO PROJECT_FUNCTIONS ([Id],[Name]) 
VALUES		      (7,'Program Assistant')

-- fix for note 49360 point 2
UPDATE ROLE_RIGHTS
SET IdPermission = 1
WHERE CodeModule in ('CTC', 'HRA') and
	IdRole in (4,5) and
	IdOperation = 1

