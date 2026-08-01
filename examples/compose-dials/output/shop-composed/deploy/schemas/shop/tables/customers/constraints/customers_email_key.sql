-- Deploy: schemas/shop/tables/customers/constraints/customers_email_key
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/customers/table
-- requires: schemas/shop/tables/customers/columns/email


ALTER TABLE ONLY shop.customers 
  ADD CONSTRAINT customers_email_key 
    UNIQUE (email);

COMMENT ON TABLE shop.customers IS 'Registered storefront customers.';

COMMENT ON COLUMN shop.customers.email IS 'Unique login email, lowercased.';

GRANT SELECT ON shop.customers TO app_user;

