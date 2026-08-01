-- Deploy: schemas/shop/tables/orders/triggers/orders_audit_trigger
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/audit/schema
-- requires: schemas/shop/tables/orders/table
-- requires: schemas/audit/procedures/log_order_change


CREATE TRIGGER orders_audit_trigger
  AFTER INSERT OR UPDATE
  ON shop.orders
  FOR EACH ROW
  EXECUTE PROCEDURE audit.log_order_change();

