-- Revert: schemas/shop/tables/orders/table


REVOKE SELECT, INSERT, UPDATE ON shop.orders FROM app_user RESTRICT;

COMMENT ON TABLE shop.orders IS NULL;

ALTER TABLE shop.orders 
  DISABLE ROW LEVEL SECURITY;

ALTER TABLE ONLY shop.orders 
  DROP CONSTRAINT orders_customer_id_fkey RESTRICT;

DROP TABLE shop.orders;


