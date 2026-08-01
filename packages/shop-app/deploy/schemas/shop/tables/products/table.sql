-- Deploy: schemas/shop/tables/products/table
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema


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

COMMENT ON TABLE shop.products IS 'Sellable products with price in cents.';

