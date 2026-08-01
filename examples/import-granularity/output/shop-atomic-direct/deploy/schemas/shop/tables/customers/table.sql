-- Deploy: schemas/shop/tables/customers/table
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema


CREATE TABLE shop.customers (

);

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

