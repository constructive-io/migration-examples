-- Verify: schemas/shop/tables/order_items/columns/quantity/column


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'order_items' AND column_name = 'quantity' AND table_schema = 'shop') THEN 1 ELSE 0 END);


