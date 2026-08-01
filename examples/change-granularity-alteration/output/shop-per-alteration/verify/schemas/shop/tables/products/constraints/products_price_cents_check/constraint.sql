-- Verify: schemas/shop/tables/products/constraints/products_price_cents_check/constraint


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'products' AND constraint_name = 'products_price_cents_check' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.products', 'SELECT') THEN 1 ELSE 0 END);


