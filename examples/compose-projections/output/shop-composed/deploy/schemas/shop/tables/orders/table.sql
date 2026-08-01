-- Deploy: schemas/shop/tables/orders/table
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema


CREATE TABLE shop.orders (

);

ALTER TABLE shop.orders 
  ENABLE ROW LEVEL SECURITY;

COMMENT ON TABLE shop.orders IS 'Customer orders; one row per checkout.';

GRANT SELECT, INSERT, UPDATE ON shop.orders TO app_user;

