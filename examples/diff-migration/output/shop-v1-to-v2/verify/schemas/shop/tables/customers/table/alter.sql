-- Verify: schemas/shop/tables/customers/table/alter


SELECT 1 / (CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'customers' AND column_name = 'marketing_opt_in' AND table_schema = 'shop') THEN 1 ELSE 0 END);


