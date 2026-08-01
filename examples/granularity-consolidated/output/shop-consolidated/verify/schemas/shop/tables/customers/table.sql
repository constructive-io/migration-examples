-- Verify: schemas/shop/tables/customers/table


SELECT 1/(CASE WHEN to_regclass('shop.customers') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.customers', 'SELECT') THEN 1 ELSE 0 END);


