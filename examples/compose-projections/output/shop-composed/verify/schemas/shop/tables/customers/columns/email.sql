-- Verify: schemas/shop/tables/customers/columns/email


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'customers' AND column_name = 'email' AND table_schema = 'shop') THEN 1 ELSE 0 END);


