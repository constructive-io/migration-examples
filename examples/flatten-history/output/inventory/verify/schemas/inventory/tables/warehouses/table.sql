-- Verify: schemas/inventory/tables/warehouses/table


SELECT 1/(CASE WHEN to_regclass('inventory.warehouses') IS NOT NULL THEN 1 ELSE 0 END);


