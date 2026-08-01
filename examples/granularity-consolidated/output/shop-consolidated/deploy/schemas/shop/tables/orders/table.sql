-- Deploy: schemas/shop/tables/orders/table
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/customers/table


CREATE TABLE shop.orders (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  order_number bigint DEFAULT nextval(CAST('shop.order_number_seq' AS regclass)) NOT NULL,
  customer_id uuid NOT NULL,
  status text DEFAULT 'pending' NOT NULL,
  placed_at timestamptz DEFAULT now() NOT NULL,
  CONSTRAINT orders_pkey PRIMARY KEY (id),
  CONSTRAINT orders_order_number_key 
    UNIQUE (order_number),
  CONSTRAINT orders_status_check 
    CHECK (status IN ('pending', 'paid', 'shipped', 'cancelled')),
  CONSTRAINT orders_customer_id_fkey
    FOREIGN KEY(customer_id)
    REFERENCES shop.customers (id)
);

ALTER TABLE shop.orders 
  ENABLE ROW LEVEL SECURITY;

COMMENT ON TABLE shop.orders IS 'Customer orders; one row per checkout.';

GRANT SELECT, INSERT, UPDATE ON shop.orders TO app_user;

