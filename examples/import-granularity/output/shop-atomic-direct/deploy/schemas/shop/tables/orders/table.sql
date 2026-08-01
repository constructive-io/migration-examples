-- Deploy: schemas/shop/tables/orders/table
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/customers/table
-- requires: schemas/shop/sequences/order_number_seq


CREATE TABLE shop.orders (

);

ALTER TABLE shop.orders 
  ADD COLUMN id uuid
    DEFAULT gen_random_uuid()
    NOT NULL;

ALTER TABLE shop.orders 
  ADD COLUMN order_number bigint
    DEFAULT nextval(CAST('shop.order_number_seq' AS regclass))
    NOT NULL;

ALTER TABLE shop.orders 
  ADD COLUMN customer_id uuid
    NOT NULL;

ALTER TABLE shop.orders 
  ADD COLUMN status text
    DEFAULT 'pending'
    NOT NULL;

ALTER TABLE shop.orders 
  ADD COLUMN placed_at timestamptz
    DEFAULT now()
    NOT NULL;

ALTER TABLE ONLY shop.orders 
  ADD CONSTRAINT orders_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.orders 
  ADD CONSTRAINT orders_order_number_key 
    UNIQUE (order_number);

ALTER TABLE shop.orders 
  ADD CONSTRAINT orders_status_check 
    CHECK (status IN ('pending', 'paid', 'shipped', 'cancelled'));

ALTER TABLE ONLY shop.orders 
  ADD CONSTRAINT orders_customer_id_fkey
    FOREIGN KEY(customer_id)
    REFERENCES shop.customers (id);

ALTER TABLE shop.orders 
  ENABLE ROW LEVEL SECURITY;

COMMENT ON TABLE shop.orders IS 'Customer orders; one row per checkout.';

GRANT SELECT, INSERT, UPDATE ON shop.orders TO app_user;

