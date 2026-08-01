-- Verify: schemas/shop/tables/customers/constraints/customers_email_key


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'customers' AND constraint_name = 'customers_email_key' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN has_table_privilege('app_user', 'shop.customers', 'SELECT') THEN 1 ELSE 0 END);


