-- Verify: schemas/shop/tables/products/constraints/products_sku_key/constraint


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'products' AND constraint_name = 'products_sku_key' AND table_schema = 'shop') THEN 1 ELSE 0 END);


