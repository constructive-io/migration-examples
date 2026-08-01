-- Verify: schemas/shop/tables/orders/indexes/idx_orders_customer_id


SELECT 1/(CASE WHEN to_regclass('shop.idx_orders_customer_id') IS NOT NULL THEN 1 ELSE 0 END);


