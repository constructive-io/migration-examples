-- Verify: schemas/shop/tables/orders/constraints/orders_status_check/constraint


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'orders' AND constraint_name = 'orders_status_check' AND table_schema = 'shop') THEN 1 ELSE 0 END);


