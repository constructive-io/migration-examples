-- Verify: schemas/shop/tables/orders/table


SELECT 1/(CASE WHEN to_regclass('shop.orders') IS NOT NULL THEN 1 ELSE 0 END);


