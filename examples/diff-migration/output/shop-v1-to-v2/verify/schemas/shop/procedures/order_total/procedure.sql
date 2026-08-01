-- Verify: schemas/shop/procedures/order_total/procedure


SELECT 1 / (CASE WHEN to_regprocedure('shop.order_total(uuid)') IS NOT NULL THEN 1 ELSE 0 END);


