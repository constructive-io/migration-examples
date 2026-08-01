-- Deploy: schemas/shop/tables/orders/constraints/orders/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table
-- requires: schemas/shop/tables/customers/table


ALTER TABLE ONLY shop.orders 
  ADD CONSTRAINT orders_customer_id_fkey
    FOREIGN KEY(customer_id)
    REFERENCES shop.customers (id);

ALTER TABLE shop.orders 
  ENABLE ROW LEVEL SECURITY;

COMMENT ON TABLE shop.orders IS 'Customer orders; one row per checkout.';

