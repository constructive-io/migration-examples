-- Verify: module/init


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_schema_privilege('app_user', 'shop', 'USAGE') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'audit') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN to_regclass('shop.order_number_seq') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN to_regclass('shop.customers') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.customers', 'SELECT') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN to_regclass('shop.products') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.products', 'SELECT') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN to_regclass('shop.orders') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relname = 'orders' AND n.nspname = 'shop' AND c.relrowsecurity) THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.orders', 'SELECT') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.orders', 'INSERT') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.orders', 'UPDATE') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN to_regclass('shop.order_items') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.order_items', 'SELECT') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.order_items', 'INSERT') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN to_regclass('audit.change_log') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN to_regprocedure('shop.order_total(uuid)') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN to_regprocedure('audit.log_order_change()') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN to_regclass('shop.idx_orders_customer_id') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN to_regclass('shop.idx_orders_placed_at') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN to_regclass('shop.idx_order_items_order_id') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'orders_audit_trigger' AND tgrelid = 'shop.orders'::regclass AND NOT tgisinternal) THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'orders_select_own' AND tablename = 'orders' AND schemaname = 'shop') THEN 1 ELSE 0 END);


