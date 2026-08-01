-- Verify: schemas/shop/tables/customers/table/grants/app_user


SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.customers', 'SELECT') THEN 1 ELSE 0 END);


