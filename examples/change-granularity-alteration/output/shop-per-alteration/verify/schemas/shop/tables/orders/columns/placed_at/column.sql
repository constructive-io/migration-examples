-- Verify: schemas/shop/tables/orders/columns/placed_at/column


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'placed_at' AND table_schema = 'shop') THEN 1 ELSE 0 END);


