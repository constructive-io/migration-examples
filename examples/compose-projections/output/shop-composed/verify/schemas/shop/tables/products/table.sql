-- Verify: schemas/shop/tables/products/table


SELECT 1/(CASE WHEN to_regclass('shop.products') IS NOT NULL THEN 1 ELSE 0 END);


