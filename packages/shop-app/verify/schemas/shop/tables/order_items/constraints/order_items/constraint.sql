-- Verify: schemas/shop/tables/order_items/constraints/order_items/constraint


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'order_items' AND constraint_name = 'order_items_order_id_fkey' AND table_schema = 'shop') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'order_items' AND constraint_name = 'order_items_product_id_fkey' AND table_schema = 'shop') THEN 1 ELSE 0 END);


