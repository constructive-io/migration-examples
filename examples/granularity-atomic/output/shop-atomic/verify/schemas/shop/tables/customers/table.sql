-- Verify: schemas/shop/tables/customers/table


SELECT 1/(CASE WHEN to_regclass('shop.customers') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'customers' AND column_name = 'id' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'customers' AND column_name = 'email' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'customers' AND column_name = 'full_name' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'customers' AND column_name = 'phone' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'customers' AND column_name = 'created_at' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'customers' AND constraint_name = 'customers_pkey' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'customers' AND constraint_name = 'customers_email_key' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.customers', 'SELECT') THEN 1 ELSE 0 END);


