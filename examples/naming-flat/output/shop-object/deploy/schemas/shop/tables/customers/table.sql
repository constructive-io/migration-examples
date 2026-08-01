-- Deploy: schemas/shop/tables/customers/table
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema


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

COMMENT ON TABLE shop.customers IS 'Registered storefront customers.';

COMMENT ON COLUMN shop.customers.email IS 'Unique login email, lowercased.';

GRANT SELECT ON shop.customers TO app_user;

