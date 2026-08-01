-- Verify: schemas/shop/tables/orders/constraints/orders_customer_id_fkey


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'orders' AND constraint_name = 'orders_customer_id_fkey' AND table_schema = 'shop') THEN 1 ELSE 0 END);


