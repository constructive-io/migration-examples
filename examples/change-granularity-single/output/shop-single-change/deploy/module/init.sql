-- Deploy: module/init
-- made with <3 @ constructive.io




CREATE SCHEMA shop;

CREATE SCHEMA audit;

CREATE SEQUENCE shop.order_number_seq START 1000 INCREMENT 1 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE TABLE shop.customers (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  email text NOT NULL,
  full_name text NOT NULL,
  phone text,
  created_at timestamptz DEFAULT now() NOT NULL,
  CONSTRAINT customers_pkey PRIMARY KEY (id),
  CONSTRAINT customers_email_key 
    UNIQUE (email)
);

CREATE TABLE shop.products (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  sku text NOT NULL,
  name text NOT NULL,
  description text,
  price_cents int NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  CONSTRAINT products_pkey PRIMARY KEY (id),
  CONSTRAINT products_sku_key 
    UNIQUE (sku),
  CONSTRAINT products_price_cents_check 
    CHECK (price_cents >= 0)
);

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

CREATE TABLE shop.order_items (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  order_id uuid NOT NULL,
  product_id uuid NOT NULL,
  quantity int DEFAULT 1 NOT NULL,
  unit_price_cents int NOT NULL,
  CONSTRAINT order_items_pkey PRIMARY KEY (id),
  CONSTRAINT order_items_order_id_fkey
    FOREIGN KEY(order_id)
    REFERENCES shop.orders (id)
    ON DELETE CASCADE,
  CONSTRAINT order_items_product_id_fkey
    FOREIGN KEY(product_id)
    REFERENCES shop.products (id)
);

CREATE TABLE audit.change_log (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  table_name text NOT NULL,
  row_id uuid NOT NULL,
  operation text NOT NULL,
  changed_at timestamptz DEFAULT now() NOT NULL,
  CONSTRAINT change_log_pkey PRIMARY KEY (id)
);

CREATE FUNCTION shop.order_total(
  p_order_id uuid
) RETURNS int LANGUAGE sql STABLE AS $$
  SELECT COALESCE(SUM(quantity * unit_price_cents), 0)::integer
  FROM shop.order_items
  WHERE order_id = p_order_id;
$$;

CREATE FUNCTION audit.log_order_change() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO audit.change_log (table_name, row_id, operation)
  VALUES (TG_TABLE_NAME, NEW.id, TG_OP);
  RETURN NEW;
END;
$$;

CREATE INDEX idx_orders_customer_id ON shop.orders (customer_id);

CREATE INDEX idx_orders_placed_at ON shop.orders (placed_at);

CREATE INDEX idx_order_items_order_id ON shop.order_items (order_id);

CREATE TRIGGER orders_audit_trigger
  AFTER INSERT OR UPDATE
  ON shop.orders
  FOR EACH ROW
  EXECUTE PROCEDURE audit.log_order_change();

CREATE POLICY orders_select_own
  ON shop.orders
  AS PERMISSIVE
  FOR SELECT
  TO PUBLIC
  USING (
    customer_id = (current_setting('app.current_customer_id', true))::uuid
  );

COMMENT ON SCHEMA shop IS 'Storefront: customers, products, orders.';

GRANT USAGE ON SCHEMA shop TO app_user;

COMMENT ON SCHEMA audit IS 'Append-only change log for shop tables.';

COMMENT ON TABLE shop.customers IS 'Registered storefront customers.';

COMMENT ON COLUMN shop.customers.email IS 'Unique login email, lowercased.';

GRANT SELECT ON shop.customers TO app_user;

COMMENT ON TABLE shop.products IS 'Sellable products with price in cents.';

GRANT SELECT ON shop.products TO app_user;

ALTER TABLE shop.orders 
  ENABLE ROW LEVEL SECURITY;

COMMENT ON TABLE shop.orders IS 'Customer orders; one row per checkout.';

GRANT SELECT, INSERT, UPDATE ON shop.orders TO app_user;

GRANT SELECT, INSERT ON shop.order_items TO app_user;

COMMENT ON FUNCTION shop.order_total(p_order_id uuid) IS 'Sum of line totals for an order, in cents.';


