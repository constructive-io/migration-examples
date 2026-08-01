-- Verify: schemas/shop/tables/product_reviews/indexes/idx_product_reviews_product_id


SELECT 1 / (CASE WHEN to_regclass('shop.idx_product_reviews_product_id') IS NOT NULL THEN 1 ELSE 0 END);


