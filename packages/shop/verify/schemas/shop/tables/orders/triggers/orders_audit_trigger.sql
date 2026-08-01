-- Verify: schemas/shop/tables/orders/triggers/orders_audit_trigger


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'orders_audit_trigger' AND tgrelid = 'shop.orders'::regclass AND NOT tgisinternal) THEN 1 ELSE 0 END);


