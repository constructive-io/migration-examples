-- Verify: schemas/shop/tables/order_items/columns/unit_price_cents/column


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'order_items' AND column_name = 'unit_price_cents' AND table_schema = 'shop') THEN 1 ELSE 0 END);


