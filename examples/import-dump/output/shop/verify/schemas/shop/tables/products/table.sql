-- Verify: schemas/shop/tables/products/table


SELECT 1/(CASE WHEN to_regclass('shop.products') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.products', 'SELECT') THEN 1 ELSE 0 END);


