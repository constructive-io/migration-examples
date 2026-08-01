-- Verify: schemas/shop/schema/grants/app_user


SELECT 1/(CASE WHEN has_schema_privilege('app_user', 'shop', 'USAGE') THEN 1 ELSE 0 END);


