-- Verify: schemas/shop/tables/products/columns/name


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'name' AND table_schema = 'shop') THEN 1 ELSE 0 END);


