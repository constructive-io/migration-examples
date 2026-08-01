-- Deploy: schemas/shop/tables/products/table
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema


CREATE TABLE shop.products (

);

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

ALTER TABLE shop.products 
  ADD CONSTRAINT products_pkey PRIMARY KEY (id);

ALTER TABLE shop.products 
  ADD CONSTRAINT products_sku_key 
    UNIQUE (sku);

ALTER TABLE shop.products 
  ADD CONSTRAINT products_price_cents_check 
    CHECK (price_cents >= 0);

COMMENT ON TABLE shop.products IS 'Sellable products with price in cents.';

GRANT SELECT ON shop.products TO app_user;

