-- Verify: schemas/shop/tables/products/columns/sku/column


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'sku' AND table_schema = 'shop') THEN 1 ELSE 0 END);


