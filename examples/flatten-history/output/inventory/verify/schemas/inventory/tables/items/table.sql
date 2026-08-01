-- Verify: schemas/inventory/tables/items/table


SELECT 1/(CASE WHEN to_regclass('inventory.items') IS NOT NULL THEN 1 ELSE 0 END);


