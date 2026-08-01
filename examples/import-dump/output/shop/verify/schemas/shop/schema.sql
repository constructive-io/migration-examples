-- Verify: schemas/shop/schema


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_schema_privilege('app_user', 'shop', 'USAGE') THEN 1 ELSE 0 END);


