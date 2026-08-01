--
-- PostgreSQL database dump
--

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: shop; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA shop;

--
-- Name: SCHEMA shop; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA shop IS 'Storefront: customers, products, orders.';

--
-- Name: audit; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA audit;

--
-- Name: SCHEMA audit; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA audit IS 'Append-only change log for shop tables.';

SET default_tablespace = '';
SET default_table_access_method = heap;

--
-- Name: order_number_seq; Type: SEQUENCE; Schema: shop; Owner: -
--

CREATE SEQUENCE shop.order_number_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: customers; Type: TABLE; Schema: shop; Owner: -
--

CREATE TABLE shop.customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    full_name text NOT NULL,
    phone text,
    created_at timestamptz DEFAULT now() NOT NULL
);

--
-- Name: TABLE customers; Type: COMMENT; Schema: shop; Owner: -
--

COMMENT ON TABLE shop.customers IS 'Registered storefront customers.';

--
-- Name: COLUMN customers.email; Type: COMMENT; Schema: shop; Owner: -
--

COMMENT ON COLUMN shop.customers.email IS 'Unique login email, lowercased.';

--
-- Name: products; Type: TABLE; Schema: shop; Owner: -
--

CREATE TABLE shop.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    sku text NOT NULL,
    name text NOT NULL,
    description text,
    price_cents integer NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL
);

--
-- Name: TABLE products; Type: COMMENT; Schema: shop; Owner: -
--

COMMENT ON TABLE shop.products IS 'Sellable products with price in cents.';

--
-- Name: orders; Type: TABLE; Schema: shop; Owner: -
--

CREATE TABLE shop.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_number bigint DEFAULT nextval('shop.order_number_seq'::regclass) NOT NULL,
    customer_id uuid NOT NULL,
    status text DEFAULT 'pending' NOT NULL,
    placed_at timestamptz DEFAULT now() NOT NULL
);

--
-- Name: TABLE orders; Type: COMMENT; Schema: shop; Owner: -
--

COMMENT ON TABLE shop.orders IS 'Customer orders; one row per checkout.';

--
-- Name: order_items; Type: TABLE; Schema: shop; Owner: -
--

CREATE TABLE shop.order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    unit_price_cents integer NOT NULL
);

--
-- Name: change_log; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.change_log (
    id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    table_name text NOT NULL,
    row_id uuid NOT NULL,
    operation text NOT NULL,
    changed_at timestamptz DEFAULT now() NOT NULL
);

--
-- Name: order_total; Type: FUNCTION; Schema: shop; Owner: -
--

CREATE FUNCTION shop.order_total(p_order_id uuid) RETURNS integer
    LANGUAGE sql STABLE
    AS $$
  SELECT COALESCE(SUM(quantity * unit_price_cents), 0)::integer
  FROM shop.order_items
  WHERE order_id = p_order_id;
$$;

--
-- Name: FUNCTION order_total(p_order_id uuid); Type: COMMENT; Schema: shop; Owner: -
--

COMMENT ON FUNCTION shop.order_total(p_order_id uuid) IS 'Sum of line totals for an order, in cents.';

--
-- Name: log_order_change; Type: FUNCTION; Schema: audit; Owner: -
--

CREATE FUNCTION audit.log_order_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO audit.change_log (table_name, row_id, operation)
  VALUES (TG_TABLE_NAME, NEW.id, TG_OP);
  RETURN NEW;
END;
$$;

--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);

--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);

--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);

--
-- Name: products products_sku_key; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.products
    ADD CONSTRAINT products_sku_key UNIQUE (sku);

--
-- Name: products products_price_cents_check; Type: CHECK CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE shop.products
    ADD CONSTRAINT products_price_cents_check CHECK (price_cents >= 0);

--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);

--
-- Name: orders orders_order_number_key; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.orders
    ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);

--
-- Name: orders orders_status_check; Type: CHECK CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE shop.orders
    ADD CONSTRAINT orders_status_check CHECK (status IN ('pending', 'paid', 'shipped', 'cancelled'));

--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);

--
-- Name: change_log change_log_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.change_log
    ADD CONSTRAINT change_log_pkey PRIMARY KEY (id);

--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES shop.customers(id);

--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES shop.orders(id) ON DELETE CASCADE;

--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.products(id);

--
-- Name: idx_orders_customer_id; Type: INDEX; Schema: shop; Owner: -
--

CREATE INDEX idx_orders_customer_id ON shop.orders USING btree (customer_id);

--
-- Name: idx_orders_placed_at; Type: INDEX; Schema: shop; Owner: -
--

CREATE INDEX idx_orders_placed_at ON shop.orders USING btree (placed_at);

--
-- Name: idx_order_items_order_id; Type: INDEX; Schema: shop; Owner: -
--

CREATE INDEX idx_order_items_order_id ON shop.order_items USING btree (order_id);

--
-- Name: orders orders_audit_trigger; Type: TRIGGER; Schema: shop; Owner: -
--

CREATE TRIGGER orders_audit_trigger
    AFTER INSERT OR UPDATE ON shop.orders
    FOR EACH ROW
    EXECUTE FUNCTION audit.log_order_change();

--
-- Name: orders; Type: ROW SECURITY; Schema: shop; Owner: -
--

ALTER TABLE shop.orders ENABLE ROW LEVEL SECURITY;

--
-- Name: orders orders_select_own; Type: POLICY; Schema: shop; Owner: -
--

CREATE POLICY orders_select_own ON shop.orders
    FOR SELECT
    USING (customer_id = current_setting('app.current_customer_id', true)::uuid);

--
-- Name: SCHEMA shop; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA shop TO app_user;

--
-- Name: TABLE customers; Type: ACL; Schema: shop; Owner: -
--

GRANT SELECT ON TABLE shop.customers TO app_user;

--
-- Name: TABLE products; Type: ACL; Schema: shop; Owner: -
--

GRANT SELECT ON TABLE shop.products TO app_user;

--
-- Name: TABLE orders; Type: ACL; Schema: shop; Owner: -
--

GRANT SELECT, INSERT, UPDATE ON TABLE shop.orders TO app_user;

--
-- Name: TABLE order_items; Type: ACL; Schema: shop; Owner: -
--

GRANT SELECT, INSERT ON TABLE shop.order_items TO app_user;

--
-- PostgreSQL database dump complete
--
