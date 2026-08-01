-- Verify: schemas/shop/tables/products/constraints/products_pkey


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'products' AND constraint_name = 'products_pkey' AND table_schema = 'shop') THEN 1 ELSE 0 END);


