-- Revert: schemas/shop/tables/customers/constraints/customers_email_key


REVOKE SELECT ON shop.customers FROM app_user RESTRICT;

COMMENT ON COLUMN shop.customers.email IS NULL;

COMMENT ON TABLE shop.customers IS NULL;

ALTER TABLE ONLY shop.customers 
  DROP CONSTRAINT customers_email_key RESTRICT;


