-- Verify: schemas/shop/tables/order_items/table


SELECT 1/(CASE WHEN to_regclass('shop.order_items') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.order_items', 'SELECT') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.order_items', 'INSERT') THEN 1 ELSE 0 END);


