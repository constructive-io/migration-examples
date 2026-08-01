-- Verify: schemas/shop/tables/product_reviews/table


SELECT 1 / (CASE WHEN to_regclass('shop.product_reviews') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1 / (CASE WHEN has_table_privilege('app_user', 'shop.product_reviews', 'SELECT') THEN 1 ELSE 0 END);

SELECT 1 / (CASE WHEN has_table_privilege('app_user', 'shop.product_reviews', 'INSERT') THEN 1 ELSE 0 END);

SELECT 1 / (CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'product_reviews' AND constraint_name = 'product_reviews_product_id_fkey' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1 / (CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'product_reviews' AND constraint_name = 'product_reviews_customer_id_fkey' AND table_schema = 'shop') THEN 1 ELSE 0 END);


