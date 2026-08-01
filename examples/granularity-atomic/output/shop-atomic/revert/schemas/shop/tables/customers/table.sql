-- Revert: schemas/shop/tables/customers/table


REVOKE SELECT ON shop.customers FROM app_user RESTRICT;

COMMENT ON COLUMN shop.customers.email IS NULL;

COMMENT ON TABLE shop.customers IS NULL;

ALTER TABLE shop.customers 
  DROP CONSTRAINT customers_email_key RESTRICT;

ALTER TABLE shop.customers 
  DROP CONSTRAINT customers_pkey RESTRICT;

ALTER TABLE shop.customers 
  DROP COLUMN created_at RESTRICT;

ALTER TABLE shop.customers 
  DROP COLUMN phone RESTRICT;

ALTER TABLE shop.customers 
  DROP COLUMN full_name RESTRICT;

ALTER TABLE shop.customers 
  DROP COLUMN email RESTRICT;

ALTER TABLE shop.customers 
  DROP COLUMN id RESTRICT;

DROP TABLE shop.customers;


