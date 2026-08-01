-- Verify: schemas/shop/tables/customers/table


SELECT 1/(CASE WHEN to_regclass('shop.customers') IS NOT NULL THEN 1 ELSE 0 END);


