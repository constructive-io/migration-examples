-- Verify: schemas/shop/tables/orders/constraints/orders_order_number_key


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'orders' AND constraint_name = 'orders_order_number_key' AND table_schema = 'shop') THEN 1 ELSE 0 END);


