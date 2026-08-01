-- Verify: schemas/shop/tables/order_items/table


SELECT 1/(CASE WHEN to_regclass('shop.order_items') IS NOT NULL THEN 1 ELSE 0 END);


