-- Verify: schemas/shop/tables/orders/columns/order_number


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'order_number' AND table_schema = 'shop') THEN 1 ELSE 0 END);


