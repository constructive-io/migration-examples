-- Verify: schemas/shop/tables/coupons/table


SELECT 1 / (CASE WHEN to_regclass('shop.coupons') IS NOT NULL THEN 1 ELSE 0 END);


