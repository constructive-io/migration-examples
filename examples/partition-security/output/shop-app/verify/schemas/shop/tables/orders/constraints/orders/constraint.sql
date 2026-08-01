-- Verify: schemas/shop/tables/orders/constraints/orders/constraint


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'orders' AND constraint_name = 'orders_customer_id_fkey' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relname = 'orders' AND n.nspname = 'shop' AND c.relrowsecurity) THEN 1 ELSE 0 END);


