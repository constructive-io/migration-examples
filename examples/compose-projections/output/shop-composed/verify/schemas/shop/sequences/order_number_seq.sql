-- Verify: schemas/shop/sequences/order_number_seq


SELECT 1/(CASE WHEN to_regclass('shop.order_number_seq') IS NOT NULL THEN 1 ELSE 0 END);


