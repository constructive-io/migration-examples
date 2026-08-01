-- Revert: module/init


COMMENT ON FUNCTION shop.order_total(p_order_id uuid) IS NULL;

REVOKE SELECT, INSERT ON shop.order_items FROM app_user RESTRICT;

REVOKE SELECT, INSERT, UPDATE ON shop.orders FROM app_user RESTRICT;

COMMENT ON TABLE shop.orders IS NULL;

ALTER TABLE shop.orders 
  DISABLE ROW LEVEL SECURITY;

REVOKE SELECT ON shop.products FROM app_user RESTRICT;

COMMENT ON TABLE shop.products IS NULL;

REVOKE SELECT ON shop.customers FROM app_user RESTRICT;

COMMENT ON COLUMN shop.customers.email IS NULL;

COMMENT ON TABLE shop.customers IS NULL;

COMMENT ON SCHEMA audit IS NULL;

REVOKE USAGE ON SCHEMA shop FROM app_user RESTRICT;

COMMENT ON SCHEMA shop IS NULL;

DROP POLICY orders_select_own ON shop.orders;

DROP TRIGGER orders_audit_trigger ON shop.orders;

DROP INDEX shop.idx_order_items_order_id;

DROP INDEX shop.idx_orders_placed_at;

DROP INDEX shop.idx_orders_customer_id;

DROP FUNCTION audit.log_order_change();

DROP FUNCTION shop.order_total(uuid);

DROP TABLE audit.change_log;

DROP TABLE shop.order_items;

DROP TABLE shop.orders;

DROP TABLE shop.products;

DROP TABLE shop.customers;

DROP SEQUENCE shop.order_number_seq;

DROP SCHEMA audit;

DROP SCHEMA shop;



