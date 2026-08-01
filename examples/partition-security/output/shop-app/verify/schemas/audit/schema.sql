-- Verify: schemas/audit/schema


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'audit') THEN 1 ELSE 0 END);


