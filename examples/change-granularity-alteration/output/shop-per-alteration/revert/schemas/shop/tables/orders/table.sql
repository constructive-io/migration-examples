-- Revert: schemas/shop/tables/orders/table


REVOKE SELECT, INSERT, UPDATE ON shop.orders FROM app_user RESTRICT;

COMMENT ON TABLE shop.orders IS NULL;

ALTER TABLE shop.orders 
  DISABLE ROW LEVEL SECURITY;

DROP TABLE shop.orders;


