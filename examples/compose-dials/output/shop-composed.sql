CREATE SCHEMA shop;

COMMENT ON SCHEMA shop IS 'Storefront: customers, products, orders.';

GRANT USAGE ON SCHEMA shop TO app_user;

CREATE SCHEMA audit;

COMMENT ON SCHEMA audit IS 'Append-only change log for shop tables.';

CREATE SEQUENCE shop.order_number_seq START 1000 INCREMENT 1 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE TABLE shop.customers ();

ALTER TABLE shop.customers 
  ADD COLUMN id uuid
    DEFAULT gen_random_uuid()
    NOT NULL;

ALTER TABLE shop.customers 
  ADD COLUMN email text
    NOT NULL;

ALTER TABLE shop.customers 
  ADD COLUMN full_name text
    NOT NULL;

ALTER TABLE shop.customers 
  ADD COLUMN phone text;

ALTER TABLE shop.customers 
  ADD COLUMN created_at timestamptz
    DEFAULT now()
    NOT NULL;

ALTER TABLE ONLY shop.customers 
  ADD CONSTRAINT customers_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.customers 
  ADD CONSTRAINT customers_email_key 
    UNIQUE (email);

COMMENT ON TABLE shop.customers IS 'Registered storefront customers.';

COMMENT ON COLUMN shop.customers.email IS 'Unique login email, lowercased.';

GRANT SELECT ON shop.customers TO app_user;

CREATE TABLE shop.products ();

ALTER TABLE shop.products 
  ADD COLUMN id uuid
    DEFAULT gen_random_uuid()
    NOT NULL;

ALTER TABLE shop.products 
  ADD COLUMN sku text
    NOT NULL;

ALTER TABLE shop.products 
  ADD COLUMN name text
    NOT NULL;

ALTER TABLE shop.products 
  ADD COLUMN description text;

ALTER TABLE shop.products 
  ADD COLUMN price_cents int
    NOT NULL;

ALTER TABLE shop.products 
  ADD COLUMN created_at timestamptz
    DEFAULT now()
    NOT NULL;

ALTER TABLE ONLY shop.products 
  ADD CONSTRAINT products_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.products 
  ADD CONSTRAINT products_sku_key 
    UNIQUE (sku);

ALTER TABLE shop.products 
  ADD CONSTRAINT products_price_cents_check 
    CHECK (price_cents >= 0);

COMMENT ON TABLE shop.products IS 'Sellable products with price in cents.';

GRANT SELECT ON shop.products TO app_user;

CREATE TABLE shop.orders ();

ALTER TABLE shop.orders 
  ENABLE ROW LEVEL SECURITY;

COMMENT ON TABLE shop.orders IS 'Customer orders; one row per checkout.';

GRANT SELECT, INSERT, UPDATE ON shop.orders TO app_user;

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

CREATE TABLE shop.order_items ();

ALTER TABLE shop.order_items 
  ADD COLUMN id uuid
    DEFAULT gen_random_uuid()
    NOT NULL;

ALTER TABLE shop.order_items 
  ADD COLUMN order_id uuid
    NOT NULL;

ALTER TABLE shop.order_items 
  ADD COLUMN product_id uuid
    NOT NULL;

ALTER TABLE shop.order_items 
  ADD COLUMN quantity int
    DEFAULT 1
    NOT NULL;

ALTER TABLE shop.order_items 
  ADD COLUMN unit_price_cents int
    NOT NULL;

ALTER TABLE ONLY shop.order_items 
  ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.order_items 
  ADD CONSTRAINT order_items_order_id_fkey
    FOREIGN KEY(order_id)
    REFERENCES shop.orders (id)
    ON DELETE CASCADE;

ALTER TABLE ONLY shop.order_items 
  ADD CONSTRAINT order_items_product_id_fkey
    FOREIGN KEY(product_id)
    REFERENCES shop.products (id);

GRANT SELECT, INSERT ON shop.order_items TO app_user;

CREATE TABLE audit.change_log ();

ALTER TABLE audit.change_log 
  ADD COLUMN id bigint
    GENERATED ALWAYS AS IDENTITY
    NOT NULL;

ALTER TABLE audit.change_log 
  ADD COLUMN table_name text
    NOT NULL;

ALTER TABLE audit.change_log 
  ADD COLUMN row_id uuid
    NOT NULL;

ALTER TABLE audit.change_log 
  ADD COLUMN operation text
    NOT NULL;

ALTER TABLE audit.change_log 
  ADD COLUMN changed_at timestamptz
    DEFAULT now()
    NOT NULL;

ALTER TABLE ONLY audit.change_log 
  ADD CONSTRAINT change_log_pkey PRIMARY KEY (id);

CREATE FUNCTION shop.order_total(
  p_order_id uuid
) RETURNS int LANGUAGE sql STABLE AS $EOFCODE$
  SELECT COALESCE(SUM(quantity * unit_price_cents), 0)::integer
  FROM shop.order_items
  WHERE order_id = p_order_id;
$EOFCODE$;

COMMENT ON FUNCTION shop.order_total(p_order_id uuid) IS 'Sum of line totals for an order, in cents.';

CREATE FUNCTION audit.log_order_change() RETURNS trigger LANGUAGE plpgsql AS $EOFCODE$
BEGIN
  INSERT INTO audit.change_log (table_name, row_id, operation)
  VALUES (TG_TABLE_NAME, NEW.id, TG_OP);
  RETURN NEW;
END;
$EOFCODE$;

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
