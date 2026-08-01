-- Verify: schemas/shop/tables/orders/table/grants/app_user


SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.orders', 'SELECT') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.orders', 'INSERT') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.orders', 'UPDATE') THEN 1 ELSE 0 END);


