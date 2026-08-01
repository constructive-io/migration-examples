-- Verify: schemas/shop/tables/products/table/grants/app_user


SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.products', 'SELECT') THEN 1 ELSE 0 END);


