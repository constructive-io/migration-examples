-- Verify: schemas/shop/tables/products/columns/created_at/column


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'created_at' AND table_schema = 'shop') THEN 1 ELSE 0 END);


