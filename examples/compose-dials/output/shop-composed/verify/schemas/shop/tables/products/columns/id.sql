-- Verify: schemas/shop/tables/products/columns/id


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'id' AND table_schema = 'shop') THEN 1 ELSE 0 END);


