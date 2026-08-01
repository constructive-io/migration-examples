-- Verify: schemas/shop/tables/product_reviews/constraints/product_reviews_pkey/constraint


SELECT 1 / (CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'product_reviews' AND constraint_name = 'product_reviews_pkey' AND table_schema = 'shop') THEN 1 ELSE 0 END);


