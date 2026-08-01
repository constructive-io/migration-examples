-- Verify: schemas/shop/tables/order_items/indexes/idx_order_items_order_id


SELECT 1/(CASE WHEN to_regclass('shop.idx_order_items_order_id') IS NOT NULL THEN 1 ELSE 0 END);


