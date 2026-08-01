-- Revert: schemas/shop/tables/orders/table


REVOKE SELECT, INSERT, UPDATE ON shop.orders FROM app_user RESTRICT;

COMMENT ON TABLE shop.orders IS NULL;

ALTER TABLE shop.orders 
  DISABLE ROW LEVEL SECURITY;

ALTER TABLE ONLY shop.orders 
  DROP CONSTRAINT orders_customer_id_fkey RESTRICT;

ALTER TABLE shop.orders 
  DROP CONSTRAINT orders_status_check RESTRICT;

ALTER TABLE shop.orders 
  DROP CONSTRAINT orders_order_number_key RESTRICT;

ALTER TABLE shop.orders 
  DROP CONSTRAINT orders_pkey RESTRICT;

ALTER TABLE shop.orders 
  DROP COLUMN placed_at RESTRICT;

ALTER TABLE shop.orders 
  DROP COLUMN status RESTRICT;

ALTER TABLE shop.orders 
  DROP COLUMN customer_id RESTRICT;

ALTER TABLE shop.orders 
  DROP COLUMN order_number RESTRICT;

ALTER TABLE shop.orders 
  DROP COLUMN id RESTRICT;

DROP TABLE shop.orders;


