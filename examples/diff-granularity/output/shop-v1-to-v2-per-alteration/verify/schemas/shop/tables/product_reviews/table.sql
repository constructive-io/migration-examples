-- Verify: schemas/shop/tables/product_reviews/table


SELECT 1 / (CASE WHEN to_regclass('shop.product_reviews') IS NOT NULL THEN 1 ELSE 0 END);


