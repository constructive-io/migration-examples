-- Revert: schemas/shop/tables/orders/constraints/orders/constraint


COMMENT ON TABLE shop.orders IS NULL;

ALTER TABLE shop.orders 
  DISABLE ROW LEVEL SECURITY;

ALTER TABLE ONLY shop.orders 
  DROP CONSTRAINT orders_customer_id_fkey RESTRICT;


