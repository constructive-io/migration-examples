-- Verify: schemas/shop/tables/product_reviews/columns/body/column


SELECT 1 / (CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'product_reviews' AND column_name = 'body' AND table_schema = 'shop') THEN 1 ELSE 0 END);


