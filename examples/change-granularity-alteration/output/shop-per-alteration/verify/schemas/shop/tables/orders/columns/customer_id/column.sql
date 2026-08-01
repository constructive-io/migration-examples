-- Verify: schemas/shop/tables/orders/columns/customer_id/column


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'customer_id' AND table_schema = 'shop') THEN 1 ELSE 0 END);


